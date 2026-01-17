import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';

class ParentDashboard extends StatefulWidget {
  final String parentId;
  
  const ParentDashboard({
    super.key,
    required this.parentId,
  });

  @override
  _ParentDashboardState createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  int _selectedIndex = 0;
  
  // ignore: unused_field
  static const List<Widget> _widgetOptions = [
    //_HomeTab(),
    //_ChildrenTab(),
    //_ScheduleTab(),
    //_ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    var widgetOptions;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        title: Text(
          'مرحباً، ${user?.fullName ?? 'ولي الأمر'}',
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, authProvider),
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(fontFamily: 'Tajawal'),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Tajawal'),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'الأبناء',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'الجدول',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'الملف الشخصي',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, AuthProvider authProvider) {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            height: 180,
            width: double.infinity,
            color: const Color(0xFF2E7D32),
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  authProvider.currentUser?.fullName ?? 'ولي الأمر',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  authProvider.currentUser?.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Menu Items
                _buildDrawerItem(
                  icon: Icons.school_outlined,
                  title: 'المحاضرين',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to teachers
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.assignment_outlined,
                  title: 'التقارير',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to reports
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.assessment_outlined,
                  title: 'التقييمات',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to assessments
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.chat_outlined,
                  title: 'المحادثات',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to chats
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.payment_outlined,
                  title: 'الاشتراكات',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to subscriptions
                  },
                ),
                
                const Divider(),
                
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  title: 'الإعدادات',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to settings
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.help_outline,
                  title: 'المساعدة',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to help
                  },
                ),
                
                const Divider(),
                
                // Logout
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'تسجيل الخروج',
                  color: Colors.red,
                  onTap: () async {
                    Navigator.pop(context);
                    await authProvider.logout();
                    // TODO: Navigate to login
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Tajawal',
          color: color ?? Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}

