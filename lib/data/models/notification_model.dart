import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // "progress_update", "new_message", "system"
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data; // بيانات إضافية

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.data,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      type: data['type'] ?? 'system',
      isRead: data['isRead'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      data: data['data'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
      if (data != null) 'data': data,
    };
  }

  // علامة جديدة
  String get isNewBadge => isRead ? '' : 'جديد';

  // لون حسب النوع
  String get iconByType {
    switch (type) {
      case 'progress_update':
        return '📊';
      case 'new_message':
        return '💬';
      case 'system':
        return '🔔';
      default:
        return '📌';
    }
  }
}