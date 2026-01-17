import 'package:flutter/material.dart';
import 'package:mahadre/features/auth/presentation/screens/parent_dashboard.dart' show ParentDashboard;
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (success && mounted) {
        if (authProvider.isEmailVerified) {
          final user = authProvider.currentUser!;
          
          if (user.isParent) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ParentDashboard(parentId: user.id),
              ),
            );
          } else {
            // TODO: Handle other user types
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('هذه الواجهة مخصصة لأولياء الأمور فقط'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        } else {
          // TODO: Navigate to email verification screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('الرجاء تأكيد بريدك الإلكتروني أولاً'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    }
  }

  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // زر العودة (للمستقبل)
              const SizedBox(height: 10),
              
              // صورة التطبيق
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9F0),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 50,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // العنوان
              Text(
                'مرحباً بعودتك',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  fontFamily: 'Tajawal',
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'سجل الدخول لمتابعة أبنائك في المحاظر',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontFamily: 'Tajawal',
                ),
              ),
              
              const SizedBox(height: 40),
              
              // نموذج تسجيل الدخول
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        }
                        if (value.length < 6) {
                          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _login(),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // تذكرني ونسيت كلمة المرور
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // تذكرني
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                              activeColor: const Color(0xFF2E7D32),
                            ),
                            Text(
                              'تذكرني',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                        
                        // نسيت كلمة المرور
                        TextButton(
                          onPressed: _navigateToForgotPassword,
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                              color: const Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Tajawal',
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
                    
                    // زر تسجيل الدخول
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _login,
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
                                'تسجيل الدخول',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // أو سجل باستخدام
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'أو سجل باستخدام',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // أزرار الوسائط الاجتماعية (للتوسع المستقبلي)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google
                        _buildSocialButton(
                          icon: 'G',
                          color: Colors.red,
                          onPressed: () {
                            // TODO: Implement Google Sign In
                          },
                        ),
                        
                        const SizedBox(width: 20),
                        
                        // Phone
                        _buildSocialButton(
                          icon: '📱',
                          color: Colors.green,
                          onPressed: () {
                            // TODO: Implement Phone Sign In
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // رابط التسجيل الجديد
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ليس لديك حساب؟',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _navigateToSignup,
                          child: Text(
                            'سجل الآن',
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

  Widget _buildSocialButton({
    required String icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Center(
          child: Text(
            icon,
            style: TextStyle(
              fontSize: 24,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}