import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/student_model.dart';
import '../data/models/lesson_model.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // إضافة طالب جديد
  Future<String> addStudent({
    required String fullName,
    required String birthDate,
    required String parentId,
    required String schoolId,
    required String teacherId,
    String currentSurah = 'سورة الفاتحة',
    int currentPage = 1,
  }) async {
    try {
      // 1. إنشاء الطالب
      final studentRef = _firestore.collection('students').doc();
      
      final student = StudentModel(
        id: studentRef.id,
        fullName: fullName,
        birthDate: birthDate,
        parentId: parentId,
        schoolId: schoolId,
        teacherId: teacherId,
        currentSurah: currentSurah,
        currentPage: currentPage,
        totalPagesMemorized: 0,
        joinDate: DateTime.now(),
      );
      
      // 2. حفظ الطالب
      await studentRef.set(student.toFirestore());
      
      // 3. تحديث قائمة أبناء ولي الأمر
      await _firestore.collection('users').doc(parentId).update({
        'childrenIds': FieldValue.arrayUnion([studentRef.id]),
      });
      
      // 4. تحديث قائمة طلاب المحفظ
      await _firestore.collection('teachers').doc(teacherId).update({
        'students': FieldValue.arrayUnion([studentRef.id]),
      });
      
      return studentRef.id;
    } catch (e) {
      throw Exception('فشل في إضافة الطالب: $e');
    }
  }
  
  // جلب أبناء ولي الأمر
  Stream<List<StudentModel>> getParentStudents(String parentId) {
    return _firestore
        .collection('students')
        .where('parentId', isEqualTo: parentId)
        .orderBy('fullName')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => StudentModel.fromFirestore(doc))
              .toList();
        });
  }
  
  // Future لجلب أبناء ولي الأمر (بدون Stream)
  Future<List<StudentModel>> getParentStudentsOnce(String parentId) async {
    final snapshot = await _firestore
        .collection('students')
        .where('parentId', isEqualTo: parentId)
        .orderBy('fullName')
        .get();
    
    return snapshot.docs
        .map((doc) => StudentModel.fromFirestore(doc))
        .toList();
  }
  
  // جلب طلاب المحفظ
  Stream<List<StudentModel>> getTeacherStudents(String teacherId) {
    return _firestore
        .collection('students')
        .where('teacherId', isEqualTo: teacherId)
        .orderBy('fullName')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => StudentModel.fromFirestore(doc))
              .toList();
        });
  }
  
  // جلب حصص الطالب
  Stream<List<LessonModel>> getStudentLessons(String studentId) {
    return _firestore
        .collection('lessons')
        .where('studentId', isEqualTo: studentId)
        .orderBy('date', descending: true)
        .limit(30) // آخر 30 حصة
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => LessonModel.fromFirestore(doc))
              .toList();
        });
  }
  
  // تسجيل حصة جديدة
  Future<void> recordLesson({
    required String studentId,
    required String teacherId,
    required String schoolId,
    required String type,
    required String surah,
    required int fromPage,
    required int toPage,
    required double rating,
    String notes = '',
  }) async {
    try {
      // 1. تسجيل الحصة
      final lessonRef = _firestore.collection('lessons').doc();
      
      final lesson = LessonModel(
        id: lessonRef.id,
        studentId: studentId,
        teacherId: teacherId,
        schoolId: schoolId,
        date: DateTime.now(),
        type: type,
        surah: surah,
        fromPage: fromPage,
        toPage: toPage,
        rating: rating,
        notes: notes,
        status: 'completed',
        createdAt: DateTime.now(),
      );
      
      await lessonRef.set(lesson.toFirestore());
      
      // 2. تحديث تقدم الطالب
      await _firestore.collection('students').doc(studentId).update({
        'currentSurah': surah,
        'currentPage': toPage + 1,
        'totalPagesMemorized': FieldValue.increment(toPage - fromPage + 1),
      });
      
      // 3. إرسال إشعار لولي الأمر
      await _sendNotificationToParent(studentId, teacherId, fromPage, toPage, surah);
      
    } catch (e) {
      throw Exception('فشل في تسجيل الحصة: $e');
    }
  }
  
  Future<void> _sendNotificationToParent(
    String studentId, 
    String teacherId, 
    int fromPage, 
    int toPage, 
    String surah
  ) async {
    final studentDoc = await _firestore.collection('students').doc(studentId).get();
    if (!studentDoc.exists) return;
    
    final studentData = studentDoc.data() as Map<String, dynamic>;
    final parentId = studentData['parentId'];
    
    await _firestore.collection('notifications').add({
      'userId': parentId,
      'title': 'تحديث تقدم ${studentData['fullName']}',
      'message': 'تم حفظ من صفحة $fromPage إلى $toPage من $surah',
      'type': 'progress_update',
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  
  // جلب طالب محدد
  Future<StudentModel?> getStudent(String studentId) async {
    try {
      final doc = await _firestore.collection('students').doc(studentId).get();
      return doc.exists ? StudentModel.fromFirestore(doc) : null;
    } catch (e) {
      print('Error getting student: $e');
      return null;
    }
  }
  
  // تحديث بيانات طالب
  Future<void> updateStudent({
    required String studentId,
    String? currentSurah,
    int? currentPage,
    int? totalPagesMemorized,
    String? notes,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (currentSurah != null) updateData['currentSurah'] = currentSurah;
      if (currentPage != null) updateData['currentPage'] = currentPage;
      if (totalPagesMemorized != null) updateData['totalPagesMemorized'] = totalPagesMemorized;
      if (notes != null) updateData['notes'] = notes;
      
      await _firestore.collection('students').doc(studentId).update(updateData);
    } catch (e) {
      throw Exception('فشل في تحديث بيانات الطالب: $e');
    }
  }
}