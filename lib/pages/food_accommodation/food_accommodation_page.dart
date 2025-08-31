import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lali/core/constants/colors.dart';

class FoodAccommodationPage extends StatelessWidget {
  const FoodAccommodationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> foodOptions = [
      {
        'title': 'Traditional Tribal Thali',
        'description': 'Authentic tribal cuisine with local ingredients',
        'price': '₹250',
        'rating': 4.7,
        'image': 'assets/images/food1.jpg',
      },
      {
        'title': 'Bamboo Chicken',
        'description': 'Chicken cooked in bamboo with tribal spices',
        'price': '₹350',
        'rating': 4.5,
        'image': 'assets/images/food2.jpg',
      },
      {
        'title': 'Millet Dosa',
        'description': 'Healthy millet dosa with chutney',
        'price': '₹150',
        'rating': 4.3,
        'image': 'assets/images/food3.jpg',
      },
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Food & Accommodation'),
          backgroundColor: AppColors.tribalPrimary,
          bottom: const TabBar(
            indicatorColor: AppColors.white,
            labelColor: AppColors.white,
            unselectedLabelColor: AppColors.lightGrey,
            tabs: [
              Tab(text: 'Food'),
              Tab(text: 'Stays'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Food Tab
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: foodOptions.length,
              itemBuilder: (context, index) {
                final food = foodOptions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.asset(
                          food['image'],
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 150,
                                color: Colors.grey[200],
                                child: const Icon(Icons.fastfood, size: 50),
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    food['title'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.star,
                                          size: 16, color: Colors.white),
                                      const SizedBox(width: 4),
                                      Text(
                                        food['rating'].toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              food['description'],
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  food['price'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.tribalPrimary,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.snackbar(
                                      'Order',
                                      'Order feature coming soon!',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.tribalPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Order Now'),
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
            
            // Stays Tab (Placeholder for now)
            const Center(
              child: Text('Tribal stays will be listed here'),
            ),
          ],
        ),
      ),
    );
  }
}
