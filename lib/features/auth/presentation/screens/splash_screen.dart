import 'package:flutter/material.dart';
import 'package:mahadre/features/parent/presentation/screens/parent_dashboard.dart' show ParentDashboard;
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // تأخير بسيط لإظهار الشاشة التمهيدية
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (!mounted) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadUser();
    
    if (!mounted) return;
    
    _navigateBasedOnAuthState(authProvider);
  }

  void _navigateBasedOnAuthState(AuthProvider authProvider) {
    if (!authProvider.isLoggedIn || !authProvider.isEmailVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      final user = authProvider.currentUser!;
      
      if (user.isParent) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ParentDashboard(parentId: user.id),
          ),
        );
      } else if (user.isTeacher) {
        // TODO: Teacher Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الشعار مع حركة بسيطة
            AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9F0),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 70,
                color: Color(0xFF2E7D32),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // اسم التطبيق مع حركة
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: const Text(
                'محاضر',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // وصف التطبيق
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              //delay: const Duration(milliseconds: 200),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 15 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: const Text(
                'متابعة المحاظر القرآنية',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF757575),
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
            
            const SizedBox(height: 50),
            
            // مؤشر التحميل
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOut,
              //delay: const Duration(milliseconds: 400),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF2E7D32).withOpacity(0.8),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // نص التحميل
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOut,
              //delay: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: const Text(
                'جاري التحميل...',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9E9E9E),
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}