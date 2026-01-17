import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/teacher_model.dart';
import '../data/models/student_model.dart';
import '../data/models/lesson_model.dart';

class TeacherService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // جلب محفظ محدد
  Future<TeacherModel?> getTeacher(String teacherId) async {
    try {
      final doc = await _firestore.collection('teachers').doc(teacherId).get();
      return doc.exists ? TeacherModel.fromFirestore(doc) : null;
    } catch (e) {
      print('Error getting teacher: $e');
      return null;
    }
  }
  
  // جلب محفظ بواسطة userId
  Future<TeacherModel?> getTeacherByUserId(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('teachers')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();
      
      return snapshot.docs.isNotEmpty 
          ? TeacherModel.fromFirestore(snapshot.docs.first)
          : null;
    } catch (e) {
      print('Error getting teacher by userId: $e');
      return null;
    }
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
  
  // جبل حصص المحفظ
  Stream<List<LessonModel>> getTeacherLessons(String teacherId, {DateTime? fromDate}) {
    Query query = _firestore
        .collection('lessons')
        .where('teacherId', isEqualTo: teacherId)
        .orderBy('date', descending: true);
    
    if (fromDate != null) {
      query = query.where('date', isGreaterThanOrEqualTo: fromDate);
    }
    
    return query
        .limit(50)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => LessonModel.fromFirestore(doc))
              .toList();
        });
  }
  
  // إضافة محفظ جديد
  Future<String> addTeacher({
    required String userId,
    required String fullName,
    required String phone,
    required String schoolId,
    required String specialization,
    int maxStudents = 30,
  }) async {
    try {
      final teacherRef = _firestore.collection('teachers').doc();
      
      final teacher = TeacherModel(
        id: teacherRef.id,
        userId: userId,
        fullName: fullName,
        phone: phone,
        schoolId: schoolId,
        specialization: specialization,
        students: [],
        isActive: true,
        joinedAt: DateTime.now(),
        maxStudents: maxStudents,
      );
      
      await teacherRef.set(teacher.toFirestore());
      
      // تحديث قائمة المحفظين في المحظرة
      await _firestore.collection('schools').doc(schoolId).update({
        'teachers': FieldValue.arrayUnion([teacherRef.id]),
      });
      
      return teacherRef.id;
    } catch (e) {
      throw Exception('فشل في إضافة المحفظ: $e');
    }
  }
  
  // تحديث بيانات المحفظ
  Future<void> updateTeacher({
    required String teacherId,
    String? fullName,
    String? phone,
    String? specialization,
    String? bio,
    int? maxStudents,
    bool? isActive,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (fullName != null) updateData['fullName'] = fullName;
      if (phone != null) updateData['phone'] = phone;
      if (specialization != null) updateData['specialization'] = specialization;
      if (bio != null) updateData['bio'] = bio;
      if (maxStudents != null) updateData['maxStudents'] = maxStudents;
      if (isActive != null) updateData['isActive'] = isActive;
      
      await _firestore.collection('teachers').doc(teacherId).update(updateData);
    } catch (e) {
      throw Exception('فشل في تحديث بيانات المحفظ: $e');
    }
  }
  
  // جلب إحصائيات المحفظ
  Future<Map<String, dynamic>> getTeacherStats(String teacherId) async {
    try {
      final teacher = await getTeacher(teacherId);
      if (teacher == null) throw Exception('المحفظ غير موجود');
      
      final students = await _firestore
          .collection('students')
          .where('teacherId', isEqualTo: teacherId)
          .get();
      
      // حساب متوسط التقييم
      final lessonsSnapshot = await _firestore
          .collection('lessons')
          .where('teacherId', isEqualTo: teacherId)
          .where('date', isGreaterThanOrEqualTo: 
              DateTime.now().subtract(Duration(days: 30)))
          .get();
      
      double totalRating = 0;
      int ratedLessons = 0;
      
      for (var doc in lessonsSnapshot.docs) {
        final rating = doc['rating'] ?? 0.0;
        if (rating > 0) {
          totalRating += rating;
          ratedLessons++;
        }
      }
      
      return {
        'totalStudents': students.size,
        'availableSlots': teacher.availableSlots,
        'averageRating': ratedLessons > 0 ? totalRating / ratedLessons : 0,
        'totalLessonsLastMonth': lessonsSnapshot.size,
        'specialization': teacher.specialization,
      };
    } catch (e) {
      throw Exception('فشل في جلب إحصائيات المحفظ: $e');
    }
  }
}