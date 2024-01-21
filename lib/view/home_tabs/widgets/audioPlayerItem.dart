import 'package:audioplayers/audioplayers.dart';
import 'package:dream2/server/app_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart' as ios;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class AudioPlayerItem extends StatefulWidget {
  final String? audioPath;

  const AudioPlayerItem({
    Key? key,
    this.audioPath,
  }) : super(key: key);

  @override
  _AudioPlayerItemState createState() => _AudioPlayerItemState();
}

class _AudioPlayerItemState extends State<AudioPlayerItem> {
  bool _isPlaying = false;
  bool _downLoading = false;
  String? _url;
  int timeProgress = 0;
  int audioDuration = 0;
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  PlayerState audioPlayerState = PlayerState.PAUSED;
  bool isReady = false;
  void initData() async {
    if (_url == null || _url!.isEmpty) {
      setState(() {
        _downLoading = true;
      });
      _url =
          await FirebaseStorage.instance.ref(widget.audioPath).getDownloadURL();
      await audioPlayer.setUrl(_url!);
      audioDuration = (await audioPlayer.getDuration()) ~/ 1000;
      print(':::::::::::::$audioDuration');
      setState(() {});
      audioPlayer.onDurationChanged.listen((Duration duration) {
        setState(() {
          audioDuration = duration.inSeconds;
        });
      });
      audioPlayer.onAudioPositionChanged.listen((Duration position) async {
        setState(() {
          print('::::::::::::::${position.inSeconds}');
          timeProgress = position.inSeconds;
        });
      });
      setState(() {
        _downLoading = false;
      });
    }
  }

  void _onPlayButtonPressed() async {
    print('Audio Url :::::::::::::::::::::::::: $_url');
    Provider.of<AppProvider>(context, listen: false).setCurrentAudio(_url!);
    await audioPlayer.play(_url!, isLocal: true);
    setState(() {
      isReady = true;
    });
  }

  void changePlayerState(PlayerState state) {
    if (mounted)
      setState(() {
        audioPlayerState = state;
      });
  }

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      audioCache.fixedPlayer?.notificationService?.startHeadlessService();

      // audioPlayer.setReleaseMode(ReleaseMode.STOP);
    }
    initData();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      changePlayerState(state);
    });
  }

  Widget slider() {
    return Container(
      width: double.infinity,
      child: Slider.adaptive(
          value: timeProgress == 0 ? 0.0 : timeProgress.toDouble(),
          max: audioDuration == 0 ? 1.0 : audioDuration.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }

  void seekToSec(int sec) async {
    Duration newPos = Duration(seconds: sec);
    await audioPlayer.seek(newPos);
    Provider.of<AppProvider>(context, listen: false).setCurrentAudio(_url!);
  }

  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString';
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (ctx, data, _) {
        if (data.currentAudioIdId != _url) pauseMusic();
        return SizedBox(
          width: Get.width * 0.9,
          child: Row(
            children: [
              if (_downLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ios.CupertinoActivityIndicator(),
                )
              else
                IconButton(
                  onPressed: () {
                    audioPlayerState == PlayerState.PLAYING
                        ? pauseMusic()
                        : _onPlayButtonPressed();
                  },
                  icon: Icon(audioPlayerState == PlayerState.PLAYING
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded),
                ),
              Text(
                getTimeString(timeProgress),
                style: TextStyle(fontSize: 12.0),
              ),
              Expanded(child: slider()),
              Text(
                getTimeString(audioDuration),
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        );
      },
    );
  }
}
