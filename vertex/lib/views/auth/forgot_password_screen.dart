import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/custom_button.dart';

/// شاشة إعادة تعيين كلمة المرور
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthService();
  
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نسيت كلمة المرور'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xl),
                
                // الأيقونة
                _buildIcon(),
                
                const SizedBox(height: AppSpacing.xl),
                
                // الوصف
                _buildDescription(),
                
                const SizedBox(height: AppSpacing.xl),
                
                if (!_emailSent) ...[
                  // حقل البريد الإلكتروني
                  _buildEmailField(),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // زر الإرسال
                  CustomButton(
                    text: 'إرسال رابط إعادة التعيين',
                    onPressed: _isLoading ? null : _handleSendResetEmail,
                    isLoading: _isLoading,
                  ),
                ] else ...[
                  // رسالة النجاح
                  _buildSuccessMessage(),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // زر العودة
                  CustomButton(
                    text: 'العودة لتسجيل الدخول',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.lock_reset,
          size: 50,
          color: AppColors.secondary,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      children: [
        Text(
          _emailSent ? 'تم الإرسال!' : 'إعادة تعيين كلمة المرور',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppSpacing.sm),
        
        Text(
          _emailSent
              ? 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني'
              : 'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleSendResetEmail(),
      decoration: InputDecoration(
        labelText: 'البريد الإلكتروني',
        hintText: 'example@email.com',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'البريد الإلكتروني مطلوب';
        }
        if (!value.contains('@')) {
          return 'البريد الإلكتروني غير صحيح';
        }
        return null;
      },
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.success,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 48,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'تحقق من بريدك الإلكتروني',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'قد يستغرق وصول البريد بضع دقائق. تحقق أيضاً من مجلد الرسائل غير المرغوب فيها.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _handleSendResetEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.sendPasswordResetEmail(
      _emailController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.isSuccess) {
      setState(() => _emailSent = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'حدث خطأ'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
