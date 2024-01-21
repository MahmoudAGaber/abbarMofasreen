import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dream2/view/widgets/custom_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';

class RecorderView extends StatefulWidget {
  final Function(Recording? recording)? onSaved;

  const RecorderView({
    Key? key,
    @required this.onSaved,
  }) : super(key: key);

  @override
  _RecorderViewState createState() => _RecorderViewState();
}

enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}

class _RecorderViewState extends State<RecorderView> {
  String? _filePath;
  FlutterAudioRecorder2? audioRecorder;

  @override
  void initState() {
    super.initState();
    print(':::::::::::: recording :::::::::::::::::::::::');
    FlutterAudioRecorder2.hasPermissions.then((hasPermision) {
      if (hasPermision!) {
        _recordVoice();
        startTimer();
      }
    });
  }

  Timer? _timer;
  int _start = 0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 60) {
          setState(() {
            timer.cancel();
          });
          _stopRecording();
        } else {
          setState(() {
            _start++;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CupertinoActivityIndicator(),
        Expanded(
          child: Padding(
            child: Text('جارى التسجيل'),
            padding: const EdgeInsets.all(8),
          ),
        ),
        Expanded(
          child: Padding(
            child: Text('00:${_start.toString()}'),
            padding: const EdgeInsets.all(8),
          ),
        ),
        InkWell(
          onTap: () async {
            await _stopRecording();
          },
          child: CustomSvgImage(
            imageName: 'send',
            width: 30.sp,
            height: 30.sp,
          ),
        ),
      ],
    );
  }

  _initRecorder() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath = appDirectory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.aac';

    audioRecorder =
        FlutterAudioRecorder2(filePath, audioFormat: AudioFormat.AAC);
    await audioRecorder!.initialized;
    _filePath = filePath;
  }

  _startRecording() async {
    await audioRecorder!.start();
  }

  Future<bool?> showConfirmation() async {
    return await showDialog<bool>(
        context: context,
        builder: (ctx) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AlertDialog(
                backgroundColor: Colors.black45,
                title: Text(
                  "هل تريد ارسال هذا المقطع الصوتى؟",
                  style: TextStyle(color: Colors.white),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'لا',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(false),
                  ),
                  TextButton(
                    child: Text(
                      'نعم',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(true),
                  ),
                ],
              ),
            ));
  }

  _stopRecording() async {
    final recording = await audioRecorder!.stop();
    print(':::::$_filePath');
    print(':::::${recording!.path}');
    final result = await showConfirmation();
    widget.onSaved!(result == true ? recording : null);
  }

  Future<void> _recordVoice() async {
    final hasPermission = await FlutterAudioRecorder2.hasPermissions;
    if (hasPermission ?? false) {
      await _initRecorder();
      await _startRecording();
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please allow recording from settings.'),
      ));
    }
  }
}
