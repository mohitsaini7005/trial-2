import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lali/core/constants/colors.dart';
import 'package:lali/models/trip.dart';
import 'package:lali/widgets/premium_card.dart';
import 'package:lali/widgets/custom_search_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TripsBookingPage extends StatefulWidget {
  const TripsBookingPage({super.key});

  @override
  State<TripsBookingPage> createState() => _TripsBookingPageState();
}

class _TripsBookingPageState extends State<TripsBookingPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _filterController;
  
  String selectedState = 'All';
  TripType? selectedType;
  DifficultyLevel? selectedDifficulty;
  RangeValues priceRange = const RangeValues(1000, 10000);
  String sortBy = 'Popular';

  final List<String> states = [
    'All', 'Andhra Pradesh', 'Assam', 'Chhattisgarh', 'Gujarat', 'Jharkhand',
    'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Odisha', 
    'Rajasthan', 'Tamil Nadu', 'Telangana', 'West Bengal'
  ];

  final List<Map<String, dynamic>> mockTrips = [
    {
      'id': '1',
      'title': 'Araku Valley Tribal Experience',
      'shortDescription': 'Immerse in the coffee culture and tribal traditions of Araku Valley',
      'images': ['assets/images/araku_trip1.jpg', 'assets/images/araku_trip2.jpg'],
      'destination': 'Araku Valley',
      'state': 'Andhra Pradesh',
      'tribalRegion': 'Visakhapatnam Agency',
      'basePrice': 4500.0,
      'discountPrice': 3600.0,
      'duration': 3,
      'type': 'cultural',
      'difficulty': 'easy',
      'rating': 4.8,
      'reviewCount': 124,
      'guideName': 'Ravi Tribal Guide',
      'guideAvatar': 'assets/images/guide1.jpg',
      'isGuideVerified': true,
      'maxGroupSize': 8,
      'availableSlots': 5,
      'highlights': [
        'Visit tribal villages',
        'Coffee plantation tour',
        'Traditional dance performance',
        'Local handicraft shopping'
      ],
      'isFeatured': true,
      'tags': ['cultural', 'coffee', 'traditional'],
    },
    {
      'id': '2',
      'title': 'Bastar Tribal Adventure',
      'shortDescription': 'Explore the heart of tribal India in Chhattisgarh\'s Bastar region',
      'images': ['assets/images/bastar_trip1.jpg', 'assets/images/bastar_trip2.jpg'],
      'destination': 'Bastar',
      'state': 'Chhattisgarh',
      'tribalRegion': 'Bastar Division',
      'basePrice': 6800.0,
      'discountPrice': 0.0,
      'duration': 5,
      'type': 'adventure',
      'difficulty': 'moderate',
      'rating': 4.6,
      'reviewCount': 89,
      'guideName': 'Mohan Gond',
      'guideAvatar': 'assets/images/guide2.jpg',
      'isGuideVerified': true,
      'maxGroupSize': 12,
      'availableSlots': 8,
      'highlights': [
        'Chitrakote waterfall trek',
        'Tribal market experience',
        'Traditional food tasting',
        'Folk art workshops'
      ],
      'isFeatured': false,
      'tags': ['adventure', 'trekking', 'nature'],
    },
    {
      'id': '3',
      'title': 'Rajasthan Desert Tribal Life',
      'shortDescription': 'Experience the nomadic culture of Rajasthan\'s desert tribes',
      'images': ['assets/images/rajasthan_trip1.jpg', 'assets/images/rajasthan_trip2.jpg'],
      'destination': 'Jaisalmer',
      'state': 'Rajasthan',
      'tribalRegion': 'Thar Desert',
      'basePrice': 8500.0,
      'discountPrice': 7200.0,
      'duration': 4,
      'type': 'cultural',
      'difficulty': 'easy',
      'rating': 4.9,
      'reviewCount': 156,
      'guideName': 'Lalaram Bhil',
      'guideAvatar': 'assets/images/guide3.jpg',
      'isGuideVerified': true,
      'maxGroupSize': 10,
      'availableSlots': 3,
      'highlights': [
        'Camel safari experience',
        'Desert camping',
        'Folk music and dance',
        'Traditional textile making'
      ],
      'isFeatured': true,
      'tags': ['desert', 'camel', 'music'],
    },
    {
      'id': '4',
      'title': 'Kerala Spice Trail with Tribes',
      'shortDescription': 'Discover spice cultivation and tribal wisdom in Western Ghats',
      'images': ['assets/images/kerala_trip1.jpg', 'assets/images/kerala_trip2.jpg'],
      'destination': 'Wayanad',
      'state': 'Kerala',
      'tribalRegion': 'Western Ghats',
      'basePrice': 5200.0,
      'discountPrice': 4680.0,
      'duration': 3,
      'type': 'educational',
      'difficulty': 'easy',
      'rating': 4.7,
      'reviewCount': 98,
      'guideName': 'Suma Paniya',
      'guideAvatar': 'assets/images/guide4.jpg',
      'isGuideVerified': true,
      'maxGroupSize': 15,
      'availableSlots': 12,
      'highlights': [
        'Spice plantation tours',
        'Tribal medicinal knowledge',
        'Bamboo craft workshop',
        'Organic farming experience'
      ],
      'isFeatured': false,
      'tags': ['spices', 'medicinal', 'crafts'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filterController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildAppBar(),
          _buildSearchAndFilters(),
          _buildTabBar(),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildFeaturedTrips(),
            _buildAllTrips(),
            _buildMyBookings(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showFilterBottomSheet,
        backgroundColor: AppColors.tribalAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.filter_list),
        label: Text(
          'Filter',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
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
                  Text(
                    'Tribal Adventures',
                    style: GoogleFonts.orbitron(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Discover authentic tribal experiences across India',
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
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            showSearch(
              context: context,
              delegate: _TripSearchDelegate(mockTrips),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.white),
          onPressed: () {
            // Navigate to wishlist
          },
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: CustomSearchBar(
                hintText: 'Search destinations, experiences...',
                showFilter: false,
                onChanged: (value) {
                  // Handle search
                },
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.tribalPrimary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.map, color: Colors.white, size: 22),
                onPressed: () {
                  // Show map view
                },
              ),
            ),
          ],
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
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Featured'),
            Tab(text: 'All Trips'),
            Tab(text: 'My Bookings'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedTrips() {
    final featuredTrips = mockTrips.where((trip) => trip['isFeatured'] == true).toList();
    
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: featuredTrips.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildTripCard(featuredTrips[index], isFeatured: true),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAllTrips() {
    final filteredTrips = _getFilteredTrips();
    
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredTrips.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildTripCard(filteredTrips[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMyBookings() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.luggage,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Bookings Yet',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.tribalText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start exploring and book your first\ntribal adventure!',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.grey,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          GradientButton(
            text: 'Explore Trips',
            onPressed: () {
              _tabController.animateTo(0);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip, {bool isFeatured = false}) {
    final double basePrice = trip['basePrice'].toDouble();
    final double discountPrice = trip['discountPrice'].toDouble();
    final bool hasDiscount = discountPrice > 0 && discountPrice < basePrice;
    final double finalPrice = hasDiscount ? discountPrice : basePrice;
    
    return PremiumCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.zero,
      hasGradient: isFeatured,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip Image with Badges
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  color: AppColors.lightGrey.withOpacity(0.3),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    trip['images'][0],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.lightGrey.withOpacity(0.3),
                      child: const Icon(
                        Icons.landscape,
                        size: 64,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Featured Badge
              if (isFeatured)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.tribalAccent, AppColors.premiumGold],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'FEATURED',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Discount Badge
              if (hasDiscount)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.sunsetOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${((basePrice - discountPrice) / basePrice * 100).round()}% OFF',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              
              // Duration Badge
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${trip['duration']} Days',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              // Wishlist Button
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border, size: 18),
                    onPressed: () {
                      // Add to wishlist
                    },
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
          
          // Trip Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Location
                Text(
                  trip['title'],
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.tribalText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppColors.tribalSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${trip['destination']}, ${trip['state']}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.tribalSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Description
                Text(
                  trip['shortDescription'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.grey,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                
                // Guide Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.lightGrey,
                      backgroundImage: AssetImage(trip['guideAvatar']),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        trip['guideName'],
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.tribalText,
                        ),
                      ),
                    ),
                    if (trip['isGuideVerified'] == true)
                      const Icon(
                        Icons.verified,
                        size: 16,
                        color: AppColors.tribalSecondary,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Rating and Highlights
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.tribalAccent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${trip['rating']} (${trip['reviewCount']})',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.tribalText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(trip['difficulty']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getDifficultyColor(trip['difficulty']).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        trip['difficulty'].toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getDifficultyColor(trip['difficulty']),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Highlights
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (trip['highlights'] as List<dynamic>)
                      .take(3)
                      .map((highlight) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.tribalSecondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              highlight,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.tribalSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                
                // Price and Book Button
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasDiscount) ...[
                          Text(
                            '₹${basePrice.toStringAsFixed(0)}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '₹${finalPrice.toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.tribalPrimary,
                              ),
                            ),
                            Text(
                              ' /person',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    GradientButton(
                      text: 'Book Now',
                      width: 120,
                      height: 44,
                      onPressed: () => _navigateToBookingDetails(trip),
                    ),
                  ],
                ),
                
                // Availability
                const SizedBox(height: 8),
                Text(
                  '${trip['availableSlots']} spots left',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: trip['availableSlots'] <= 3 
                        ? AppColors.sunsetOrange 
                        : AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filter Trips',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.tribalText,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // State Filter
                        _buildFilterSection(
                          'State',
                          DropdownButton<String>(
                            value: selectedState,
                            isExpanded: true,
                            items: states.map((state) => DropdownMenuItem(
                              value: state,
                              child: Text(state),
                            )).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedState = value!;
                              });
                            },
                          ),
                        ),
                        
                        // Trip Type Filter
                        _buildFilterSection(
                          'Trip Type',
                          Wrap(
                            spacing: 8,
                            children: TripType.values.map((type) {
                              final isSelected = selectedType == type;
                              return FilterChip(
                                label: Text(type.name.toUpperCase()),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    selectedType = selected ? type : null;
                                  });
                                },
                                selectedColor: AppColors.tribalSecondary,
                                checkmarkColor: Colors.white,
                              );
                            }).toList(),
                          ),
                        ),
                        
                        // Difficulty Filter
                        _buildFilterSection(
                          'Difficulty',
                          Wrap(
                            spacing: 8,
                            children: DifficultyLevel.values.map((difficulty) {
                              final isSelected = selectedDifficulty == difficulty;
                              return FilterChip(
                                label: Text(difficulty.name.toUpperCase()),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    selectedDifficulty = selected ? difficulty : null;
                                  });
                                },
                                selectedColor: _getDifficultyColor(difficulty.name),
                                checkmarkColor: Colors.white,
                              );
                            }).toList(),
                          ),
                        ),
                        
                        // Price Range
                        _buildFilterSection(
                          'Price Range (₹${priceRange.start.round()} - ₹${priceRange.end.round()})',
                          RangeSlider(
                            values: priceRange,
                            min: 1000,
                            max: 15000,
                            divisions: 28,
                            activeColor: AppColors.tribalPrimary,
                            onChanged: (values) {
                              setState(() {
                                priceRange = values;
                              });
                            },
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedState = 'All';
                                    selectedType = null;
                                    selectedDifficulty = null;
                                    priceRange = const RangeValues(1000, 10000);
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('Clear All'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GradientButton(
                                text: 'Apply Filters',
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(String title, Widget child) {
    return Column(
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
        child,
        const SizedBox(height: 24),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'moderate':
        return AppColors.tribalAccent;
      case 'challenging':
        return AppColors.warning;
      case 'expert':
        return AppColors.danger;
      default:
        return AppColors.grey;
    }
  }

  List<Map<String, dynamic>> _getFilteredTrips() {
    return mockTrips.where((trip) {
      final matchesState = selectedState == 'All' || trip['state'] == selectedState;
      final matchesType = selectedType == null || trip['type'] == selectedType!.name;
      final matchesDifficulty = selectedDifficulty == null || trip['difficulty'] == selectedDifficulty!.name;
      
      final price = trip['discountPrice'] > 0 ? trip['discountPrice'] : trip['basePrice'];
      final matchesPrice = price >= priceRange.start && price <= priceRange.end;
      
      return matchesState && matchesType && matchesDifficulty && matchesPrice;
    }).toList();
  }

  void _navigateToBookingDetails(Map<String, dynamic> trip) {
    // Navigate to trip details page
    print('Navigate to booking details for: ${trip['title']}');
  }
}

class _TripSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> trips;

  _TripSearchDelegate(this.trips);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 64, color: AppColors.grey),
            const SizedBox(height: 16),
            Text(
              'Search for destinations or experiences',
              style: GoogleFonts.inter(
                fontSize: 18,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = trips.where((trip) {
      return trip['title'].toLowerCase().contains(query.toLowerCase()) ||
          trip['destination'].toLowerCase().contains(query.toLowerCase()) ||
          trip['state'].toLowerCase().contains(query.toLowerCase()) ||
          trip['shortDescription'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: AppColors.grey),
            const SizedBox(height: 16),
            Text(
              'No trips found',
              style: GoogleFonts.inter(
                fontSize: 18,
                color: AppColors.grey,
              ),
            ),
            Text(
              'Try different keywords',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final trip = results[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.lightGrey.withOpacity(0.3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                trip['images'][0],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.landscape,
                  color: AppColors.grey,
                ),
              ),
            ),
          ),
          title: Text(
            trip['title'],
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            '${trip['destination']}, ${trip['state']}',
            style: GoogleFonts.inter(color: AppColors.grey),
          ),
          trailing: Text(
            '₹${trip['discountPrice'] > 0 ? trip['discountPrice'].toStringAsFixed(0) : trip['basePrice'].toStringAsFixed(0)}',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: AppColors.tribalPrimary,
            ),
          ),
          onTap: () {
            // Navigate to trip details
            close(context, trip);
          },
        );
      },
    );
  }
}