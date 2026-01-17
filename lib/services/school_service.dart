import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/school_model.dart';
import '../data/models/teacher_model.dart';

class SchoolService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // جلب جميع المحاظر النشطة
  Stream<List<SchoolModel>> getActiveSchools() {
    return _firestore
        .collection('schools')
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SchoolModel.fromFirestore(doc))
              .toList();
        });
  }
  
  // جلب محظرة محددة
  Future<SchoolModel?> getSchool(String schoolId) async {
    try {
      final doc = await _firestore.collection('schools').doc(schoolId).get();
      return doc.exists ? SchoolModel.fromFirestore(doc) : null;
    } catch (e) {
      print('Error getting school: $e');
      return null;
    }
  }
  
  // جلب محفظي محظرة
  Stream<List<TeacherModel>> getSchoolTeachers(String schoolId) {
    return _firestore
        .collection('teachers')
        .where('schoolId', isEqualTo: schoolId)
        .where('isActive', isEqualTo: true)
        .orderBy('fullName')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TeacherModel.fromFirestore(doc))
              .toList();
        });
  }
  
  // التحقق إذا كان المحفظ متاحاً
  Future<bool> isTeacherAvailable(String teacherId) async {
    try {
      final doc = await _firestore.collection('teachers').doc(teacherId).get();
      if (!doc.exists) return false;
      
      final teacher = TeacherModel.fromFirestore(doc);
      return teacher.hasAvailableSlots;
    } catch (e) {
      return false;
    }
  }
}