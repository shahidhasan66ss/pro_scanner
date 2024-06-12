import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ScanResultWidget extends StatelessWidget {
  const ScanResultWidget({
    super.key,
    this.result,
    this.onScanAgain,
  });

  final Code? result;
  final Function()? onScanAgain;

  @override
  Widget build(BuildContext context) {
    final isUrl = result?.text != null && Uri.tryParse(result!.text!)?.hasAbsolutePath == true;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                result?.text ?? '',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  decoration: isUrl ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Inverted: ${result?.isInverted}\t\tMirrored: ${result?.isMirrored}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: onScanAgain,
              child: const Text('Scan Again'),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10.0,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: result?.text ?? ''));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Share.share(result?.text ?? '');
                  },
                ),
                if (isUrl)
                  IconButton(
                    icon: const Icon(Icons.open_in_browser),
                    onPressed: () async {
                      _launchURL(context, result?.text ?? '');
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    final directory = await getApplicationDocumentsDirectory();
                    final file = File('${directory.path}/scan_result.txt');
                    await file.writeAsString(result?.text ?? '');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved to file')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    final theme = Theme.of(context);

    if (await url_launcher.canLaunchUrl(Uri())) {
      try {
        await url_launcher.launch(url);
      } catch (e) {
        print('Error launching URL in native app: $e');
      }
    } else {
      try {
        await launchUrl(
          Uri.parse(url),
          options: LaunchOptions(
            barColor: theme.colorScheme.surface,
            onBarColor: theme.colorScheme.onSurface,
            barFixingEnabled: false,
          ),
        );
      } catch (e) {
        print('Error launching URL in custom tabs: $e');
      }
    }
  }
}
