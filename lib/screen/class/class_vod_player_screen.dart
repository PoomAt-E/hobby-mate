import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:hobby_mate/widget/appbar.dart';
import 'package:video_player/video_player.dart';

import '../../model/vod.dart';
import 'class_detail_screen.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    super.key,
    // required this.vod
  });

  // final Vod vod;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;
  int? bufferDelay;

  @override
  void initState() {
    initializePlayer();
    super.initState();
  }

  initializePlayer() async {
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    )..initialize().then((value) {
        setControllor();
        setState(() {});
      });
  }

  void setControllor() {
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();
    _chewieController?.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MainAppbar(
          hasBackBtn: true,
        ),
        body: Column(
          children: [
            Container(
                child: _chewieController != null &&
                        _chewieController!
                            .videoPlayerController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Chewie(
                          controller: _chewieController!,
                        ))
                    : Container(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator()))),
            Column(
              children: ['통기타 시작하기', '튜닝하기', '악보 읽기', '코드 읽기']
                  .map((e) => ExpansionTile(
                          title: Text(
                            e,
                          ),
                          children: [
                            ClassWeekBox(
                              title: e,
                            )
                          ]))
                  .toList(),
            )
          ],
        ));
  }
}