// Tab 1: Home
// ignore: unused_element
class _HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'حفظ متقن',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'تابع تقدم أبنائك\nفي حفظ القرآن الكريم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(Icons.emoji_events_outlined, color: Colors.white, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      '3 محاضر نشطة',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Quick Stats
          const Text(
            'إحصائيات سريعة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          
          const SizedBox(height: 15),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                title: 'الأبناء',
                value: '3',
                icon: Icons.people,
                color: Colors.blue,
              ),
              _buildStatCard(
                title: 'الجلسات',
                value: '12',
                icon: Icons.event_available,
                color: Colors.green,
              ),
              _buildStatCard(
                title: 'الأجزاء المحفوظة',
                value: '5',
                icon: Icons.menu_book,
                color: Colors.orange,
              ),
              _buildStatCard(
                title: 'المهام',
                value: '3',
                icon: Icons.assignment,
                color: Colors.purple,
              ),
            ],
          ),
          
          const SizedBox(height: 30),
          
          // Recent Activities
          const Text(
            'النشاطات الأخيرة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          
          const SizedBox(height: 15),
          
          Column(
            children: [
              _buildActivityItem(
                title: 'محمد - اختبار سورة البقرة',
                subtitle: 'نسبة النجاح: 95%',
                time: 'اليوم، 10:30 ص',
                icon: Icons.assignment_turned_in,
                color: Colors.green,
              ),
              _buildActivityItem(
                title: 'أحمد - حفظ صفحة جديدة',
                subtitle: 'صفحة 25 من سورة آل عمران',
                time: 'أمس، 3:45 م',
                icon: Icons.menu_book,
                color: Colors.blue,
              ),
              _buildActivityItem(
                title: 'تذكير بجلسة',
                subtitle: 'جلسة مع الشيخ خالد غداً',
                time: 'قبل يومين',
                icon: Icons.notifications,
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }
}

// Tab 2: Children
// ignore: unused_element
class _ChildrenTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'أبنائي',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          
          const SizedBox(height: 10),
          
          Text(
            'إدارة وتتبع تقدم أبنائك في المحاظر',
            style: TextStyle(
              color: Colors.grey[600],
              fontFamily: 'Tajawal',
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Add Child Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.green[100]!),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: Colors.green[700],
                  size: 50,
                ),
                const SizedBox(height: 10),
                const Text(
                  'إضافة ابن جديد',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'أضف ابنك لمتابعة تقدمه في المحاظر',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Add child functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('إضافة ابن', style: TextStyle(fontFamily: 'Tajawal')),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Children List
          const Text(
            'قائمة الأبناء',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          
          const SizedBox(height: 15),
          
          Column(
            children: [
              _buildChildItem(
                name: 'محمد أحمد',
                age: '10 سنوات',
                teacher: 'الشيخ خالد',
                progress: 0.8,
              ),
              _buildChildItem(
                name: 'أحمد محمد',
                age: '8 سنوات',
                teacher: 'الشيخ سعد',
                progress: 0.6,
              ),
              _buildChildItem(
                name: 'سارة محمد',
                age: '12 سنة',
                teacher: 'الشيخ فهد',
                progress: 0.9,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChildItem({
    required String name,
    required String age,
    required String teacher,
    required double progress,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFF2E7D32).withOpacity(0.1),
            child: const Icon(
              Icons.person,
              color: Color(0xFF2E7D32),
              size: 25,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.cake, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 5),
                    Text(
                      age,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(width: 15),
                    Icon(Icons.school, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 5),
                    Text(
                      teacher,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  color: const Color(0xFF2E7D32),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}% إتمام',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    Text(
                      '${(progress * 20).toInt()}/20 جزء',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {
              // TODO: Navigate to child details
            },
          ),
        ],
      ),
    );
  }
}

// Tab 3: Schedule
// ignore: unused_element
class _ScheduleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'جدول الحصص',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          
          const SizedBox(height: 10),
          
          Text(
            'متابعة جلسات أبنائك مع المحاضرين',
            style: TextStyle(
              color: Colors.grey[600],
              fontFamily: 'Tajawal',
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Week Selector
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    // TODO: Previous week
                  },
                ),
                const Text(
                  'الأسبوع الحالي',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    // TODO: Next week
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Day Selector
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildDayItem(day: 'الأحد', date: '25', isToday: true),
                _buildDayItem(day: 'الإثنين', date: '26', isToday: false),
                _buildDayItem(day: 'الثلاثاء', date: '27', isToday: false),
                _buildDayItem(day: 'الأربعاء', date: '28', isToday: false),
                _buildDayItem(day: 'الخميس', date: '29', isToday: false),
                _buildDayItem(day: 'الجمعة', date: '30', isToday: false),
                _buildDayItem(day: 'السبت', date: '31', isToday: false),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Schedule List
          const Text(
            'جلسات اليوم',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          
          const SizedBox(height: 15),
          
          Column(
            children: [
              _buildSessionItem(
                time: '4:00 - 5:00 مساءً',
                childName: 'محمد',
                teacher: 'الشيخ خالد',
                subject: 'مراجعة سورة البقرة',
                isCompleted: true,
              ),
              _buildSessionItem(
                time: '5:30 - 6:30 مساءً',
                childName: 'أحمد',
                teacher: 'الشيخ سعد',
                subject: 'حفظ سورة آل عمران',
                isCompleted: false,
              ),
              _buildSessionItem(
                time: '7:00 - 8:00 مساءً',
                childName: 'سارة',
                teacher: 'الشيخ فهد',
                subject: 'تجويد',
                isCompleted: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayItem({
    required String day,
    required String date,
    required bool isToday,
  }) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isToday ? const Color(0xFF2E7D32) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday ? const Color(0xFF2E7D32) : Colors.grey[200]!,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: isToday ? Colors.white : Colors.grey[600],
              fontSize: 12,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 5),
          Text(
            date,
            style: TextStyle(
              color: isToday ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionItem({
    required String time,
    required String childName,
    required String teacher,
    required String subject,
    required bool isCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? Colors.green[100]! : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green[50] : Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isCompleted ? Icons.check_circle : Icons.access_time,
                  color: isCompleted ? Colors.green : Colors.blue,
                  size: 20,
                ),
                const SizedBox(height: 5),
                Text(
                  time.split(' ')[0],
                  style: TextStyle(
                    color: isCompleted ? Colors.green[700] : Colors.blue[700],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 5),
                    Text(
                      childName,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(width: 15),
                    Icon(Icons.school, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 5),
                    Text(
                      teacher,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isCompleted ? Icons.visibility : Icons.video_call,
              color: isCompleted ? Colors.green : const Color(0xFF2E7D32),
            ),
            onPressed: () {
              // TODO: View session details or join
            },
          ),
        ],
      ),
    );
  }
}

// Tab 4: Profile
// ignore: unused_element
class _ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF2E7D32).withOpacity(0.1),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  user?.fullName ?? 'ولي الأمر',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'ولي أمر',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Profile Options
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                _buildProfileOption(
                  icon: Icons.edit,
                  title: 'تعديل الملف الشخصي',
                  onTap: () {
                    // TODO: Edit profile
                  },
                ),
                _buildProfileOption(
                  icon: Icons.notifications,
                  title: 'الإشعارات',
                  onTap: () {
                    // TODO: Notifications settings
                  },
                ),
                _buildProfileOption(
                  icon: Icons.security,
                  title: 'الأمان والخصوصية',
                  onTap: () {
                    // TODO: Security settings
                  },
                ),
                _buildProfileOption(
                  icon: Icons.help,
                  title: 'المساعدة والدعم',
                  onTap: () {
                    // TODO: Help center
                  },
                ),
                _buildProfileOption(
                  icon: Icons.info,
                  title: 'عن التطبيق',
                  onTap: () {
                    // TODO: About app
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Logout Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                await authProvider.logout();
                // TODO: Navigate to login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red[100]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2E7D32)),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Tajawal',
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}