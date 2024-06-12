import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class OpenFiles extends StatefulWidget {
  const OpenFiles({super.key});

  @override
  _OpenFilesState createState() => _OpenFilesState();
}

class _OpenFilesState extends State<OpenFiles> {
  List<FileSystemEntity> _files = [];
  String _debugInfo = '';

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      _listFiles();
    } else {
      setState(() {
        _debugInfo = 'Storage permission not granted';
      });
    }
  }

  Future<void> _listFiles() async {
    try {
      final rootDirectory = Directory('/storage/document/'); // Root directory for most Android devices
      if (await rootDirectory.exists()) {
        await _traverseDirectory(rootDirectory);
        setState(() {
          if (_files.isEmpty) {
            _debugInfo = 'No document files found';
          }
        });
      } else {
        setState(() {
          _debugInfo = 'Root directory does not exist';
        });
      }
    } catch (e) {
      setState(() {
        _debugInfo = 'Error: ${e.toString()}';
      });
    }
  }

  Future<void> _traverseDirectory(Directory directory) async {
    try {
      await for (var entity in directory.list(recursive: true, followLinks: false)) {
        if (entity is File && _isDocumentFile(entity.path)) {
          setState(() {
            _files.add(entity);
          });
        }
      }
    } catch (e) {
      setState(() {
        _debugInfo = 'Error traversing directory: ${e.toString()}';
      });
    }
  }

  bool _isDocumentFile(String path) {
    const documentExtensions = ['.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', '.txt'];
    return documentExtensions.any((extension) => path.toLowerCase().endsWith(extension));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Files'),
      ),
      body: _files.isNotEmpty
          ? ListView.builder(
        itemCount: _files.length,
        itemBuilder: (context, index) {
          final file = _files[index];
          return ListTile(
            title: Text(file.path.split('/').last),
          );
        },
      )
          : Center(
        child: Text(_debugInfo),
      ),
    );
  }
}
