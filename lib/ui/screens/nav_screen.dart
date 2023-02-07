import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:doll_app/ui/screens/home_screen.dart';
import 'package:doll_app/ui/screens/user_screen.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const UserScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.settings,
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _icons.length,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: TabBar(
          indicatorPadding: EdgeInsets.zero,
          indicator: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: const Color.fromARGB(255, 203, 138, 115),
                width: 3.0,
              ),
            ),
          ),
          tabs: _icons
              .asMap()
              .map((i, e) => MapEntry(
                    i,
                    Tab(
                      icon: Icon(
                        e,
                        color:
                            i == _selectedIndex ? const Color.fromARGB(255, 203, 138, 115) : Colors.black45,
                        size: 30.0,
                      ),
                    ),
                  ))
              .values
              .toList(),
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}

