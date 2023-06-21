import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:hobby_mate/widget/appbar.dart';
import 'package:video_player/video_player.dart';

import '../../model/vod.dart';
import 'class_detail_screen.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    super.key,
    required this.vod,
    required this.vodGroup,
  });

  final Vod vod;
  final VodGroup vodGroup;

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
      widget.vod.vodURL,
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
        body: SingleChildScrollView(child: Column(
          children: [
            SizedBox(
              height: 300,
                child: _chewieController != null &&
                        _chewieController!
                            .videoPlayerController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Chewie(
                          controller: _chewieController!,
                        ))
                    : Container(
                        padding: const EdgeInsets.all(20),
                        child: const Center(child: CircularProgressIndicator()))),
            const Divider(),
            Column(
                children: widget.vodGroup.vodList!.map((e) {
              final index = widget.vodGroup.vodList!.indexOf(widget.vod);
              return ExpansionTile(
                  title: Text(
                    e.title,
                  ),
                  collapsedTextColor:
                      index == 0 ? Colors.black : Colors.black45,
                  trailing: index == 0
                      ? const Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                          color: Colors.black87,
                        )
                      : const Icon(
                          Icons.lock,
                          size: 20,
                          color: Colors.black45,
                        ),
                  children: [ClassWeekBox(vod: e, onClick: (){
                    _controller = VideoPlayerController.network(
                      e.vodURL,
                    )..initialize().then((value) {
                      setControllor();
                      setState(() {});
                    });
                  })]);
            }).toList())
          ],
        )));
  }
}
