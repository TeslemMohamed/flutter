import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel {
  final String id;
  final String studentId;
  final String teacherId;
  final String schoolId;
  final DateTime date;
  final String type; // "حفظ جديد", "مراجعة", "اختبار"
  final String surah;
  final int fromPage;
  final int toPage;
  final double rating; // من 0 إلى 5
  final String notes;
  final String status; // "completed", "absent", "postponed"
  final DateTime createdAt;

  LessonModel({
    required this.id,
    required this.studentId,
    required this.teacherId,
    required this.schoolId,
    required this.date,
    required this.type,
    required this.surah,
    required this.fromPage,
    required this.toPage,
    required this.rating,
    required this.notes,
    required this.status,
    required this.createdAt,
  });

  // ============ منشئات متعددة ============

  // 1. من DocumentSnapshot
  factory LessonModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // تحويل num إلى int بشكل آمن
    int safeInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }
    
    // تحويل num إلى double بشكل آمن
    double safeDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }
    
    // تحويل Timestamp بشكل آمن
    DateTime safeDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    return LessonModel(
      id: doc.id,
      studentId: data['studentId']?.toString() ?? '',
      teacherId: data['teacherId']?.toString() ?? '',
      schoolId: data['schoolId']?.toString() ?? '',
      date: safeDateTime(data['date']),
      type: data['type']?.toString() ?? 'حفظ جديد',
      surah: data['surah']?.toString() ?? '',
      fromPage: safeInt(data['fromPage']),
      toPage: safeInt(data['toPage']),
      rating: safeDouble(data['rating']),
      notes: data['notes']?.toString() ?? '',
      status: data['status']?.toString() ?? 'completed',
      createdAt: safeDateTime(data['createdAt']),
    );
  }

  // 2. من Map + String (للتوافق)
  factory LessonModel.fromFirestoreMap(Map<String, dynamic> data, String id) {
    // نفس دوال التحويل الآمن
    int safeInt(dynamic value) => LessonModel._safeInt(value);
    double safeDouble(dynamic value) => LessonModel._safeDouble(value);
    DateTime safeDateTime(dynamic value) => LessonModel._safeDateTime(value);

    return LessonModel(
      id: id,
      studentId: data['studentId']?.toString() ?? '',
      teacherId: data['teacherId']?.toString() ?? '',
      schoolId: data['schoolId']?.toString() ?? '',
      date: safeDateTime(data['date']),
      type: data['type']?.toString() ?? 'حفظ جديد',
      surah: data['surah']?.toString() ?? '',
      fromPage: safeInt(data['fromPage']),
      toPage: safeInt(data['toPage']),
      rating: safeDouble(data['rating']),
      notes: data['notes']?.toString() ?? '',
      status: data['status']?.toString() ?? 'completed',
      createdAt: safeDateTime(data['createdAt']),
    );
  }

  // ============ دوال التحويل الآمنة (static للاستخدام الخارجي) ============
  static int _safeInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is num) return value.toInt();
    return 0;
  }

  static double _safeDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is num) return value.toDouble();
    return 0.0;
  }

  static DateTime _safeDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  // ignore: unused_element
  static String _safeString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  // ============ التحويل لـ Firestore ============
  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'teacherId': teacherId,
      'schoolId': schoolId,
      'date': Timestamp.fromDate(date),
      'type': type,
      'surah': surah,
      'fromPage': fromPage,
      'toPage': toPage,
      'rating': rating,
      'notes': notes,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // ============ دوال مساعدة ============
  
  // عدد الصفحات المحفوظة في هذه الحصة
  int get pagesMemorized {
    if (status == 'completed' && type != 'غياب') {
      return (toPage - fromPage + 1).clamp(0, 604); // لا تتجاوز صفحات المصحف
    }
    return 0;
  }

  // هل الحصة ناجحة؟
  bool get isSuccessful => rating >= 3.0 && status == 'completed';

  // تنسيق التاريخ
  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  // الوقت المنقضي
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      return 'قبل ${(difference.inDays / 365).floor()} سنة';
    } else if (difference.inDays > 30) {
      return 'قبل ${(difference.inDays / 30).floor()} شهر';
    } else if (difference.inDays > 0) {
      return 'قبل ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'قبل ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'قبل ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  // تقدم في هذه الحصة
  String get progressSummary {
    if (status == 'absent') {
      return 'غياب: $notes';
    } else if (status == 'completed') {
      return '$pagesMemorized صفحة من $surah (التقييم: ${rating.toStringAsFixed(1)}/5)';
    }
    return 'حصة $type';
  }

  // التحقق من صحة البيانات
  void validate() {
    if (fromPage < 1 || fromPage > 604) {
      throw ArgumentError('fromPage يجب أن يكون بين 1 و 604');
    }
    if (toPage < fromPage || toPage > 604) {
      throw ArgumentError('toPage يجب أن يكون بين fromPage و 604');
    }
    if (rating < 0 || rating > 5) {
      throw ArgumentError('rating يجب أن يكون بين 0 و 5');
    }
    if (!['completed', 'absent', 'postponed'].contains(status)) {
      throw ArgumentError('status غير صالح');
    }
    if (!['حفظ جديد', 'مراجعة', 'اختبار', 'غياب'].contains(type)) {
      throw ArgumentError('type غير صالح');
    }
  }

  // نسخ مع تحديث
  LessonModel copyWith({
    String? id,
    String? studentId,
    String? teacherId,
    String? schoolId,
    DateTime? date,
    String? type,
    String? surah,
    int? fromPage,
    int? toPage,
    double? rating,
    String? notes,
    String? status,
    DateTime? createdAt,
  }) {
    return LessonModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      teacherId: teacherId ?? this.teacherId,
      schoolId: schoolId ?? this.schoolId,
      date: date ?? this.date,
      type: type ?? this.type,
      surah: surah ?? this.surah,
      fromPage: fromPage ?? this.fromPage,
      toPage: toPage ?? this.toPage,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'LessonModel(id: $id, student: $studentId, surah: $surah, pages: $fromPage-$toPage, rating: $rating)';
  }
}