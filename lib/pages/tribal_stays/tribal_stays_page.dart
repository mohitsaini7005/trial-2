import 'package:flutter/material.dart';
import 'package:lali/core/constants/colors.dart';

class StaySearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> stays;

  StaySearchDelegate(this.stays);

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
    final results = stays.where((stay) {
      return stay['title'].toLowerCase().contains(query.toLowerCase()) ||
          stay['location'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildSearchResults(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Search for stays by name or location'),
      );
    }

    final List<Map<String, dynamic>> suggestions = stays.where((stay) {
      return stay['title'].toLowerCase().contains(query.toLowerCase()) ||
          stay['location'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildSearchResults(suggestions);
  }

  Widget _buildSearchResults(List<Map<String, dynamic>> results) {
    if (results.isEmpty) {
      return const Center(
        child: Text('No matching stays found'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final stay = results[index];
        return ListTile(
          leading: const Icon(Icons.house, color: AppColors.tribalPrimary),
          title: Text(stay['title']),
          subtitle: Text(stay['location']),
          trailing: Text(stay['price']),
          onTap: () {
            // Navigate to stay details
          },
        );
      },
    );
  }
}

class TribalStaysPage extends StatelessWidget {
  const TribalStaysPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> stays = [
      {
        'title': 'Araku Tribal Homestay',
        'location': 'Araku Valley',
        'price': '₹1500/night',
        'rating': 4.5,
        'image': 'assets/images/araku_stay.jpg',
      },
      {
        'title': 'Bastar Tribal Village',
        'location': 'Bastar',
        'price': '₹1200/night',
        'rating': 4.2,
        'image': 'assets/images/bastar_stay.jpg',
      },
      {
        'title': 'Dandakaranya Cottages',
        'location': 'Dandakaranya',
        'price': '₹1800/night',
        'rating': 4.7,
        'image': 'assets/images/dandakaranya_stay.jpg',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tribal Stays'),
        backgroundColor: AppColors.primary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stays.length,
        itemBuilder: (context, index) {
          final stay = stays[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    stay['image'],
                    height: 180,
                    fit: BoxFit.cover,
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
                          Text(
                            stay['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                              children: [
                                const Icon(Icons.star, color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  stay['rating'].toString(),
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
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            stay['location'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            stay['price'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to booking screen
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Book ${stay['title']}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text('Check-in Date'),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          hintText: 'Select check-in date',
                                          suffixIcon: Icon(Icons.calendar_today),
                                        ),
                                        readOnly: true,
                                        onTap: () async {
                                          // Show date picker
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      const Text('Check-out Date'),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          hintText: 'Select check-out date',
                                          suffixIcon: Icon(Icons.calendar_today),
                                        ),
                                        readOnly: true,
                                        onTap: () async {
                                          // Show date picker
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      const Text('Guests'),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {},
                                          ),
                                          const Text('1'),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Booking successful!'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.tribalPrimary,
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                          ),
                                          child: const Text('Book Now'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tribalPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Book Now'),
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
}
