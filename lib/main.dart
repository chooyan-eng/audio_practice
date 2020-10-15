import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isRecording = false;
  var _recorder = FlutterSoundRecorder();
  var _player = FlutterSoundPlayer();
  File _recordFile;

  Future<void> _controlRecord() async {
    if (_isRecording) {
      await _recorder.stopRecorder();
    } else {
      await _startRecording();
    }

    setState(() {
      _isRecording = _recorder.isRecording;
    });
  }

  Future<void> _startRecording() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }

    if (!_isRecording) {
      Directory tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _recordFile = File('${tempDir.path}/myrecord_$timestamp.aac');
      await _recorder.startRecorder(
        toFile: _recordFile.path,
        codec: Codec.aacMP4,
      );
    }
  }

  @override
  void initState() {
    _recorder.openAudioSession();
    _player.openAudioSession();
    super.initState();
  }

  @override
  void dispose() {
    if (_recorder != null) {
      _recorder.closeAudioSession();
      _player.closeAudioSession();
      _recorder = null;
      _player = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _isRecording ? 'RECORDING...' : 'Wait for starting.',
            ),
            const SizedBox(height: 16),
            if (_recordFile != null)
              RaisedButton(
                onPressed: () {
                  _player.startPlayer(
                    fromURI: _recordFile.uri.toString(),
                  );
                },
                child: Center(
                  child: Text('Play'),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controlRecord,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
