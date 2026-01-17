import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import 'login_screen.dart';
import 'verify_email_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء الموافقة على الشروط والأحكام'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.signUpParent(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      
      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VerifyEmailScreen()),
        );
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
                'إنشاء حساب جديد',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  fontFamily: 'Tajawal',
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'انضم إلينا لمتابعة أبنائك في المحاظر',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontFamily: 'Tajawal',
                ),
              ),
              
              const SizedBox(height: 40),
              
              // نموذج التسجيل
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // حقل الاسم الكامل
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: 'الاسم الكامل',
                        prefixIcon: const Icon(Icons.person_outline),
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
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم الكامل';
                        }
                        if (value.length < 3) {
                          return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
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
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'بريد إلكتروني غير صالح';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // حقل رقم الهاتف
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        prefixIcon: const Icon(Icons.phone_outlined),
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
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم الهاتف';
                        }
                        if (value.length < 10) {
                          return 'رقم هاتف غير صالح';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // حقل كلمة المرور
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey[500],
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
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
                      obscureText: !_passwordVisible,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        }
                        if (value.length < 6) {
                          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // حقل تأكيد كلمة المرور
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey[500],
                          ),
                          onPressed: () {
                            setState(() {
                              _confirmPasswordVisible = !_confirmPasswordVisible;
                            });
                          },
                        ),
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
                      obscureText: !_confirmPasswordVisible,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء تأكيد كلمة المرور';
                        }
                        if (value != _passwordController.text) {
                          return 'كلمة المرور غير متطابقة';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _signup(),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // شروط الاستخدام
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptTerms = value!;
                            });
                          },
                          activeColor: const Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'أوافق على ',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontFamily: 'Tajawal',
                              ),
                              children: [
                                TextSpan(
                                  text: 'شروط الاستخدام',
                                  style: const TextStyle(
                                    color: Color(0xFF2E7D32),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: ' و'),
                                TextSpan(
                                  text: 'سياسة الخصوصية',
                                  style: const TextStyle(
                                    color: Color(0xFF2E7D32),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                    
                    // زر التسجيل
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _signup,
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
                                'إنشاء حساب',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // رابط تسجيل الدخول
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لديك حساب بالفعل؟',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _navigateToLogin,
                          child: Text(
                            'سجل الدخول',
                            style: TextStyle(
                              color: const Color(0xFF2E7D32),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                      ],
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
}