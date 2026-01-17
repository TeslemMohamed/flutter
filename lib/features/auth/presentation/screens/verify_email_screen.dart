import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import 'login_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isResending = false;

  Future<void> _resendEmail() async {
    setState(() {
      _isResending = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.resendVerificationEmail();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إعادة إرسال رابط التحقق بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  void _backToLogin() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9F0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 60,
                  color: Color(0xFF2E7D32),
                ),
              ),

              const SizedBox(height: 40),

              // Title
              const Text(
                'تأكيد البريد الإلكتروني',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                'لقد أرسلنا رابط التحقق إلى بريدك الإلكتروني. الرجاء التحقق من صندوق الوارد (أو البريد العشوائي) والضغط على الرابط لتفعيل حسابك.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontFamily: 'Tajawal',
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // Resend Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isResending ? null : _resendEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isResending
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'إعادة إرسال الرابط',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Back to Login
              TextButton(
                onPressed: _backToLogin,
                child: const Text(
                  'العودة لتسجيل الدخول',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Info Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[100]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'بعد تأكيد بريدك الإلكتروني، يمكنك العودة وتسجيل الدخول مرة أخرى.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange[900],
                          fontFamily: 'Tajawal',
                        ),
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
}