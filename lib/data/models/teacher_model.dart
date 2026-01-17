import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherModel {
  final String id;
  final String userId; // مرجع للمستخدم
  final String fullName;
  final String phone;
  final String schoolId;
  final String specialization; // "حفظ"، "مراجعة"، "تجويد"
  final List<String> students; // طلابه
  final bool isActive;
  final DateTime joinedAt;
  final String? bio;
  final String? photoUrl;
  final int maxStudents; // الحد الأقصى للطلاب

  TeacherModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.schoolId,
    required this.specialization,
    required this.students,
    required this.isActive,
    required this.joinedAt,
    this.bio,
    this.photoUrl,
    this.maxStudents = 30, // حد افتراضي
  });

  factory TeacherModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TeacherModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      fullName: data['fullName'] ?? '',
      phone: data['phone'] ?? '',
      schoolId: data['schoolId'] ?? '',
      specialization: data['specialization'] ?? 'حفظ',
      students: List<String>.from(data['students'] ?? []),
      isActive: data['isActive'] ?? true,
      joinedAt: (data['joinedAt'] as Timestamp).toDate(),
      bio: data['bio'],
      photoUrl: data['photoUrl'],
      maxStudents: data['maxStudents'] ?? 30,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'fullName': fullName,
      'phone': phone,
      'schoolId': schoolId,
      'specialization': specialization,
      'students': students,
      'isActive': isActive,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'maxStudents': maxStudents,
      'updatedAt': FieldValue.serverTimestamp(),
      if (bio != null) 'bio': bio,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }

  // نسخ مع تحديث
  TeacherModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? phone,
    String? schoolId,
    String? specialization,
    List<String>? students,
    bool? isActive,
    DateTime? joinedAt,
    String? bio,
    String? photoUrl,
    int? maxStudents,
  }) {
    return TeacherModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      schoolId: schoolId ?? this.schoolId,
      specialization: specialization ?? this.specialization,
      students: students ?? this.students,
      isActive: isActive ?? this.isActive,
      joinedAt: joinedAt ?? this.joinedAt,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      maxStudents: maxStudents ?? this.maxStudents,
    );
  }

  // هل المحفظ متاح لاستقبال طلاب جدد؟
  bool get hasAvailableSlots => students.length < maxStudents;

  // عدد الطلاب الحاليين
  int get studentsCount => students.length;

  // عدد المقاعد المتاحة
  int get availableSlots => maxStudents - students.length;

  // مدة العمل في المحظرة (بالسنوات)
  int get experienceYears {
    final now = DateTime.now();
    return now.year - joinedAt.year;
  }

  // معلومات مختصرة
  String get summary {
    return '$fullName - $specialization (${students.length}/$maxStudents)';
  }

  @override
  String toString() {
    return 'TeacherModel(id: $id, name: $fullName, school: $schoolId, students: ${students.length})';
  }
}