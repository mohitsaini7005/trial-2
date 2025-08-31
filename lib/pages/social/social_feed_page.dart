import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lali/core/constants/colors.dart';
import 'package:lali/models/social.dart';
import 'package:lali/widgets/premium_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SocialFeedPage extends StatefulWidget {
  const SocialFeedPage({super.key});

  @override
  State<SocialFeedPage> createState() => _SocialFeedPageState();
}

class _SocialFeedPageState extends State<SocialFeedPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _showFAB = true;

  final List<Map<String, dynamic>> mockPosts = [
    {
      'id': '1',
      'userId': 'user1',
      'userName': 'Arjun Tribal Guide',
      'userAvatar': 'assets/images/avatar1.jpg',
      'title': 'Amazing Sunset at Araku Valley',
      'description': 'Just witnessed the most breathtaking sunset during our tribal village tour! The way the golden light reflected off the traditional huts was magical. ✨ #ArakuValley #TribalTourism #Sunset',
      'mediaUrls': ['assets/images/araku_sunset.jpg'],
      'type': 'photo',
      'locationName': 'Araku Valley, Andhra Pradesh',
      'tags': ['araku', 'sunset', 'tribal', 'village'],
      'likesCount': 234,
      'commentsCount': 18,
      'sharesCount': 12,
      'viewsCount': 1240,
      'isPublic': true,
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
      'likedBy': [],
      'isVideo': false,
    },
    {
      'id': '2',
      'userId': 'user2',
      'userName': 'Maya Handicrafts',
      'userAvatar': 'assets/images/avatar2.jpg',
      'title': 'Traditional Dhokra Art Process',
      'description': 'Watch how our skilled artisan creates beautiful Dhokra figurines using the ancient lost-wax casting technique! This elephant took 3 days to complete. 🐘✨',
      'mediaUrls': ['assets/videos/dhokra_process.mp4'],
      'type': 'reel',
      'locationName': 'West Bengal',
      'tags': ['dhokra', 'art', 'handicraft', 'traditional'],
      'likesCount': 567,
      'commentsCount': 45,
      'sharesCount': 89,
      'viewsCount': 3420,
      'isPublic': true,
      'createdAt': DateTime.now().subtract(const Duration(hours: 8)),
      'likedBy': [],
      'isVideo': true,
    },
    {
      'id': '3',
      'userId': 'user3',
      'userName': 'Tribal Food Explorer',
      'userAvatar': 'assets/images/avatar3.jpg',
      'title': 'Authentic Bastar Cuisine',
      'description': 'Tried the most amazing tribal delicacies in Bastar! The bamboo shoot curry and mahua wine were absolutely divine. Can\'t wait to share the recipes! 🍲🌿',
      'mediaUrls': ['assets/images/bastar_food1.jpg', 'assets/images/bastar_food2.jpg'],
      'type': 'photo',
      'locationName': 'Bastar, Chhattisgarh',
      'tags': ['bastar', 'food', 'cuisine', 'tribal'],
      'likesCount': 156,
      'commentsCount': 28,
      'sharesCount': 15,
      'viewsCount': 890,
      'isPublic': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'likedBy': [],
      'isVideo': false,
    },
    {
      'id': '4',
      'userId': 'user4',
      'userName': 'Cultural Explorer',
      'userAvatar': 'assets/images/avatar4.jpg',
      'title': 'Tribal Dance Performance',
      'description': 'Mesmerizing Gond tribal dance performance at the cultural festival! The rhythm, costumes, and energy were absolutely incredible! 💃🎵',
      'mediaUrls': ['assets/videos/tribal_dance.mp4'],
      'type': 'reel',
      'locationName': 'Madhya Pradesh',
      'tags': ['dance', 'cultural', 'festival', 'gond'],
      'likesCount': 892,
      'commentsCount': 76,
      'sharesCount': 134,
      'viewsCount': 5670,
      'isPublic': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 2)),
      'likedBy': [],
      'isVideo': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    
    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && _showFAB) {
        setState(() {
          _showFAB = false;
        });
      } else if (_scrollController.offset <= 100 && !_showFAB) {
        setState(() {
          _showFAB = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildAppBar(innerBoxIsScrolled),
          _buildTabBar(),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildFeedTab(),
            _buildReelsTab(),
            _buildExploreTab(),
            _buildMyPostsTab(),
          ],
        ),
      ),
      floatingActionButton: AnimatedScale(
        scale: _showFAB ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton.extended(
          onPressed: _showCreatePostDialog,
          backgroundColor: AppColors.tribalAccent,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: Text(
            'Create',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.tribalPrimary,
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
                        'Tribal Stories',
                        style: GoogleFonts.orbitron(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.messenger_outline, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Text(
                    'Share your tribal adventures & discoveries',
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
    );
  }

  Widget _buildTabBar() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.tribalPrimary,
          indicatorWeight: 3,
          labelColor: AppColors.tribalPrimary,
          unselectedLabelColor: AppColors.grey,
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: 'Feed'),
            Tab(text: 'Reels'),
            Tab(text: 'Explore'),
            Tab(text: 'My Posts'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedTab() {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: mockPosts.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildPostCard(mockPosts[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReelsTab() {
    final reelPosts = mockPosts.where((post) => post['isVideo'] == true).toList();
    
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 9 / 16,
      ),
      itemCount: reelPosts.length,
      itemBuilder: (context, index) {
        return _buildReelThumbnail(reelPosts[index]);
      },
    );
  }

  Widget _buildExploreTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: mockPosts.length * 3, // Simulate more content
      itemBuilder: (context, index) {
        final post = mockPosts[index % mockPosts.length];
        return _buildExploreThumbnail(post);
      },
    );
  }

  Widget _buildMyPostsTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 2, // User's posts
      itemBuilder: (context, index) {
        return _buildPostCard(mockPosts[index]);
      },
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return PremiumCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.lightGrey,
                  backgroundImage: AssetImage(post['userAvatar']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post['userName'],
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.tribalText,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            size: 16,
                            color: AppColors.tribalSecondary,
                          ),
                        ],
                      ),
                      if (post['locationName'] != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppColors.grey,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              post['locationName'],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: AppColors.grey),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'save',
                      child: Text('Save Post'),
                    ),
                    const PopupMenuItem(
                      value: 'report',
                      child: Text('Report'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Post Content
          if (post['title'] != null && post['title'].isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                post['title'],
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.tribalText,
                ),
              ),
            ),
          
          if (post['description'] != null && post['description'].isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Text(
                post['description'],
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.tribalText,
                  height: 1.4,
                ),
              ),
            ),
          
          // Post Media
          if (post['mediaUrls'] != null && post['mediaUrls'].isNotEmpty)
            _buildPostMedia(post),
          
          // Post Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildActionButton(
                      icon: Icons.favorite_border,
                      activeIcon: Icons.favorite,
                      count: post['likesCount'],
                      isActive: false, // Check if user liked
                      onTap: () => _toggleLike(post['id']),
                    ),
                    const SizedBox(width: 24),
                    _buildActionButton(
                      icon: Icons.comment_outlined,
                      count: post['commentsCount'],
                      onTap: () => _showComments(post),
                    ),
                    const SizedBox(width: 24),
                    _buildActionButton(
                      icon: Icons.share_outlined,
                      count: post['sharesCount'],
                      onTap: () => _sharePost(post),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border),
                      onPressed: () => _savePost(post['id']),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${post['viewsCount']} views',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getTimeAgo(post['createdAt']),
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
        ],
      ),
    );
  }

  Widget _buildPostMedia(Map<String, dynamic> post) {
    final List<String> mediaUrls = post['mediaUrls'];
    
    if (mediaUrls.length == 1) {
      return _buildSingleMedia(mediaUrls.first, post['isVideo'] ?? false);
    } else {
      return _buildMultipleMedia(mediaUrls);
    }
  }

  Widget _buildSingleMedia(String mediaUrl, bool isVideo) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.lightGrey.withOpacity(0.3),
        ),
        child: Stack(
          children: [
            Image.asset(
              mediaUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.lightGrey.withOpacity(0.3),
                child: const Icon(
                  Icons.image_outlined,
                  size: 48,
                  color: AppColors.grey,
                ),
              ),
            ),
            if (isVideo)
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleMedia(List<String> mediaUrls) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: mediaUrls.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: _buildSingleMedia(mediaUrls[index], false),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    IconData? activeIcon,
    required int count,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            isActive && activeIcon != null ? activeIcon : icon,
            size: 22,
            color: isActive ? AppColors.sunsetOrange : AppColors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReelThumbnail(Map<String, dynamic> post) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              post['mediaUrls'].first,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.lightGrey.withOpacity(0.3),
                child: const Icon(
                  Icons.play_circle_outline,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['title'],
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.play_arrow,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${post['viewsCount']}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreThumbnail(Map<String, dynamic> post) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withOpacity(0.3),
      ),
      child: Image.asset(
        post['mediaUrls'].first,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.lightGrey.withOpacity(0.3),
          child: Icon(
            post['isVideo'] == true ? Icons.play_circle_outline : Icons.image_outlined,
            size: 24,
            color: AppColors.grey,
          ),
        ),
      ),
    );
  }

  void _showCreatePostDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Create New Post',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.tribalText,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildCreateOption(
                            icon: Icons.photo_library,
                            label: 'Photo',
                            onTap: () {},
                          ),
                          const SizedBox(width: 16),
                          _buildCreateOption(
                            icon: Icons.videocam,
                            label: 'Video',
                            onTap: () {},
                          ),
                          const SizedBox(width: 16),
                          _buildCreateOption(
                            icon: Icons.article,
                            label: 'Story',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCreateOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleLike(String postId) {
    // Implement like functionality
  }

  void _showComments(Map<String, dynamic> post) {
    // Navigate to comments page
  }

  void _sharePost(Map<String, dynamic> post) {
    // Implement share functionality
  }

  void _savePost(String postId) {
    // Implement save functionality
  }

  String _getTimeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}