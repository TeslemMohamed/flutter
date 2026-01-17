import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isEmailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      await authProvider.resetPassword(_emailController.text.trim());
      
      if (authProvider.error == null && mounted) {
        setState(() {
          _isEmailSent = true;
        });
      }
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة التطبيق
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 40,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // العنوان
              Text(
                'نسيت كلمة المرور',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  fontFamily: 'Tajawal',
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontFamily: 'Tajawal',
                ),
              ),
              
              const SizedBox(height: 40),
              
              if (_isEmailSent)
                // رسالة النجاح
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green[100]!),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 60,
                        color: Colors.green[700],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'تم إرسال رابط إعادة التعيين',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'لقد أرسلنا رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. يرجى التحقق من صندوق الوارد.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Colors.green[700],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'قد يستغرق وصول البريد دقائق قليلة',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontSize: 14,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _navigateToLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'العودة لتسجيل الدخول',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                // نموذج إعادة التعيين
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // صورة توضيحية
                      Container(
                        height: 150,
                        margin: const EdgeInsets.only(bottom: 30),
                        child: Image.asset(
                          'assets/images/forgot_password.png', // تأكد من وجود هذه الصورة في مجلد assets
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F9F0),
                                borderRadius: BorderRadius.circular(75),
                              ),
                              child: const Icon(
                                Icons.lock_reset,
                                size: 70,
                                color: Color(0xFF2E7D32),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // تعليمات
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[100]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue[700],
                              size: 24,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                'سوف نرسل لك رابطاً لإعادة تعيين كلمة المرور عبر البريد الإلكتروني',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // حقل البريد الإلكتروني
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال البريد الإلكتروني';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'بريد إلكتروني غير صالح';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _resetPassword(),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // عرض الأخطاء
                      if (authProvider.error != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[100]!),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  authProvider.error!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      if (authProvider.error != null) const SizedBox(height: 20),
                      
                      // زر إعادة التعيين
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading ? null : _resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'إرسال رابط إعادة التعيين',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 25),
                      
                      // رابط تسجيل الدخول
                      Center(
                        child: GestureDetector(
                          onTap: _navigateToLogin,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                size: 16,
                                color: Color(0xFF2E7D32),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'العودة لتسجيل الدخول',
                                style: TextStyle(
                                  color: const Color(0xFF2E7D32),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // نصائح إضافية
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: Colors.orange[700],
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'نصائح مهمة',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _buildTipItem('تحقق من مجلد البريد المزعج (Spam)'),
                            _buildTipItem('تأكد من صحة البريد الإلكتروني المدخل'),
                            _buildTipItem('إذا لم تستلم البريد، حاول مرة أخرى بعد دقائق'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.green[600],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }
}