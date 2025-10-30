# Vertex - منصة اجتماعية إبداعية للمصممين ثلاثيي الأبعاد

## نظرة عامة

**Vertex** هو تطبيق للهواتف الذكية يجمع بين المنافسة، التعلم، والتجارة في منصة واحدة للمصممين ثلاثيي الأبعاد حول العالم.

### الميزات الرئيسية:
- 🏆 **التحديات الأسبوعية:** منافسات أسبوعية بمواضيع محددة
- 🗳️ **نظام التصويت التفاعلي:** تصويت سريع وممتع على التصاميم
- 🎓 **ورشة العمل:** دورات تعليمية من المصممين الفائزين
- 🛒 **المتجر:** بيع وشراء الأصول الرقمية
- 💎 **الاشتراكات:** Prime للمتعلمين و Pro للمصممين
- 🌍 **مجتمع عالمي:** آمن ومحترم للجميع

---

## هيكل المشروع

```
vertex/
├── lib/
│   ├── main.dart                 # نقطة البداية
│   ├── models/                   # نماذج البيانات (User, Challenge, Submission, etc.)
│   ├── views/                    # شاشات التطبيق
│   │   ├── home/                 # الشاشة الرئيسية والتحديات
│   │   ├── profile/              # الملف الشخصي
│   │   ├── workshop/             # ورشة العمل (الدورات)
│   │   ├── marketplace/          # المتجر
│   │   └── auth/                 # تسجيل الدخول والتسجيل
│   ├── controllers/              # منطق الأعمال (Business Logic)
│   ├── services/                 # الخدمات (API, Database, Auth, Payment)
│   │   ├── api_service.dart      # التواصل مع الـ Backend
│   │   ├── auth_service.dart     # خدمة المصادقة
│   │   ├── payment_service.dart  # خدمة الدفع (Stripe)
│   │   └── storage_service.dart  # التخزين المحلي
│   ├── widgets/                  # مكونات قابلة لإعادة الاستخدام
│   ├── themes/                   # الألوان والأنماط
│   ├── utils/                    # أدوات مساعدة
│   └── config/                   # الإعدادات والثوابت
├── assets/                       # الصور والأيقونات
├── test/                         # الاختبارات
└── pubspec.yaml                  # المكتبات والإعدادات
```

---

## التقنيات المستخدمة

### Frontend (التطبيق):
- **Flutter 3.35.7** - إطار العمل الأساسي
- **Dart** - لغة البرمجة
- **Provider/GetX** - إدارة الحالة
- **Firebase** - المصادقة والإشعارات

### Backend (الخادم):
- **PostgreSQL** - قاعدة البيانات (عبر Amazon RDS)
- **REST API** - التواصل بين التطبيق والخادم
- **Stripe** - معالجة المدفوعات والاشتراكات
- **AWS S3** - تخزين الملفات والصور

---

## البدء في التطوير

### المتطلبات:
- Flutter SDK 3.5.0 أو أحدث
- Dart 3.5.0 أو أحدث
- Android Studio / VS Code
- حساب Firebase (للمصادقة والإشعارات)
- حساب Stripe (للمدفوعات)

### التثبيت:

1. **استنساخ المشروع:**
```bash
git clone https://github.com/ripolabs/vertex.git
cd vertex
```

2. **تثبيت المكتبات:**
```bash
flutter pub get
```

3. **إعداد Firebase:**
   - إنشاء مشروع جديد في Firebase Console
   - إضافة ملفات الإعدادات:
     - `android/app/google-services.json`
     - `ios/Runner/GoogleService-Info.plist`

4. **إعداد Stripe:**
   - إنشاء حساب Stripe
   - إضافة مفاتيح API في `lib/config/stripe_config.dart`

5. **تشغيل التطبيق:**
```bash
flutter run
```

---

## المكتبات الأساسية

### UI & Design:
- `google_fonts` - خطوط Google
- `flutter_svg` - دعم SVG
- `cached_network_image` - تحميل الصور مع Cache
- `shimmer` - تأثيرات التحميل

### State Management:
- `provider` - إدارة الحالة البسيطة
- `get` - التنقل وإدارة الحالة المتقدمة

### Networking:
- `http` - طلبات HTTP الأساسية
- `dio` - طلبات HTTP المتقدمة

### Storage:
- `shared_preferences` - التخزين المحلي البسيط
- `sqflite` - قاعدة بيانات محلية
- `flutter_secure_storage` - تخزين آمن للبيانات الحساسة

### Authentication:
- `firebase_core` - Firebase الأساسي
- `firebase_auth` - المصادقة

### Payment:
- `stripe_checkout` - معالجة المدفوعات

### Media:
- `image_picker` - اختيار الصور
- `file_picker` - اختيار الملفات
- `video_player` - تشغيل الفيديو

### Utilities:
- `intl` - التدويل والتنسيق
- `url_launcher` - فتح الروابط
- `share_plus` - مشاركة المحتوى
- `connectivity_plus` - فحص الاتصال بالإنترنت

### Notifications:
- `firebase_messaging` - الإشعارات عبر Firebase
- `flutter_local_notifications` - الإشعارات المحلية

---

## معلومات المشروع

- **اسم التطبيق:** Vertex
- **معرف الحزمة:** com.ripolabs.vertex
- **الإصدار:** 1.0.0+1
- **المنصات المدعومة:** Android, iOS
- **اللغات المدعومة:** العربية، الإنجليزية (قريباً)

---

## الحالة الحالية

✅ **المكتمل:**
- تصميم واجهات المستخدم (UI/UX)
- مخطط قاعدة البيانات الكامل
- البنية التحتية الأساسية للمشروع
- هيكل المجلدات المنظم
- إضافة المكتبات الأساسية

🚧 **قيد التطوير:**
- بناء الشاشات الأساسية
- تطوير الـ Backend API
- تكامل Stripe للمدفوعات
- تكامل Firebase للمصادقة

📋 **القادم:**
- نظام التصويت التفاعلي
- رفع وعرض التصاميم
- نظام الاشتراكات
- المتجر والدورات التعليمية

---

## المساهمة

هذا مشروع خاص حالياً. للاستفسارات، يرجى التواصل مع الفريق.

---

## الترخيص

جميع الحقوق محفوظة © 2025 Ripo Labs

---

## التواصل

- **الموقع:** (قريباً)
- **البريد الإلكتروني:** support@vertex.app
- **Twitter:** @VertexApp

---

**تم الإنشاء بواسطة:** Manus AI Agent  
**التاريخ:** 28 أكتوبر 2025  
**الإصدار:** 1.0.0
