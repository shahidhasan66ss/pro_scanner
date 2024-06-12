import 'dart:ui';
import 'package:flutter/material.dart';

import '../widgets/home/top_nav.dart';
import '../widgets/home/features.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _activeMenu = 'Features';

  void _setActiveMenu(String menu) {
    setState(() {
      _activeMenu = menu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SCANNER Pro",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF0860BC),
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.85), // Change the color and opacity as needed
            ),
          ),
          // Main Content
          Column(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height / 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF0860BC),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(0, 5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TopNavMenu(
                        title: 'Features',
                        isActive: _activeMenu == 'Features',
                        onTap: () => _setActiveMenu('Features'),
                      ),
                      SizedBox(width: 20),
                      TopNavMenu(
                        title: 'Saved',
                        isActive: _activeMenu == 'Saved',
                        onTap: () => _setActiveMenu('Saved'),
                      ),
                      SizedBox(width: 20),
                      TopNavMenu(
                        title: 'History',
                        isActive: _activeMenu == 'History',
                        onTap: () => _setActiveMenu('History'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: _activeMenu == 'Features'
                      ? FeaturesGrid()
                      : _activeMenu == 'Settings'
                      ? SettingsWidget()
                      : ProfileWidget(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Settings Page', style: TextStyle(fontSize: 24)),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('History', style: TextStyle(fontSize: 24)),
    );
  }
}

