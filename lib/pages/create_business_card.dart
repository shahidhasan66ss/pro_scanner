import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateBusinessCard extends StatefulWidget {
  const CreateBusinessCard({Key? key}) : super(key: key);

  @override
  _CreateBusinessCardState createState() => _CreateBusinessCardState();
}

class _CreateBusinessCardState extends State<CreateBusinessCard> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _jobTitleController = TextEditingController();
  TextEditingController _jobPlaceController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  String _generatedQRCode = '';
  GlobalKey qrBoundary = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Business Card'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(_nameController, 'Name', Icons.person),
            SizedBox(height: 10),
            _buildTextField(_jobTitleController, 'Job Title', Icons.work),
            SizedBox(height: 10),
            _buildTextField(_jobPlaceController, 'Job Place', Icons.location_city),
            SizedBox(height: 10),
            _buildTextField(_addressController, 'Address', Icons.home),
            SizedBox(height: 10),
            _buildTextField(_contactController, 'Contact', Icons.phone),
            SizedBox(height: 10),
            _buildTextField(_emailController, 'Email', Icons.email),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  _generatedQRCode = _generateQRData();
                });
                _showQRDialog(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Generate QR Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon) {
    return TextField(
      controller: controller,
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue),
        labelText: labelText,
        hintText: 'Enter $labelText',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.all(20.0),
        fillColor: Colors.grey[200],
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  String _generateQRData() {
    return '''
      Name: ${_nameController.text}
      Job Title: ${_jobTitleController.text}
      Job Place: ${_jobPlaceController.text}
      Address: ${_addressController.text}
      Contact: ${_contactController.text}
      Email: ${_emailController.text}
    ''';
  }

  void _showQRDialog(BuildContext context) {
    if (_generatedQRCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields to generate QR code.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Name Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    _nameController.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // QR Code Section with Border
              Stack(
                alignment: Alignment.center,
                children: [
                  RepaintBoundary(
                    key: qrBoundary,
                    child: Container(
                      padding: EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF1A7F64), width: 8),
                      ),
                      child: QrImageView(
                        data: _generatedQRCode,
                        version: QrVersions.auto,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      _copyToClipboard(_generatedQRCode);
                      Navigator.of(context).pop();
                    },
                    child: Text('Copy'),
                  ),
                  TextButton(
                    onPressed: () {
                      _saveQRCode();
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveQRCode() async {
    try {
      // Calculate the dimensions of the QR code
      final double qrSize = 200.0; // Adjust this size as needed
      final double imageSize = MediaQuery.of(context).size.width; // Full screen width

      final qrPainter = QrPainter(
        data: _generatedQRCode,
        version: QrVersions.auto,
        emptyColor: Colors.white, // Set the background color of the QR code
      );

      // Create a picture recorder and a canvas
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Draw a white background
      canvas.drawRect(Rect.fromLTWH(0, 0, imageSize, imageSize), Paint()..color = Colors.white);

      // Calculate the position to center the QR code
      final double left = (imageSize - qrSize) / 2;
      final double top = (imageSize - qrSize) / 2;

      // Translate the canvas to the center position
      canvas.translate(left, top);

      // Paint the QR code onto the canvas
      qrPainter.paint(canvas, Size(qrSize, qrSize));

      // End recording and obtain the picture
      final picture = recorder.endRecording();

      // Convert the picture to an image
      final image = await picture.toImage(imageSize.toInt(), imageSize.toInt());

      // Convert the image to bytes
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      // Save the bytes to the image gallery
      final result = await ImageGallerySaver.saveImage(bytes, quality: 100);

      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('QR code saved to gallery'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save QR code'),
        ));
      }
    } catch (e) {
      print('Error saving QR code: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error saving QR code'),
      ));
    }
  }

  void _copyToClipboard(String data) {
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Copied QR code to clipboard'),
    ));
  }
}
