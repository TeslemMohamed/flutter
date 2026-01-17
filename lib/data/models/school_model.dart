import 'package:cloud_firestore/cloud_firestore.dart';

class SchoolModel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String managerId; // المدير/المشرف
  final List<String> teachers; // قائمة المحفظين
  final DateTime createdAt;
  final String? logoUrl;
  final String? description;
  final bool isActive;

  SchoolModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.managerId,
    required this.teachers,
    required this.createdAt,
    this.logoUrl,
    this.description,
    this.isActive = true,
  });

  // من Firebase إلى Model
  factory SchoolModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SchoolModel(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      managerId: data['managerId'] ?? '',
      teachers: List<String>.from(data['teachers'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      logoUrl: data['logoUrl'],
      description: data['description'],
      isActive: data['isActive'] ?? true,
    );
  }

  // من Model إلى Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'managerId': managerId,
      'teachers': teachers,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (description != null) 'description': description,
    };
  }

  // نسخ مع تحديث بعض الحقول
  SchoolModel copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    String? managerId,
    List<String>? teachers,
    DateTime? createdAt,
    String? logoUrl,
    String? description,
    bool? isActive,
  }) {
    return SchoolModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      managerId: managerId ?? this.managerId,
      teachers: teachers ?? this.teachers,
      createdAt: createdAt ?? this.createdAt,
      logoUrl: logoUrl ?? this.logoUrl,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }

  // التحقق إذا كانت المحظرة نشطة
  bool get isActiveSchool => isActive;

  // عدد المحفظين
  int get teachersCount => teachers.length;

  // تنسيق العنوان
  String get formattedAddress {
    if (address.isEmpty) return 'لم يتم تحديد العنوان';
    return address;
  }

  // معلومات مختصرة
  String get summary {
    return '$name - $address';
  }

  @override
  String toString() {
    return 'SchoolModel(id: $id, name: $name, address: $address, teachers: ${teachers.length})';
  }
}