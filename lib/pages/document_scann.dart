import 'package:flutter/material.dart';

import 'basic_oage.dart';
import 'custom_page.dart';
import 'from_gallery_page.dart';

class DocumentScannerPage extends StatelessWidget {
  const DocumentScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const BasicPage(),
                ),
              ),
              child: const Text(
                'Basic example',
              ),
            ),
            // * Custom example page
            ElevatedButton(
              onPressed: () => Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomPage(),
                ),
              ),
              child: const Text(
                'Custom example',
              ),
            ),

            // * From gallery example page
            ElevatedButton(
              onPressed: () => Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) => const FromGalleryPage(),
                ),
              ),
              child: const Text(
                'From gallery example',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
