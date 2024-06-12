import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:flutter/services.dart';
import 'package:pro_scanner/widgets/custom_btn.dart';

class ORCScan extends StatefulWidget {
  const ORCScan({super.key});

  @override
  State<ORCScan> createState() => _ORCScanState();
}

class _ORCScanState extends State<ORCScan> {
  String text = "";
  final StreamController<String> controller = StreamController<String>();

  void setText(value) {
    controller.add(value);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OCR")),
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ScalableOCR(
              paintboxCustom: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4.0
                ..color = const Color.fromARGB(153, 102, 160, 241),
              boxLeftOff: 5,
              boxBottomOff: 2.5,
              boxRightOff: 5,
              boxTopOff: 2.5,
              boxHeight: MediaQuery.of(context).size.height / 3,
              getRawData: (value) {
                inspect(value);
              },
              getScannedText: (value) async {
                // Process OCR result asynchronously
                await Future.microtask(() => setText(value)); // Using Future.microtask for async update
              },
            ),
            StreamBuilder<String>(
              stream: controller.stream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Column(
                  children: [
                    Result(
                      text: snapshot.data != null ? snapshot.data! : "",
                    ),
                    if (snapshot.hasData && snapshot.data!.isNotEmpty)
                      CustomButton(
                        btnText: "Copy",
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: snapshot.data!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Text copied to clipboard')),
                          );
                        },
                        icon: Icons.copy,
                        width: 140,
                        height: 40,
                        textColor: Colors.black,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Result extends StatelessWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        "Read text: $text",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
