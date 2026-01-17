import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  final AuthService _authService = AuthService();
  
  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
  bool get isEmailVerified => _currentUser?.emailVerified ?? false;
  
  // تحميل بيانات المستخدم
  Future<void> loadUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _currentUser = await _authService.getCurrentUser();
    } catch (e) {
      _error = 'فشل في تحميل بيانات المستخدم';
      if (kDebugMode) print('Error loading user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // تسجيل الدخول
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _authService.signIn(email, password);
      await loadUser();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // تسجيل ولي أمر جديد
  Future<bool> signUpParent({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _currentUser = await _authService.signUpParent(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // تسجيل الخروج
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _authService.signOut();
      _currentUser = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // إعادة إرسال رابط التحقق
  Future<void> resendVerificationEmail() async {
    try {
      await _authService.resendVerificationEmail();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
  
  // إعادة تعيين كلمة المرور
  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // مسح الأخطاء
  void clearError() {
    _error = null;
    notifyListeners();
  }
}