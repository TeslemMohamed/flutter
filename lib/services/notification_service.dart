import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // جلب إشعارات المستخدم
  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => NotificationModel.fromFirestore(doc))
              .toList();
        });
  }
  
  // إرسال إشعار
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'title': title,
        'message': message,
        'type': type,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
        if (data != null) 'data': data,
      });
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
  
  // إرسال إشعار لولي الأمر عند تسجيل حصة
  Future<void> sendProgressUpdateToParent({
    required String studentId,
    required String teacherId,
    required int fromPage,
    required int toPage,
    required String surah,
    double rating = 0,
  }) async {
    try {
      // جلب بيانات الطالب
      final studentDoc = await _firestore.collection('students').doc(studentId).get();
      if (!studentDoc.exists) return;
      
      final studentData = studentDoc.data() as Map<String, dynamic>;
      final parentId = studentData['parentId'];
      final studentName = studentData['fullName'];
      
      // جلب بيانات المحفظ
      final teacherDoc = await _firestore.collection('teachers').doc(teacherId).get();
      final teacherName = teacherDoc.exists 
          ? (teacherDoc.data() as Map<String, dynamic>)['fullName'] ?? 'المحفظ'
          : 'المحفظ';
      
      await sendNotification(
        userId: parentId,
        title: 'تحديث تقدم $studentName',
        message: 'المحفظ $teacherName سجل حصة جديدة: $surah من صفحة $fromPage إلى $toPage ${rating > 0 ? '(التقييم: $rating/5)' : ''}',
        type: 'progress_update',
        data: {
          'studentId': studentId,
          'teacherId': teacherId,
          'fromPage': fromPage,
          'toPage': toPage,
          'surah': surah,
          'rating': rating,
        },
      );
    } catch (e) {
      print('Error sending progress update: $e');
    }
  }
  
  // تعليم الإشعار كمقروء
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }
  
  // تعليم كل الإشعارات كمقروءة
  Future<void> markAllAsRead(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();
      
      final batch = _firestore.batch();
      
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {
          'isRead': true,
          'readAt': FieldValue.serverTimestamp(),
        });
      }
      
      await batch.commit();
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }
  
  // جلب عدد الإشعارات غير المقروءة
  Stream<int> getUnreadCount(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }
}