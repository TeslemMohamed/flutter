import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahadre/services/teacher_service.dart' show TeacherService;
import '../data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // تسجيل ولي أمر جديد
  Future<UserModel> signUpParent({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    try {
      // 1. إنشاء حساب في Authentication
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final userId = credential.user!.uid;
      
      // 2. إنشاء مستخدم في Firestore
      final user = UserModel(
        id: userId,
        userType: 'parent',
        fullName: fullName,
        email: email,
        phone: phone,
        emailVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        childrenIds: [],
      );
      
      await _firestore.collection('users').doc(userId).set(user.toFirestore());
      
      // 3. إرسال رابط التحقق
      await credential.user!.sendEmailVerification();
      
      return user;
    } catch (e) {
      throw AuthException(_getErrorMessage(e));
    }
  }
  
  // تسجيل محفظ جديد
  Future<UserModel> signUpTeacher({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String schoolId,
    required String specialization,
  }) async {
    try {
      // 1. إنشاء حساب في Authentication
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final userId = credential.user!.uid;
      
      // 2. إنشاء مستخدم في Firestore
      final user = UserModel(
        id: userId,
        userType: 'teacher',
        fullName: fullName,
        email: email,
        phone: phone,
        emailVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        schoolId: schoolId,
      );
      
      await _firestore.collection('users').doc(userId).set(user.toFirestore());
      
      // 3. إضافة كمعلم في collection teachers
      final TeacherService teacherService = TeacherService();
      await teacherService.addTeacher(
        userId: userId,
        fullName: fullName,
        phone: phone,
        schoolId: schoolId,
        specialization: specialization,
      );
      
      // 4. إرسال رابط التحقق
      await credential.user!.sendEmailVerification();
      
      return user;
    } catch (e) {
      throw AuthException(_getErrorMessage(e));
    }
  }
  
  // تسجيل دخول
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // التحقق من البريد
      if (!credential.user!.emailVerified) {
        await _auth.signOut();
        throw AuthException('الرجاء تأكيد بريدك الإلكتروني أولاً');
      }
      
      return credential.user;
    } catch (e) {
      throw AuthException(_getErrorMessage(e));
    }
  }
  
  // تسجيل خروج
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // جلب بيانات المستخدم الحالي
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;
    
    return UserModel.fromFirestore(doc);
  }
  
  // Stream لبيانات المستخدم
  Stream<UserModel?> get currentUserStream {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.exists ? UserModel.fromFirestore(doc) : null;
    });
  }
  
  // إعادة إرسال رابط التحقق
  Future<void> resendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
  
  // إعادة تعيين كلمة المرور
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
  
  // تحديث الملف الشخصي
  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? phone,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (fullName != null) updateData['fullName'] = fullName;
      if (phone != null) updateData['phone'] = phone;
      
      await _firestore.collection('users').doc(userId).update(updateData);
    } catch (e) {
      throw Exception('فشل في تحديث الملف الشخصي: $e');
    }
  }
  
  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'البريد الإلكتروني مستخدم مسبقاً';
        case 'weak-password':
          return 'كلمة المرور ضعيفة';
        case 'user-not-found':
          return 'المستخدم غير موجود';
        case 'wrong-password':
          return 'كلمة المرور خاطئة';
        case 'invalid-email':
          return 'بريد إلكتروني غير صالح';
        case 'user-disabled':
          return 'الحساب معطل';
        case 'too-many-requests':
          return 'محاولات كثيرة، حاول لاحقاً';
        case 'operation-not-allowed':
          return 'العملية غير مسموحة';
        default:
          return 'حدث خطأ: ${error.message}';
      }
    }
    return 'حدث خطأ غير متوقع';
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  
  @override
  String toString() => message;
}