import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/lesson_model.dart';

class LessonService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // تسجيل حصة جديدة
  Future<String> recordLesson({
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
      
      return lessonRef.id;
    } catch (e) {
      throw Exception('فشل في تسجيل الحصة: $e');
    }
  }
  
  // تسجيل غياب
  Future<void> recordAbsence({
    required String studentId,
    required String teacherId,
    required String schoolId,
    required DateTime date,
    String reason = '',
  }) async {
    try {
      final lessonRef = _firestore.collection('lessons').doc();
      
      final lesson = LessonModel(
        id: lessonRef.id,
        studentId: studentId,
        teacherId: teacherId,
        schoolId: schoolId,
        date: date,
        type: 'غياب',
        surah: '',
        fromPage: 0,
        toPage: 0,
        rating: 0,
        notes: reason.isNotEmpty ? 'سبب الغياب: $reason' : 'غياب',
        status: 'absent',
        createdAt: DateTime.now(),
      );
      
      await lessonRef.set(lesson.toFirestore());
    } catch (e) {
      throw Exception('فشل في تسجيل الغياب: $e');
    }
  }
  
  // جلب حصص الطالب خلال فترة
  Stream<List<LessonModel>> getStudentLessonsBetweenDates({
    required String studentId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _firestore
        .collection('lessons')
        .where('studentId', isEqualTo: studentId)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => LessonModel.fromFirestore(doc))
              .toList();
        });
  }
  
  // جلب إحصائيات الحصص
  Future<Map<String, dynamic>> getLessonStats({
    required String studentId,
    required int daysBack,
  }) async {
    final startDate = DateTime.now().subtract(Duration(days: daysBack));
    
    final snapshot = await _firestore
        .collection('lessons')
        .where('studentId', isEqualTo: studentId)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .get();
    
    int totalLessons = 0;
    int completedLessons = 0;
    int absentLessons = 0;
    double totalRating = 0;
    int? totalPages = 0;
    
    for (var doc in snapshot.docs) {
      final data = doc.data();
      totalLessons++;
      
      if (data['status'] == 'completed') {
        completedLessons++;
        totalRating += data['rating'] ?? 0;
       // totalPages += (data['toPage'] ?? 0) - (data['fromPage'] ?? 0) + 1;
      } else if (data['status'] == 'absent') {
        absentLessons++;
      }
    }
    
    return {
      'totalLessons': totalLessons,
      'completedLessons': completedLessons,
      'absentLessons': absentLessons,
      'attendanceRate': totalLessons > 0 
          ? (completedLessons / totalLessons * 100).round() 
          : 0,
      'averageRating': completedLessons > 0 
          ? (totalRating / completedLessons).toStringAsFixed(1) 
          : '0.0',
      'totalPagesMemorized': totalPages,
      'averagePagesPerLesson': completedLessons > 0 
          ? (totalPages / completedLessons).toStringAsFixed(1) 
          : '0.0',
    };
  }
  
  // تحديث حصة
  Future<void> updateLesson({
    required String lessonId,
    String? surah,
    int? fromPage,
    int? toPage,
    double? rating,
    String? notes,
    String? status,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (surah != null) updateData['surah'] = surah;
      if (fromPage != null) updateData['fromPage'] = fromPage;
      if (toPage != null) updateData['toPage'] = toPage;
      if (rating != null) updateData['rating'] = rating;
      if (notes != null) updateData['notes'] = notes;
      if (status != null) updateData['status'] = status;
      
      await _firestore.collection('lessons').doc(lessonId).update(updateData);
    } catch (e) {
      throw Exception('فشل في تحديث الحصة: $e');
    }
  }
}