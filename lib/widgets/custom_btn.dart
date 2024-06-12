import 'dart:ui';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String btnText;
  final VoidCallback onPressed;
  final Color? color;
  final double? height;
  final double? width;
  final IconData? icon;
  final Color? textColor;
  final Color? iconColor;
  final Image? image;
  final Color? imageColor;

  const CustomButton({
    Key? key,
    required this.btnText,
    required this.onPressed,
    this.color,
    this.height,
    this.width,
    this.icon,
    this.textColor,
    this.iconColor,
    this.image,
    this.imageColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height ?? 55,
        width: width ?? MediaQuery.of(context).size.width - 60,
        child: Stack(
          children: [
            // Blurred background effect
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: color ?? Colors.white.withOpacity(0.2), // Semi-transparent color
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: (color ?? Colors.blueGrey).withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (image != null) ...[
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        imageColor ?? Colors.transparent,
                        BlendMode.srcATop,
                      ),
                      child: image,
                    ),
                    SizedBox(width: 10), // Space between image and text
                  ] else if (icon != null) ...[
                    Icon(icon, color: iconColor),
                    SizedBox(width: 15), // Space between icon and text
                  ],
                  Text(
                    btnText,
                    style: TextStyle(color: textColor ?? Colors.white, fontSize: 19),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
