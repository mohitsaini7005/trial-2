import 'package:flutter/material.dart';
import 'package:lali/core/constants/colors.dart';

class _EventSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> events;

  _EventSearchDelegate(this.events);

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
    final results = events.where((event) {
      return event['title'].toLowerCase().contains(query.toLowerCase()) ||
          event['location'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildSearchResults(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Search for events by name or location'),
      );
    }

    final List<Map<String, dynamic>> suggestions = events.where((event) {
      return event['title'].toLowerCase().contains(query.toLowerCase()) ||
          event['location'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildSearchResults(suggestions);
  }

  Widget _buildSearchResults(List<Map<String, dynamic>> results) {
    if (results.isEmpty) {
      return const Center(
        child: Text('No matching events found'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final event = results[index];
        return ListTile(
          leading: const Icon(Icons.event, color: AppColors.tribalPrimary),
          title: Text(event['title']),
          subtitle: Text(event['location']),
          trailing: Text(event['date']),
          onTap: () {
            // Navigate to event details
          },
        );
      },
    );
  }
}

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> events = [
      {
        'title': 'Tribal Dance Festival',
        'date': 'June 15-17, 2023',
        'location': 'Araku Valley',
        'image': 'assets/images/event1.jpg',
        'price': '₹500',
        'isFeatured': true,
      },
      {
        'title': 'Traditional Music Night',
        'date': 'June 20, 2023',
        'location': 'Bastar',
        'image': 'assets/images/event2.jpg',
        'price': '₹300',
        'isFeatured': false,
      },
      {
        'title': 'Tribal Food Fair',
        'date': 'June 25-27, 2023',
        'location': 'Dandakaranya',
        'image': 'assets/images/event3.jpg',
        'price': '₹200',
        'isFeatured': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events & Festivals'),
        backgroundColor: AppColors.tribalPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _EventSearchDelegate(events),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.asset(
                        event['image'],
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.event,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    if (event['isFeatured'] == true)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Featured',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event['date'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event['location'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            event['price'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.tribalPrimary,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                    appBar: AppBar(
                                      title: const Text('Book Event'),
                                      backgroundColor: AppColors.tribalPrimary,
                                    ),
                                    body: SingleChildScrollView(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event['title'],
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                              labelText: 'Phone Number',
                                              border: OutlineInputBorder(),
                                            ),
                                            keyboardType: TextInputType.phone,
                                          ),
                                          const SizedBox(height: 24),
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
                                              child: const Text(
                                                'Confirm Booking',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Create New Event'),
                  backgroundColor: AppColors.tribalPrimary,
                ),
                body: const Center(
                  child: Text('New Event Form'),
                ),
              ),
            ),
          );
        },
        backgroundColor: AppColors.tribalPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Create Event'),
      ),
    );
  }
}
