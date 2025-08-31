import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lali/core/constants/colors.dart';
import 'package:lali/router/app_routes.dart';
import 'package:lali/widgets/mydrawer.dart';

// Main home page widget
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  // Controllers and state variables
  late final TextEditingController _searchController;
  late final TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _tabController = TabController(length: 4, vsync: this);
    
    _searchController.addListener(_onSearchTextChanged);
  }
  
  void _onSearchTextChanged() {
    // Search functionality will be implemented here
    if (mounted) {
      setState(() {
        // Update search results based on _searchController.text
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Navigation methods
  void goToProfilePage() {
    if (kDebugMode) {
      debugPrint('🔄 Navigating to profile page...');
      debugPrint('Route: ${AppRoutes.profile}');
    }

    // Close drawer if open
    if (Scaffold.of(context).isDrawerOpen) {
      Navigator.pop(context);
    }

    // Try standard navigation first
    try {
      Navigator.pushNamed(context, AppRoutes.profile).then((_) {
        if (kDebugMode) {
          debugPrint('✅ Profile page navigation completed');
        }
      }).catchError((e) {
        if (kDebugMode) {
          debugPrint('❌ Navigator.pushNamed failed: $e');
        }
        _navigateWithGetX();
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Navigation failed: $e');
      }
      _navigateWithGetX();
    }
  }

  void _navigateWithGetX() {
    try {
      Get.toNamed(
        AppRoutes.profile,
        preventDuplicates: false,
      )?.then((_) {
        if (kDebugMode) {
          debugPrint('✅ GetX navigation to profile completed');
        }
      }).catchError((e) {
        if (kDebugMode) {
          debugPrint('❌ GetX navigation failed: $e');
        }
        _showNavigationError();
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ GetX navigation threw exception: $e');
      }
      _showNavigationError();
    }
  }

  void _showNavigationError() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open profile. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Navigation helper methods
  void _navigateToEvents() {
    if (kDebugMode) debugPrint('Navigating to events page');
    Get.toNamed(AppRoutes.events);
  }

  void _navigateToTribalStays() {
    if (kDebugMode) debugPrint('Navigating to tribal stays page');
    Get.toNamed(AppRoutes.tribalStays);
  }

  void _navigateToFoodAccommodation() {
    if (kDebugMode) debugPrint('Navigating to food & accommodation page');
    Get.toNamed(AppRoutes.foodAccommodation);
  }

  void _navigateToMarketplace() {
    if (kDebugMode) debugPrint('Navigating to marketplace page');
    Get.toNamed(AppRoutes.marketplace);
  }

  Future<void> signOut() async {
    try {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error signing out. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // UI Components
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryItem('Stays', Icons.hotel, _navigateToTribalStays),
                _buildCategoryItem('Food', Icons.restaurant, _navigateToFoodAccommodation),
                _buildCategoryItem('Market', Icons.shopping_cart, _navigateToMarketplace),
                _buildCategoryItem('Events', Icons.event, _navigateToEvents),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: AppColors.tribalPrimary),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedContent() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          // Add featured content here
        ],
      ),
    );
  }

  // Debug section
  List<Widget> _buildDebugSection() {
    return [
      Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.amber[100],
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DEBUG MODE',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: goToProfilePage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Go to Profile'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _showCurrentRoute,
                  child: const Text('Show Current Route'),
                ),
              ],
            ),
          ],
        ),
      ),
      const Divider(height: 1),
    ];
  }

  void _showCurrentRoute() {
    final route = ModalRoute.of(context)?.settings.name;
    debugPrint('Current route: $route');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Current route: ${route ?? 'unknown'}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tribal Tourism'),
        backgroundColor: AppColors.tribalPrimary,
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Debug section - will be removed in production
            if (kDebugMode) ..._buildDebugSection(),
            
            // Main content
            _buildSearchBar(),
            _buildCategories(),
            _buildFeaturedContent(),
          ],
        ),
      ),
    );
  }
}
