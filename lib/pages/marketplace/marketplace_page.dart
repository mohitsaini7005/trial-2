import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lali/core/constants/colors.dart';
import 'package:lali/models/product.dart';
import 'package:lali/widgets/premium_card.dart';
import 'package:lali/widgets/custom_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> 
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  String selectedCategory = 'All';
  String selectedSort = 'Popular';
  bool isGridView = true;

  final List<ProductCategory> categories = [
    ProductCategory(
      id: 'all',
      name: 'All',
      description: 'All Products',
      icon: 'assets/icons/all.png',
      image: 'assets/images/category_all.jpg',
    ),
    ProductCategory(
      id: 'handicrafts',
      name: 'Handicrafts',
      description: 'Traditional Handcrafted Items',
      icon: 'assets/icons/handicraft.png',
      image: 'assets/images/category_handicraft.jpg',
    ),
    ProductCategory(
      id: 'textiles',
      name: 'Textiles',
      description: 'Handwoven Fabrics & Clothing',
      icon: 'assets/icons/textile.png',
      image: 'assets/images/category_textile.jpg',
    ),
    ProductCategory(
      id: 'jewelry',
      name: 'Jewelry',
      description: 'Traditional Tribal Ornaments',
      icon: 'assets/icons/jewelry.png',
      image: 'assets/images/category_jewelry.jpg',
    ),
    ProductCategory(
      id: 'pottery',
      name: 'Pottery',
      description: 'Handmade Clay Items',
      icon: 'assets/icons/pottery.png',
      image: 'assets/images/category_pottery.jpg',
    ),
    ProductCategory(
      id: 'food',
      name: 'Food',
      description: 'Organic Tribal Delicacies',
      icon: 'assets/icons/food.png',
      image: 'assets/images/category_food.jpg',
    ),
  ];

  final List<Map<String, dynamic>> products = [
    {
      'id': '1',
      'name': 'Handwoven Pochampally Silk Saree',
      'price': 3500.0,
      'discountPrice': 2800.0,
      'rating': 4.8,
      'reviewCount': 142,
      'images': ['assets/images/saree1.jpg', 'assets/images/saree1_2.jpg'],
      'description': 'Exquisite handwoven Pochampally silk saree with traditional ikat patterns',
      'seller': 'Telangana Weavers Collective',
      'tribalOrigin': 'Pochampally, Telangana',
      'category': 'textiles',
      'isHandmade': true,
      'isCertified': true,
      'stockQuantity': 25,
      'tags': ['silk', 'handwoven', 'traditional', 'saree'],
    },
    {
      'id': '2',
      'name': 'Dhokra Art Elephant Figurine',
      'price': 1200.0,
      'discountPrice': 0.0,
      'rating': 4.6,
      'reviewCount': 89,
      'images': ['assets/images/dhokra1.jpg'],
      'description': 'Traditional lost-wax casting Dhokra art elephant with intricate details',
      'seller': 'Bengal Dhokra Artists',
      'tribalOrigin': 'West Bengal',
      'category': 'handicrafts',
      'isHandmade': true,
      'isCertified': true,
      'stockQuantity': 15,
      'tags': ['dhokra', 'bronze', 'elephant', 'figurine'],
    },
    {
      'id': '3',
      'name': 'Tribal Silver Oxidized Necklace',
      'price': 2800.0,
      'discountPrice': 2200.0,
      'rating': 4.9,
      'reviewCount': 203,
      'images': ['assets/images/necklace1.jpg', 'assets/images/necklace1_2.jpg'],
      'description': 'Authentic tribal silver necklace with oxidized finish and traditional motifs',
      'seller': 'Rajasthani Tribal Jewelers',
      'tribalOrigin': 'Rajasthan',
      'category': 'jewelry',
      'isHandmade': true,
      'isCertified': true,
      'stockQuantity': 8,
      'tags': ['silver', 'oxidized', 'necklace', 'tribal'],
    },
    {
      'id': '4',
      'name': 'Bamboo Utility Basket Set',
      'price': 850.0,
      'discountPrice': 680.0,
      'rating': 4.3,
      'reviewCount': 76,
      'images': ['assets/images/basket1.jpg'],
      'description': 'Set of 3 eco-friendly bamboo baskets in different sizes',
      'seller': 'Assam Bamboo Collective',
      'tribalOrigin': 'Assam',
      'category': 'handicrafts',
      'isHandmade': true,
      'isCertified': false,
      'stockQuantity': 32,
      'tags': ['bamboo', 'basket', 'eco-friendly', 'utility'],
    },
    {
      'id': '5',
      'name': 'Terracotta Warli Art Vase',
      'price': 950.0,
      'discountPrice': 0.0,
      'rating': 4.4,
      'reviewCount': 54,
      'images': ['assets/images/vase1.jpg'],
      'description': 'Hand-painted terracotta vase featuring traditional Warli art designs',
      'seller': 'Maharashtra Warli Artists',
      'tribalOrigin': 'Maharashtra',
      'category': 'pottery',
      'isHandmade': true,
      'isCertified': true,
      'stockQuantity': 18,
      'tags': ['terracotta', 'warli', 'vase', 'art'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildAppBar(),
          _buildSearchAndFilters(),
        ],
        body: Column(
          children: [
            _buildCategoriesSection(),
            Expanded(child: _buildProductsSection()),
          ],
        ),
      ),
      floatingActionButton: _buildCartFAB(),
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
                    'Tribal Marketplace',
                    style: GoogleFonts.orbitron(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Authentic handmade treasures from tribal artisans',
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
              delegate: _ProductSearchDelegate(products),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          onPressed: () {
            // Navigate to cart
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
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.tribalPrimary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildFilterButton(),
            const SizedBox(width: 8),
            _buildViewToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      width: 45,
      height: 45,
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
        icon: const Icon(Icons.tune, color: Colors.white, size: 22),
        onPressed: _showFilterBottomSheet,
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: IconButton(
        icon: Icon(
          isGridView ? Icons.view_list : Icons.grid_view,
          color: AppColors.tribalPrimary,
          size: 22,
        ),
        onPressed: () {
          setState(() {
            isGridView = !isGridView;
          });
        },
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category.name;
          
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildCategoryCard(category, isSelected),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(ProductCategory category, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category.name;
        });
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? AppColors.primaryGradient 
              : const LinearGradient(
                  colors: [Colors.white, Colors.white],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? Colors.transparent 
                : AppColors.lightGrey,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? AppColors.tribalPrimary.withOpacity(0.3) 
                  : Colors.grey.withOpacity(0.1),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected 
                    ? Colors.white.withOpacity(0.2) 
                    : AppColors.tribalPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getCategoryIcon(category.id),
                color: isSelected ? Colors.white : AppColors.tribalPrimary,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.tribalText,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsSection() {
    final filteredProducts = _getFilteredProducts();
    
    if (filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: AppColors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.grey.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return AnimationLimiter(
      child: isGridView
          ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: 2,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: _buildProductCard(filteredProducts[index]),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildProductListItem(filteredProducts[index]),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final double price = product['price']?.toDouble() ?? 0.0;
    final double discountPrice = product['discountPrice']?.toDouble() ?? 0.0;
    final bool hasDiscount = discountPrice > 0 && discountPrice < price;
    final double finalPrice = hasDiscount ? discountPrice : price;
    
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with Badges
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    color: AppColors.lightGrey.withOpacity(0.3),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      product['images'][0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.lightGrey.withOpacity(0.3),
                        child: const Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                // Discount Badge
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.sunsetOrange, AppColors.tribalAccent],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${((price - discountPrice) / price * 100).round()}% OFF',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                // Certified Badge
                if (product['isCertified'] == true)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.verified,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                // Wishlist Button
                Positioned(
                  bottom: 8,
                  right: 8,
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
          ),
          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.tribalText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['seller'],
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: AppColors.tribalAccent,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${product['rating']} (${product['reviewCount']})',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      if (hasDiscount) ...[
                        Text(
                          '₹${price.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        '₹${finalPrice.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.tribalPrimary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white, size: 16),
                          onPressed: () {
                            // Add to cart
                          },
                          padding: EdgeInsets.zero,
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
  }

  Widget _buildProductListItem(Map<String, dynamic> product) {
    final double price = product['price']?.toDouble() ?? 0.0;
    final double discountPrice = product['discountPrice']?.toDouble() ?? 0.0;
    final bool hasDiscount = discountPrice > 0 && discountPrice < price;
    final double finalPrice = hasDiscount ? discountPrice : price;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.lightGrey.withOpacity(0.3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  product['images'][0],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.lightGrey.withOpacity(0.3),
                    child: const Icon(
                      Icons.image_outlined,
                      size: 30,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product['name'],
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.tribalText,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (product['isCertified'] == true)
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.verified,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['seller'],
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: AppColors.tribalAccent,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${product['rating']} (${product['reviewCount']} reviews)',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (hasDiscount) ...[
                        Text(
                          '₹${price.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.sunsetOrange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${((price - discountPrice) / price * 100).round()}% OFF',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        '₹${finalPrice.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.tribalPrimary,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.lightGrey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.favorite_border, size: 16),
                              onPressed: () {
                                // Add to wishlist
                              },
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add, color: Colors.white, size: 16),
                              onPressed: () {
                                // Add to cart
                              },
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        // Navigate to cart
      },
      backgroundColor: AppColors.tribalAccent,
      icon: const Icon(Icons.shopping_cart, color: Colors.white),
      label: Text(
        'Cart (3)',
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter & Sort',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.tribalText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sort By',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.tribalText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: ['Popular', 'Price: Low to High', 'Price: High to Low', 'Rating', 'Newest']
                        .map((sort) => FilterChip(
                              label: Text(sort),
                              selected: selectedSort == sort,
                              onSelected: (selected) {
                                setState(() {
                                  selectedSort = sort;
                                });
                                Navigator.pop(context);
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredProducts() {
    var filtered = products.where((product) {
      if (selectedCategory == 'All') return true;
      return product['category'] == selectedCategory.toLowerCase();
    }).toList();

    // Sort products
    switch (selectedSort) {
      case 'Price: Low to High':
        filtered.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) => b['price'].compareTo(a['price']));
        break;
      case 'Rating':
        filtered.sort((a, b) => b['rating'].compareTo(a['rating']));
        break;
      case 'Newest':
        // Assuming products are already in newest first order
        break;
      default: // Popular
        filtered.sort((a, b) => b['reviewCount'].compareTo(a['reviewCount']));
    }

    return filtered;
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'all':
        return Icons.apps;
      case 'handicrafts':
        return Icons.handyman;
      case 'textiles':
        return Icons.content_cut;
      case 'jewelry':
        return Icons.diamond;
      case 'pottery':
        return Icons.cake;
      case 'food':
        return Icons.restaurant;
      default:
        return Icons.category;
    }
  }
}

class _ProductSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> products;

  _ProductSearchDelegate(this.products);

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
              'Search for products',
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
    final results = products.where((product) {
      return product['name'].toLowerCase().contains(query.toLowerCase()) ||
          product['description'].toLowerCase().contains(query.toLowerCase()) ||
          product['seller'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: AppColors.grey),
            const SizedBox(height: 16),
            Text(
              'No products found',
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
        final product = results[index];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.lightGrey.withOpacity(0.3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                product['images'][0],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_outlined,
                  color: AppColors.grey,
                ),
              ),
            ),
          ),
          title: Text(
            product['name'],
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            product['seller'],
            style: GoogleFonts.inter(color: AppColors.grey),
          ),
          trailing: Text(
            '₹${product['price'].toStringAsFixed(0)}',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: AppColors.tribalPrimary,
            ),
          ),
          onTap: () {
            // Navigate to product details
            close(context, product);
          },
        );
      },
    );
  }
}
          product['description'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildSearchResults(suggestions);
  }

  Widget _buildSearchResults(List<Map<String, dynamic>> results) {
    if (results.isEmpty) {
      return const Center(
        child: Text('No matching products found'),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.asset(
                  product['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 40),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      product['price'],
                      style: const TextStyle(
                        color: AppColors.tribalPrimary,
                        fontWeight: FontWeight.bold,
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
}

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {
        'name': 'Handwoven Shawl',
        'price': '₹1,200',
        'rating': 4.5,
        'image': 'assets/images/product1.jpg',
        'description': 'Handwoven by tribal artisans using traditional methods',
        'seller': 'Adivasi Weavers',
      },
      {
        'name': 'Bamboo Basket',
        'price': '₹850',
        'rating': 4.2,
        'image': 'assets/images/product2.jpg',
        'description': 'Eco-friendly bamboo basket for home decor',
        'seller': 'Tribal Crafts',
      },
      {
        'name': 'Tribal Jewelry Set',
        'price': '₹2,500',
        'rating': 4.8,
        'image': 'assets/images/product3.jpg',
        'description': 'Authentic tribal necklace and earring set',
        'seller': 'Ethnic Adornments',
      },
      {
        'name': 'Wooden Carving',
        'price': '₹3,500',
        'rating': 4.6,
        'image': 'assets/images/product4.jpg',
        'description': 'Hand-carved wooden tribal art piece',
        'seller': 'Forest Creations',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tribal Marketplace'),
        backgroundColor: AppColors.tribalPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _ProductSearchDelegate(products),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filter Products',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Categories'),
                      Wrap(
                        spacing: 8,
                        children: [
                          FilterChip(
                            label: const Text('Handicrafts'),
                            selected: false,
                            onSelected: (_) {},
                          ),
                          FilterChip(
                            label: const Text('Textiles'),
                            selected: false,
                            onSelected: (_) {},
                          ),
                          FilterChip(
                            label: const Text('Jewelry'),
                            selected: false,
                            onSelected: (_) {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Price Range'),
                      RangeSlider(
                        values: const RangeValues(0, 10000),
                        min: 0,
                        max: 10000,
                        divisions: 10,
                        labels: const RangeLabels('₹0', '₹10,000'),
                        onChanged: (values) {},
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tribalPrimary,
                          ),
                          child: const Text('Apply Filters'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(
                      product['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 40),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product['description'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.store, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            product['seller'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product['price'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.tribalPrimary,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, 
                                color: Colors.amber, 
                                size: 16,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                product['rating'].toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added ${product['name']} to cart'),
                                action: SnackBarAction(
                                  label: 'View Cart',
                                  onPressed: () {
                                    // Navigate to cart
                                  },
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tribalPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
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
}
