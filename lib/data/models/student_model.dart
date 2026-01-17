import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String id;
  final String fullName;
  final String birthDate; // YYYY-MM-DD
  final String parentId;
  final String schoolId;
  final String teacherId;
  final String currentSurah;
  final int currentPage;
  final int totalPagesMemorized;
  final DateTime joinDate;
  final String? notes;
  final String? photoUrl;

  StudentModel({
    required this.id,
    required this.fullName,
    required this.birthDate,
    required this.parentId,
    required this.schoolId,
    required this.teacherId,
    required this.currentSurah,
    required this.currentPage,
    required this.totalPagesMemorized,
    required this.joinDate,
    this.notes,
    this.photoUrl,
  });

  // حساب العمر
  int get age {
    final birth = DateTime.parse(birthDate);
    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  // ============ منشئات متعددة ============
  
  // 1. للمرونة القديمة (من Map + String)
  factory StudentModel.fromFirestoreMap(Map<String, dynamic> data, String id) {
    return StudentModel(
      id: id,
      fullName: data['fullName'] ?? '',
      birthDate: data['birthDate'] ?? '2000-01-01',
      parentId: data['parentId'] ?? '',
      schoolId: data['schoolId'] ?? '',
      teacherId: data['teacherId'] ?? '',
      currentSurah: data['currentSurah'] ?? 'سورة الفاتحة',
      currentPage: data['currentPage'] ?? 1,
      totalPagesMemorized: data['totalPagesMemorized'] ?? 0,
      joinDate: (data['joinDate'] as Timestamp).toDate(),
      notes: data['notes'],
      photoUrl: data['photoUrl'],
    );
  }

  // 2. للـ Service الجديد (من DocumentSnapshot) ✅
  factory StudentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentModel(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      birthDate: data['birthDate'] ?? '2000-01-01',
      parentId: data['parentId'] ?? '',
      schoolId: data['schoolId'] ?? '',
      teacherId: data['teacherId'] ?? '',
      currentSurah: data['currentSurah'] ?? 'سورة الفاتحة',
      currentPage: data['currentPage'] ?? 1,
      totalPagesMemorized: data['totalPagesMemorized'] ?? 0,
      joinDate: (data['joinDate'] as Timestamp).toDate(),
      notes: data['notes'],
      photoUrl: data['photoUrl'],
    );
  }

  // 3. من Map فقط (لحالات خاصة)
  factory StudentModel.fromMap(Map<String, dynamic> data) {
    return StudentModel(
      id: data['id'] ?? '',
      fullName: data['fullName'] ?? '',
      birthDate: data['birthDate'] ?? '2000-01-01',
      parentId: data['parentId'] ?? '',
      schoolId: data['schoolId'] ?? '',
      teacherId: data['teacherId'] ?? '',
      currentSurah: data['currentSurah'] ?? 'سورة الفاتحة',
      currentPage: data['currentPage'] ?? 1,
      totalPagesMemorized: data['totalPagesMemorized'] ?? 0,
      joinDate: DateTime.parse(data['joinDate'] ?? DateTime.now().toIso8601String()),
      notes: data['notes'],
      photoUrl: data['photoUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'birthDate': birthDate,
      'parentId': parentId,
      'schoolId': schoolId,
      'teacherId': teacherId,
      'currentSurah': currentSurah,
      'currentPage': currentPage,
      'totalPagesMemorized': totalPagesMemorized,
      'joinDate': Timestamp.fromDate(joinDate),
      if (notes != null) 'notes': notes,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }

  // تحويل لـ Map (لتخزين محلي أو API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'birthDate': birthDate,
      'parentId': parentId,
      'schoolId': schoolId,
      'teacherId': teacherId,
      'currentSurah': currentSurah,
      'currentPage': currentPage,
      'totalPagesMemorized': totalPagesMemorized,
      'joinDate': joinDate.toIso8601String(),
      'notes': notes,
      'photoUrl': photoUrl,
    };
  }

  // نسخ مع تحديث بعض الحقول
  StudentModel copyWith({
    String? id,
    String? fullName,
    String? birthDate,
    String? parentId,
    String? schoolId,
    String? teacherId,
    String? currentSurah,
    int? currentPage,
    int? totalPagesMemorized,
    DateTime? joinDate,
    String? notes,
    String? photoUrl,
  }) {
    return StudentModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      parentId: parentId ?? this.parentId,
      schoolId: schoolId ?? this.schoolId,
      teacherId: teacherId ?? this.teacherId,
      currentSurah: currentSurah ?? this.currentSurah,
      currentPage: currentPage ?? this.currentPage,
      totalPagesMemorized: totalPagesMemorized ?? this.totalPagesMemorized,
      joinDate: joinDate ?? this.joinDate,
      notes: notes ?? this.notes,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  // معلومات مختصرة
  String get summary {
    return '$fullName (العمر: $age سنة) - $currentSurah صفحة $currentPage';
  }

  @override
  String toString() {
    return 'StudentModel(id: $id, name: $fullName, age: $age, school: $schoolId)';
  }
}