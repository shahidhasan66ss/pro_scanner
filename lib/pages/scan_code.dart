import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';

import '../widgets/debug_info_widget.dart';
import '../widgets/scan_result_widget.dart';
import '../widgets/unsupported_platform_widget.dart';

class ScanCode extends StatefulWidget {
  const ScanCode({super.key});

  @override
  State<ScanCode> createState() => _ScanCodeState();
}

class _ScanCodeState extends State<ScanCode> {
  Uint8List? createdCodeBytes;

  Code? result;
  Codes? multiResult;

  bool isMultiScan = false;

  bool showDebugInfo = true;
  int successScans = 0;
  int failedScans = 0;

  @override
  Widget build(BuildContext context) {
    final isCameraSupported = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;

    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Scan Code'),
        ),
        body: const UnsupportedPlatformWidget(),
      );
    }

    if (!isCameraSupported) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Scan Code'),
        ),
        body: const Center(
          child: Text('Camera not supported on this platform'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Code'),
      ),
      body: result != null && result?.isValid == true
          ? ScanResultWidget(
        result: result,
        onScanAgain: () => setState(() => result = null),
      )
          : Stack(
        children: [
          ReaderWidget(
            onScan: _onScanSuccess,
            onScanFailure: _onScanFailure,
            onMultiScan: _onMultiScanSuccess,
            onMultiScanFailure: _onMultiScanFailure,
            onMultiScanModeChanged: _onMultiScanModeChanged,
            onControllerCreated: _onControllerCreated,
            isMultiScan: isMultiScan,
            scanDelay: Duration(milliseconds: isMultiScan ? 50 : 500),
            resolution: ResolutionPreset.high,
            lensDirection: CameraLensDirection.back,
            flashOnIcon: const Icon(Icons.flash_on),
            flashOffIcon: const Icon(Icons.flash_off),
            flashAlwaysIcon: const Icon(Icons.flash_on),
            flashAutoIcon: const Icon(Icons.flash_auto),
            galleryIcon: const Icon(Icons.photo_library),
            toggleCameraIcon: const Icon(Icons.switch_camera),
            actionButtonsBackgroundBorderRadius:
            BorderRadius.circular(10),
            actionButtonsBackgroundColor: Colors.black.withOpacity(0.5),
          ),
          if (showDebugInfo)
            DebugInfoWidget(
              successScans: successScans,
              failedScans: failedScans,
              error: isMultiScan ? multiResult?.error : result?.error,
              duration: isMultiScan
                  ? multiResult?.duration ?? 0
                  : result?.duration ?? 0,
              onReset: _onReset,
            ),
        ],
      ),
    );
  }

  void _onControllerCreated(_, Exception? error) {
    if (error != null) {
      // Handle permission or unknown errors
      _showMessage(context, 'Error: $error');
    }
  }

  _onScanSuccess(Code? code) {
    setState(() {
      successScans++;
      result = code;
    });
  }

  _onScanFailure(Code? code) {
    setState(() {
      failedScans++;
      result = code;
    });
    if (code?.error?.isNotEmpty == true) {
      _showMessage(context, 'Error: ${code?.error}');
    }
  }

  _onMultiScanSuccess(Codes codes) {
    setState(() {
      successScans++;
      multiResult = codes;
    });
  }

  _onMultiScanFailure(Codes result) {
    setState(() {
      failedScans++;
      multiResult = result;
    });
    if (result.codes.isNotEmpty == true) {
      _showMessage(context, 'Error: ${result.codes.first.error}');
    }
  }

  _onMultiScanModeChanged(bool isMultiScan) {
    setState(() {
      this.isMultiScan = isMultiScan;
    });
  }

  _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  _onReset() {
    setState(() {
      successScans = 0;
      failedScans = 0;
    });
  }
}
