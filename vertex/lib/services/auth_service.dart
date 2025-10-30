import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// خدمة المصادقة الشاملة لتطبيق Vertex
class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// الحصول على المستخدم الحالي
  User? get currentUser => _auth.currentUser;

  /// Stream لمراقبة حالة المصادقة
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// التحقق من تسجيل الدخول
  bool get isSignedIn => _auth.currentUser != null;

  // ============================================================================
  // Email/Password Authentication
  // ============================================================================

  /// إنشاء حساب جديد بالبريد الإلكتروني وكلمة المرور
  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String username,
    String? fullName,
  }) async {
    try {
      // التحقق من صحة البيانات
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        return AuthResult.error('جميع الحقول مطلوبة');
      }

      if (password.length < 6) {
        return AuthResult.error('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      }

      // التحقق من توفر اسم المستخدم
      final isAvailable = await _isUsernameAvailable(username);
      if (!isAvailable) {
        return AuthResult.error('اسم المستخدم مستخدم بالفعل');
      }

      // إنشاء الحساب في Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return AuthResult.error('فشل إنشاء الحساب');
      }

      // إنشاء مستند المستخدم في Firestore
      await _createUserDocument(
        userId: user.uid,
        email: email,
        username: username,
        fullName: fullName,
        authProvider: 'email',
      );

      // تحديث اسم العرض
      await user.updateDisplayName(fullName ?? username);

      return AuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getAuthErrorMessage(e));
    } catch (e) {
      return AuthResult.error('حدث خطأ غير متوقع: ${e.toString()}');
    }
  }

  /// تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return AuthResult.error('البريد الإلكتروني وكلمة المرور مطلوبان');
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return AuthResult.error('فشل تسجيل الدخول');
      }

      // تحديث آخر تسجيل دخول
      await _updateLastLogin(user.uid);

      return AuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getAuthErrorMessage(e));
    } catch (e) {
      return AuthResult.error('حدث خطأ غير متوقع: ${e.toString()}');
    }
  }

  // ============================================================================
  // Google Sign-In
  // ============================================================================

  /// تسجيل الدخول باستخدام Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      // بدء عملية تسجيل الدخول بـ Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // المستخدم ألغى العملية
        return AuthResult.error('تم إلغاء تسجيل الدخول');
      }

      // الحصول على بيانات المصادقة
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // إنشاء بيانات الاعتماد
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // تسجيل الدخول في Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        return AuthResult.error('فشل تسجيل الدخول بـ Google');
      }

      // التحقق من وجود مستند المستخدم في Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) {
        // مستخدم جديد - إنشاء مستند
        final username = await _generateUniqueUsername(
          user.displayName ?? user.email?.split('@')[0] ?? 'user',
        );

        await _createUserDocument(
          userId: user.uid,
          email: user.email!,
          username: username,
          fullName: user.displayName,
          avatarUrl: user.photoURL,
          authProvider: 'google',
        );
      } else {
        // مستخدم موجود - تحديث آخر تسجيل دخول
        await _updateLastLogin(user.uid);
      }

      return AuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getAuthErrorMessage(e));
    } catch (e) {
      return AuthResult.error('حدث خطأ أثناء تسجيل الدخول بـ Google: ${e.toString()}');
    }
  }

  // ============================================================================
  // Password Reset
  // ============================================================================

  /// إرسال رابط إعادة تعيين كلمة المرور
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      if (email.isEmpty) {
        return AuthResult.error('البريد الإلكتروني مطلوب');
      }

      await _auth.sendPasswordResetEmail(email: email);
      return AuthResult.success(null, 
        message: 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني');
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_getAuthErrorMessage(e));
    } catch (e) {
      return AuthResult.error('حدث خطأ غير متوقع: ${e.toString()}');
    }
  }

  // ============================================================================
  // Sign Out
  // ============================================================================

  /// تسجيل الخروج
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      // تجاهل الأخطاء في تسجيل الخروج
    }
  }

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /// إنشاء مستند المستخدم في Firestore
  Future<void> _createUserDocument({
    required String userId,
    required String email,
    required String username,
    String? fullName,
    String? avatarUrl,
    required String authProvider,
  }) async {
    await _firestore.collection('users').doc(userId).set({
      'uid': userId,
      'email': email,
      'username': username,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'bio': null,
      'location': null,
      'website_url': null,
      'auth_provider': authProvider,
      'is_verified': false,
      'subscription_tier': 'free',
      'stripe_customer_id': null,
      'total_submissions': 0,
      'total_wins': 0,
      'total_followers': 0,
      'total_following': 0,
      'created_at': FieldValue.serverTimestamp(),
      'last_login_at': FieldValue.serverTimestamp(),
    });
  }

  /// تحديث آخر تسجيل دخول
  Future<void> _updateLastLogin(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'last_login_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // تجاهل الأخطاء
    }
  }

  /// التحقق من توفر اسم المستخدم
  Future<bool> _isUsernameAvailable(String username) async {
    final query = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .limit(1)
        .get();
    
    return query.docs.isEmpty;
  }

  /// توليد اسم مستخدم فريد
  Future<String> _generateUniqueUsername(String baseName) async {
    String username = baseName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');
    
    if (username.isEmpty) {
      username = 'user';
    }

    // التحقق من التوفر
    if (await _isUsernameAvailable(username)) {
      return username;
    }

    // إضافة أرقام عشوائية
    for (int i = 1; i <= 100; i++) {
      final testUsername = '$username$i';
      if (await _isUsernameAvailable(testUsername)) {
        return testUsername;
      }
    }

    // إذا فشل كل شيء، استخدم timestamp
    return '${username}_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// الحصول على رسالة خطأ واضحة من Firebase
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'operation-not-allowed':
        return 'العملية غير مسموحة';
      case 'user-disabled':
        return 'هذا الحساب معطل';
      case 'user-not-found':
        return 'لا يوجد حساب بهذا البريد الإلكتروني';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'too-many-requests':
        return 'محاولات كثيرة جداً. حاول مرة أخرى لاحقاً';
      case 'network-request-failed':
        return 'خطأ في الاتصال بالإنترنت';
      default:
        return 'حدث خطأ: ${e.message ?? e.code}';
    }
  }
}

// ============================================================================
// Auth Result Class
// ============================================================================

/// نتيجة عملية المصادقة
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? errorMessage;
  final String? successMessage;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.errorMessage,
    this.successMessage,
  });

  factory AuthResult.success(User? user, {String? message}) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      successMessage: message,
    );
  }

  factory AuthResult.error(String message) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }
}
