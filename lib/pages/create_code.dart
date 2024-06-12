import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../widgets/unsupported_platform_widget.dart';

class CreateCode extends StatefulWidget {
  const CreateCode({super.key});

  @override
  State<CreateCode> createState() => _CreateCodeState();
}

class _CreateCodeState extends State<CreateCode> {
  Uint8List? createdCodeBytes;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Create Code'),
        ),
        body: const UnsupportedPlatformWidget(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Code'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          WriterWidget(
            messages: const Messages(
              createButton: 'Create Code',
            ),
            onSuccess: (result, bytes) {
              setState(() {
                createdCodeBytes = bytes;
              });
            },
            onError: (error) {
              _showMessage(context, 'Error: $error');
            },
          ),
          if (createdCodeBytes != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Image.memory(createdCodeBytes ?? Uint8List(0), height: 400),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveImageToGallery,
                    child: const Text('Save to Gallery'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _saveImageToGallery() async {
    if (createdCodeBytes == null) return;

    try {
      final result = await ImageGallerySaver.saveImage(createdCodeBytes!);
      if (result['isSuccess']) {
        _showMessage(context, 'Image saved to gallery!');
      } else {
        _showMessage(context, 'Failed to save image to gallery.');
      }
    } catch (e) {
      _showMessage(context, 'Error saving image: $e');
    }
  }
}
