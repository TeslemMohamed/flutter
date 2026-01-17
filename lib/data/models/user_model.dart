import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String userType; // 'parent', 'teacher', 'admin'
  final String fullName;
  final String email;
  final String phone;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? schoolId; // للمعلمين فقط
  final List<String>? childrenIds; // لأولياء الأمور فقط

  UserModel({
    required this.id,
    required this.userType,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.emailVerified,
    required this.createdAt,
    required this.updatedAt,
    this.schoolId,
    this.childrenIds,
  });

  // ============ منشئات متعددة ============

  // 1. من DocumentSnapshot (للخدمات الجديدة)
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      userType: data['userType'] ?? 'parent',
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      emailVerified: data['emailVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      schoolId: data['schoolId'],
      childrenIds: List<String>.from(data['childrenIds'] ?? []),
    );
  }

  // 2. من Map + String (للتوافق مع الخدمات القديمة)
  factory UserModel.fromFirestoreMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      userType: data['userType'] ?? 'parent',
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      emailVerified: data['emailVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      schoolId: data['schoolId'],
      childrenIds: List<String>.from(data['childrenIds'] ?? []),
    );
  }

  // 3. من Map فقط
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      userType: data['userType'] ?? 'parent',
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      emailVerified: data['emailVerified'] ?? false,
      createdAt: DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(data['updatedAt'] ?? DateTime.now().toIso8601String()),
      schoolId: data['schoolId'],
      childrenIds: List<String>.from(data['childrenIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userType': userType,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'emailVerified': emailVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      if (schoolId != null) 'schoolId': schoolId,
      if (childrenIds != null && childrenIds!.isNotEmpty) 'childrenIds': childrenIds,
    };
  }

  // تحويل لـ Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userType': userType,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'emailVerified': emailVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'schoolId': schoolId,
      'childrenIds': childrenIds,
    };
  }

  // نسخ مع تحديث
  UserModel copyWith({
    String? id,
    String? userType,
    String? fullName,
    String? email,
    String? phone,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? schoolId,
    List<String>? childrenIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      userType: userType ?? this.userType,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      schoolId: schoolId ?? this.schoolId,
      childrenIds: childrenIds ?? this.childrenIds,
    );
  }

  // دوال مساعدة
  bool get isParent => userType == 'parent';
  bool get isTeacher => userType == 'teacher';
  bool get isAdmin => userType == 'admin';

  String get userTypeArabic {
    switch (userType) {
      case 'parent':
        return 'ولي أمر';
      case 'teacher':
        return 'محفظ';
      case 'admin':
        return 'مشرف';
      default:
        return 'مستخدم';
    }
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $fullName, type: $userType)';
  }
}