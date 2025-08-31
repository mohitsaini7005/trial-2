import 'package:flutter/material.dart';
import 'mylist_title.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;

  const MyDrawer({super.key, required this.onProfileTap, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          //HEADER
          const DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 64,
            ),
          ),
          //HOME LIST TITLE
          MyListTitle(
            icon: Icons.home,
            text: 'H O M E',
            onTap: () => Navigator.pop(context),
          ),

          //PROFILE LIST TITLE
          MyListTitle(
              icon: Icons.person, text: 'P R O F I L E', onTap: onProfileTap),

          //LOGOUT LIST TITLE
          MyListTitle(
              icon: Icons.logout, text: 'L O G O U T', onTap: onSignOut),
        ],
      ),
    );
  }
}