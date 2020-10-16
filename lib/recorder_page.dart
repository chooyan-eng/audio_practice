import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecorderPage extends StatefulWidget {
  RecorderPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RecorderPageState createState() => _RecorderPageState();
}

class _RecorderPageState extends State<RecorderPage> {
  var _recorder = FlutterSoundRecorder();
  var _player = FlutterSoundPlayer();
  bool _isRecording = false;
  File _currentRecordingFile;
  final _recordFileList = <File>[];

  Future<void> _controlRecord() async {
    if (_isRecording) {
      await _recorder.stopRecorder();
      _recordFileList.add(_currentRecordingFile);
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
      _currentRecordingFile = File('${tempDir.path}/myrecord_$timestamp.aac');
      await _recorder.startRecorder(
        toFile: _currentRecordingFile.path,
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                _isRecording ? 'RECORDING...' : 'Wait for starting.',
              ),
              const SizedBox(height: 16),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: _recordFileList.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    _player.startPlayer(
                      fromURI: _recordFileList[index].uri.toString(),
                      whenFinished: () => _player.stopPlayer(),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(_recordFileList[index].path),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controlRecord,
        tooltip: 'Increment',
        child: Icon(_isRecording ? Icons.stop : Icons.fiber_manual_record),
      ),
    );
  }
}
