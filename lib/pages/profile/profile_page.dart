import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lali/core/constants/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      debugPrint('🔄 ProfilePage initialized');
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kDebugMode) {
        debugPrint('🎯 ProfilePage first frame rendered');
      }
    });
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.tribalPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.tribalPrimary.withAlpha(25),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.tribalPrimary),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint('🏗️ Building ProfilePage widget');
    }
    
    // Add a debug banner in debug mode
    Widget child = _buildProfileContent();
    
    if (kDebugMode) {
      return Stack(
        children: [
          child,
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              color: Colors.green,
              child: const Text(
                'PROFILE PAGE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }
    
    return child;
  }

  Widget _buildProfileContent() {
    if (kDebugMode) {
      debugPrint('🏗️ Building profile content');
      // Log the current route
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final route = ModalRoute.of(context);
        if (route != null) {
          debugPrint('🔍 Current route: ${route.settings.name}');
        }
      });
    }
    
    return Scaffold(
      backgroundColor: Colors.blue[50], // Light blue background for visibility
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: kDebugMode ? [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              // Show debug info in a dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Debug Info'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Route: ${ModalRoute.of(context)?.settings.name ?? 'N/A'}')
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ] : null,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('My Profile'),
              background: Image.asset(
                'assets/images/profile_bg.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.tribalPrimary,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Header
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 120,
                        decoration: const BoxDecoration(
                          color: AppColors.tribalPrimary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -40,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(25), // ~10% opacity
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: AppColors.tribalPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 60,
                      bottom: 20,
                      left: 16,
                      right: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(51), // ~20% opacity
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'john.doe@example.com',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn('12', 'Trips'),
                            _buildStatColumn('24', 'Reviews'),
                            _buildStatColumn('4.8', 'Rating'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Menu Items
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: const Text('Edit Profile'),
                              backgroundColor: AppColors.tribalPrimary,
                            ),
                            body: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const CircleAvatar(
                                    radius: 50,
                                    backgroundImage: AssetImage(
                                        'assets/images/profile_placeholder.jpg'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Show image source selection
                                      final ImagePicker picker = ImagePicker();
                                      final source = await showModalBottomSheet<ImageSource>(
                                        context: context,
                                        builder: (context) => SafeArea(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: const Icon(Icons.photo_library),
                                                title: const Text('Choose from gallery'),
                                                onTap: () => Navigator.pop(context, ImageSource.gallery),
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons.camera_alt),
                                                title: const Text('Take a photo'),
                                                onTap: () => Navigator.pop(context, ImageSource.camera),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );

                                      if (source != null) {
                                        try {
                                          final XFile? image = await picker.pickImage(
                                            source: source,
                                            imageQuality: 80,
                                          );
                                          
                                          if (image != null && context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Profile picture updated'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Failed to pick image'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    },
                                    child: const Text('Change Photo'),
                                  ),
                                  const SizedBox(height: 16),
                                  const TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Full Name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 16),
                                  const TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Phone',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.phone,
                                  ),
                                  const SizedBox(height: 16),
                                  const TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Address',
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: 3,
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Profile updated successfully!'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.tribalPrimary,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                      ),
                                      child: const Text('Save Changes'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.history,
                    title: 'Booking History',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: const Text('Booking History'),
                              backgroundColor: AppColors.tribalPrimary,
                            ),
                            body: ListView.builder(
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.calendar_today),
                                  title: Text('Booking #${index + 1}'),
                                  subtitle: const Text('Status: Confirmed'),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () {
                                    // Navigate to booking details
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.favorite_border,
                    title: 'Wishlist',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: const Text('My Wishlist'),
                              backgroundColor: AppColors.tribalPrimary,
                            ),
                            body: ListView.builder(
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Image.asset(
                                    'assets/images/product${index + 1}.jpg',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => 
                                      const Icon(Icons.image, size: 50),
                                  ),
                                  title: Text('Product ${index + 1}'),
                                  subtitle: const Text('₹1,200'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.favorite, color: Colors.red),
                                    onPressed: () {
                                      // Remove from wishlist
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: const Text('Settings'),
                              backgroundColor: AppColors.tribalPrimary,
                            ),
                            body: ListView(
                              children: [
                                SwitchListTile(
                                  title: const Text('Notifications'),
                                  value: true,
                                  onChanged: (value) {},
                                ),
                                const ListTile(
                                  leading: Icon(Icons.language),
                                  title: Text('Language'),
                                  subtitle: Text('English'),
                                  trailing: Icon(Icons.chevron_right),
                                ),
                                const ListTile(
                                  leading: Icon(Icons.help_outline),
                                  title: Text('Help & Support'),
                                  trailing: Icon(Icons.chevron_right),
                                ),
                                const ListTile(
                                  leading: Icon(Icons.privacy_tip_outlined),
                                  title: Text('Privacy Policy'),
                                  trailing: Icon(Icons.chevron_right),
                                ),
                                const ListTile(
                                  leading: Icon(Icons.description_outlined),
                                  title: Text('Terms of Service'),
                                  trailing: Icon(Icons.chevron_right),
                                ),
                                const SizedBox(height: 16),
                                ListTile(
                                  leading: const Icon(Icons.logout, color: Colors.red),
                                  title: const Text(
                                    'Sign Out',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onTap: () {
                                    // Sign out logic
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/login',
                                      (route) => false,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Help & Support',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ListTile(
                                leading: const Icon(Icons.email_outlined),
                                title: const Text('Email Us'),
                                subtitle: const Text('support@lali.com'),
                                onTap: () {
                                  // Launch email
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.phone_outlined),
                                title: const Text('Call Us'),
                                subtitle: const Text('+91 1234567890'),
                                onTap: () {
                                  // Launch phone
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.chat_bubble_outline),
                                title: const Text('Live Chat'),
                                subtitle: const Text('Available 24/7'),
                                onTap: () {
                                  // Start chat
                                },
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'FAQs',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...List.generate(
                                3,
                                (index) => ExpansionTile(
                                  title: Text('Question ${index + 1}?'),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        'Answer to question ${index + 1} goes here.',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          // Clear user session data
                          // await AuthService().signOut();
                          
                          // Navigate to login screen and remove all previous routes
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error signing out. Please try again.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text('Sign Out'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
