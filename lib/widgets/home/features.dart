import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pro_scanner/pages/create_code.dart';
import 'package:pro_scanner/pages/open_files.dart';

import '../../pages/scan_code.dart';
import '../../pages/ocr_scan.dart';

class FeaturesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2, // Two columns
      mainAxisSpacing: 12.0,
      crossAxisSpacing: 12.0,
      childAspectRatio: 1.1,
      children: [
        feature_grid_tems(
          itemName: "Scan CODE",
          itemIcon: Icons.qr_code_scanner,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ScanCode(),));
          },
          gradientColors: [Colors.green, Colors.lightGreen],
          iconColor: Colors.lightGreenAccent,
        ),
        feature_grid_tems(
          itemName: "Create CODE",
          itemIcon: Icons.create,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateCode(),));
          },
          gradientColors: [Colors.blue, Colors.lightBlue],
          iconColor: Colors.cyanAccent,
        ),
        feature_grid_tems(
          itemName: "Scan Document",
          itemIcon: Icons.document_scanner,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ScanCode(),));
          },
          gradientColors: [Colors.blue, Colors.lightBlue],
          iconColor: Colors.lightBlue,
        ),
        feature_grid_tems(
          itemName: "Scan Contact",
          itemIcon: Icons.contact_phone,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ORCScan(),));
          },
          gradientColors: [Colors.green, Colors.lightGreen],
          iconColor: Colors.lightGreen,
        ),
        feature_grid_tems(
          itemName: "Scan OCR",
          itemIcon: Icons.text_snippet,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ORCScan(),));
          },
          gradientColors: [Colors.green, Colors.lightGreen],
          iconColor: Colors.green,
        ),
        feature_grid_tems(
          itemName: "Open Here",
          itemIcon: Icons.file_open,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => OpenFiles(),));
          },
          gradientColors: [Colors.blue, Colors.lightBlue],
          iconColor: Colors.lightBlueAccent,
        ),
      ],
    );
  }
}

class feature_grid_tems extends StatelessWidget {
  final String itemName;
  final IconData itemIcon;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final Color iconColor;

  const feature_grid_tems({
    super.key,
    required this.itemName,
    required this.itemIcon,
    required this.onPressed,
    required this.gradientColors,
    required this.iconColor, // Add gradientColors parameter
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  itemIcon,
                  size: 35.0,
                  color: iconColor,
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Text(
                    itemName,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}