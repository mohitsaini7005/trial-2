import 'package:flutter/material.dart';
import 'package:lali/core/constants/colors.dart';

class _ProductSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> products;

  _ProductSearchDelegate(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products.where((product) {
      return product['name'].toLowerCase().contains(query.toLowerCase()) ||
          product['description'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildSearchResults(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Search for products by name or description'),
      );
    }

    final List<Map<String, dynamic>> suggestions = products.where((product) {
      return product['name'].toLowerCase().contains(query.toLowerCase()) ||
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
