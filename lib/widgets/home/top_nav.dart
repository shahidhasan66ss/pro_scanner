import 'dart:ui';

import 'package:flutter/material.dart';

class TopNavMenu extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const TopNavMenu({
    required this.title,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: isActive ? Colors.green.withOpacity(0.8): Colors.transparent,
              border: Border.all(width: 0.5, color: Colors.white.withOpacity(0.5)),
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
