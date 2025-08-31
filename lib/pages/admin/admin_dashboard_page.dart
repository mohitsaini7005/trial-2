import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lali/core/constants/colors.dart';
import 'package:lali/widgets/premium_card.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Mock data for dashboard
  final Map<String, dynamic> dashboardStats = {
    'totalUsers': 15847,
    'activeUsers': 8392,
    'totalBookings': 2456,
    'revenue': 1847592.50,
    'growth': 23.5,
    'conversionRate': 12.8,
    'avgOrderValue': 4250.75,
    'customerSatisfaction': 4.7,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tribalBackground,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildAppBar(),
          _buildStatsSection(),
          _buildTabBar(),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildTripsManagementTab(),
            _buildProductsManagementTab(),
            _buildUsersManagementTab(),
            _buildAnalyticsTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Admin Dashboard',
                        style: GoogleFonts.orbitron(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'SUPER ADMIN',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your tribal tourism platform',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Users', '${dashboardStats['totalUsers']}', Icons.people, AppColors.neonBlue)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Active Users', '${dashboardStats['activeUsers']}', Icons.person, AppColors.tribalSecondary)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatCard('Bookings', '${dashboardStats['totalBookings']}', Icons.book_online, AppColors.tribalAccent)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Revenue', '₹${(dashboardStats['revenue'] / 100000).toStringAsFixed(1)}L', Icons.currency_rupee, AppColors.premiumGold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: color,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '+${dashboardStats['growth']}%',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.orbitron(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.tribalText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.tribalPrimary,
          indicatorWeight: 3,
          labelColor: AppColors.tribalPrimary,
          unselectedLabelColor: AppColors.grey,
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Trips'),
            Tab(text: 'Products'),
            Tab(text: 'Users'),
            Tab(text: 'Analytics'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.tribalText,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildActionCard('Add New Trip', Icons.add_location_alt, AppColors.tribalSecondary),
              _buildActionCard('Manage Bookings', Icons.calendar_month, AppColors.tribalAccent),
              _buildActionCard('View Analytics', Icons.analytics, AppColors.neonBlue),
              _buildActionCard('Send Notifications', Icons.notifications_active, AppColors.sunsetOrange),
            ],
          ),
          const SizedBox(height: 24),
          
          Text(
            'Recent Activity',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.tribalText,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      onTap: () {
        // Handle action
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.tribalText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      {'user': 'John Doe', 'action': 'booked Araku Valley Trip', 'time': '2 mins ago', 'type': 'booking'},
      {'user': 'Maya Sharma', 'action': 'purchased Dhokra elephant', 'time': '15 mins ago', 'type': 'purchase'},
      {'user': 'Raj Patel', 'action': 'wrote a review for Bastar experience', 'time': '1 hour ago', 'type': 'review'},
      {'user': 'Admin', 'action': 'added new tribal handicraft product', 'time': '2 hours ago', 'type': 'admin'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getActivityColor(activity['type']).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getActivityIcon(activity['type']),
                  size: 20,
                  color: _getActivityColor(activity['type']),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: activity['user'],
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.tribalText,
                            ),
                          ),
                          TextSpan(
                            text: ' ${activity['action']}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.tribalText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activity['time']!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getActivityColor(String? type) {
    switch (type) {
      case 'booking':
        return AppColors.tribalSecondary;
      case 'purchase':
        return AppColors.tribalAccent;
      case 'review':
        return AppColors.neonBlue;
      case 'admin':
        return AppColors.premiumGold;
      default:
        return AppColors.grey;
    }
  }

  IconData _getActivityIcon(String? type) {
    switch (type) {
      case 'booking':
        return Icons.event_available;
      case 'purchase':
        return Icons.shopping_bag;
      case 'review':
        return Icons.star;
      case 'admin':
        return Icons.admin_panel_settings;
      default:
        return Icons.info;
    }
  }

  Widget _buildTripsManagementTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Trip Management',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.tribalText,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Add new trip
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Trip'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tribalPrimary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTripsList(),
        ],
      ),
    );
  }

  Widget _buildTripsList() {
    final trips = [
      {
        'title': 'Araku Valley Cultural Experience',
        'destination': 'Araku Valley, AP',
        'price': 4500,
        'bookings': 45,
        'rating': 4.8,
        'status': 'Active',
        'image': 'assets/images/araku_trip1.jpg',
      },
      {
        'title': 'Bastar Tribal Adventure',
        'destination': 'Bastar, CG',
        'price': 6800,
        'bookings': 32,
        'rating': 4.6,
        'status': 'Active',
        'image': 'assets/images/bastar_trip1.jpg',
      },
      {
        'title': 'Rajasthan Desert Experience',
        'destination': 'Jaisalmer, RJ',
        'price': 8500,
        'bookings': 28,
        'rating': 4.9,
        'status': 'Pending',
        'image': 'assets/images/rajasthan_trip1.jpg',
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.tribalPrimary.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.lightGrey.withOpacity(0.3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    trip['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.landscape,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip['title']!,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.tribalText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip['destination']!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '₹${trip['price']}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.tribalPrimary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.people,
                          size: 14,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${trip['bookings']}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.tribalAccent,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${trip['rating']}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: trip['status'] == 'Active' 
                          ? AppColors.success.withOpacity(0.1) 
                          : AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      trip['status']!,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: trip['status'] == 'Active' 
                            ? AppColors.success 
                            : AppColors.warning,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert, size: 18),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                      const PopupMenuItem(value: 'analytics', child: Text('Analytics')),
                      const PopupMenuItem(value: 'deactivate', child: Text('Deactivate')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductsManagementTab() {
    return const Center(
      child: Text('Products Management - Coming Soon'),
    );
  }

  Widget _buildUsersManagementTab() {
    return const Center(
      child: Text('Users Management - Coming Soon'),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics Dashboard',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.tribalText,
            ),
          ),
          const SizedBox(height: 16),
          
          // Key Metrics
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.3,
            children: [
              _buildMetricCard('Conversion Rate', '${dashboardStats['conversionRate']}%', Icons.trending_up, AppColors.success),
              _buildMetricCard('Avg Order Value', '₹${dashboardStats['avgOrderValue']}', Icons.attach_money, AppColors.tribalAccent),
              _buildMetricCard('Customer Rating', '${dashboardStats['customerSatisfaction']}/5', Icons.star, AppColors.premiumGold),
              _buildMetricCard('Monthly Growth', '+${dashboardStats['growth']}%', Icons.show_chart, AppColors.neonBlue),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Chart placeholder
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revenue Trend',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.tribalText,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.tribalBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('Chart Placeholder - Integrate with fl_chart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: color,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'LIVE',
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.tribalText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Platform Settings',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.tribalText,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildSettingsSection('General', [
            _buildSettingItem('Platform Name', 'TribalConnect'),
            _buildSettingItem('Commission Rate', '10%'),
            _buildSettingItem('Currency', 'INR (₹)'),
          ]),
          
          _buildSettingsSection('Features', [
            _buildToggleItem('Social Features', true),
            _buildToggleItem('AI Assistant', true),
            _buildToggleItem('Loyalty Program', true),
            _buildToggleItem('Multi-language Support', true),
          ]),
          
          _buildSettingsSection('Notifications', [
            _buildToggleItem('Email Notifications', true),
            _buildToggleItem('Push Notifications', true),
            _buildToggleItem('SMS Notifications', false),
          ]),
          
          _buildSettingsSection('Security', [
            _buildSettingItem('Two-Factor Authentication', 'Enabled'),
            _buildSettingItem('Last Backup', '2 hours ago'),
            _buildSettingItem('Security Level', 'High'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.tribalText,
            ),
          ),
          const SizedBox(height: 12),
          PremiumCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: items,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.lightGrey.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.tribalText,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right,
            size: 18,
            color: AppColors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String title, bool value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.lightGrey.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.tribalText,
              ),
            ),
          ),
          Switch(
            value: value,
            activeColor: AppColors.tribalPrimary,
            onChanged: (newValue) {
              // Handle toggle
            },
          ),
        ],
      ),
    );
  }
}