import 'package:flutter/material.dart';
import 'package:lali/core/constants/colors.dart';

class _BlogSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> blogPosts;

  _BlogSearchDelegate(this.blogPosts);

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
    final results = blogPosts.where((post) {
      return post['title'].toLowerCase().contains(query.toLowerCase()) ||
          post['content'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildSearchResults(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Enter a search term'),
      );
    }
    
    final List<Map<String, dynamic>> suggestions = blogPosts.where((post) {
      return post['title'].toLowerCase().contains(query.toLowerCase()) ||
          post['content'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildSearchResults(suggestions);
  }

  Widget _buildSearchResults(List<Map<String, dynamic>> results) {
    if (results.isEmpty) {
      return const Center(
        child: Text('No matching blog posts found'),
      );
    }
    
    // Ensure all results are valid maps
    final validResults = results.whereType<Map<String, dynamic>>().toList();

    return ListView.builder(
      itemCount: validResults.length,
      itemBuilder: (context, index) {
        final post = validResults[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.lightGrey,
            child: Text(
              post['title'][0],
              style: const TextStyle(color: AppColors.grey),
            ),
          ),
          title: Text(post['title']),
          subtitle: Text(
            post['content'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text(post['title']),
                    backgroundColor: AppColors.tribalPrimary,
                  ),
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Text(post['content'] * 5),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class BlogsPage extends StatefulWidget {
  const BlogsPage({super.key});

  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  final List<Map<String, dynamic>> blogPosts = [
    {
      'title': 'Exploring the Tribal Villages of Araku Valley',
      'author': 'Travel Enthusiast',
      'date': 'May 15, 2023',
      'readTime': '5 min read',
      'image': 'assets/images/blog1.jpg',
      'content': 'Discover the hidden gems of Araku Valley and its rich tribal culture...',
    },
    {
      'title': 'Traditional Tribal Cuisines You Must Try',
      'author': 'Food Explorer',
      'date': 'April 28, 2023',
      'readTime': '4 min read',
      'image': 'assets/images/blog2.jpg',
      'content': 'A culinary journey through the unique flavors of tribal cooking...',
    },
    {
      'title': 'The Art of Tribal Handicrafts',
      'author': 'Art & Culture',
      'date': 'April 10, 2023',
      'readTime': '6 min read',
      'image': 'assets/images/blog3.jpg',
      'content': 'Exploring the intricate world of tribal art and craftsmanship...',
    },
  ];

  void _navigateToBlogDetail(Map<String, dynamic> post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(post['title']),
            backgroundColor: AppColors.tribalPrimary,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    post['image'],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(Icons.article, size: 50),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  post['title'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.lightGrey,
                      child: Icon(
                        Icons.person,
                        size: 16,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      post['author'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${post['date']} • ${post['readTime']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  post['content'] * 5, // Simulate longer content
                  style: const TextStyle(fontSize: 16, height: 1.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: _BlogSearchDelegate(blogPosts),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs & Stories'),
        backgroundColor: AppColors.tribalPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearch();
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: blogPosts.length,
        itemBuilder: (context, index) {
          final post = blogPosts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                _navigateToBlogDetail(post);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(
                      post['image'],
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 180,
                        color: Colors.grey[200],
                        child: const Icon(Icons.article, size: 50),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post['content'],
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppColors.lightGrey,
                                  child: Icon(
                                    Icons.person,
                                    size: 12,
                                    color: AppColors.grey,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  post['author'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '• ${post['date']} • ${post['readTime']}',
                              style: const TextStyle(
                                fontSize: 11,
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
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('New Blog Post'),
                  backgroundColor: AppColors.tribalPrimary,
                ),
                body: const Center(
                  child: Text('New Blog Post Form'),
                ),
              ),
            ),
          );
        },
        backgroundColor: AppColors.tribalPrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
