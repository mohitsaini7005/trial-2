import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '/blocs/notification_bloc.dart';
import '/pages/blogs.dart';
import '/pages/bookmark.dart';
import '/pages/explore.dart';
import '/pages/profile.dart';
import '/pages/states.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  List<IconData> iconList = [
    Icons.home,
    Icons.explore,
    Icons.list,
    Icons.bookmark,
    Icons.person,
    //Icons.settings,
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(index,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 400));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final nb = context.read<NotificationBloc>();
      await nb.initFirebasePushNotification(context);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.blue,
        buttonBackgroundColor: Colors.blue,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        height: 50,
        index: _currentIndex,
        items: iconList
            .map((e) => Icon(e, size: 30, color: Colors.white))
            .toList(),
        onTap: (index) => onTabTapped(index),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const <Widget>[
          Explore(),
          StatesPage(),
          //WeatherPage(),
          BlogPage(),
          BookmarkPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}
