import 'package:flutter/material.dart';
import 'package:levons_video_player/src/levons_player_controller.dart';
import 'package:levons_video_player/src/views/video_player_widget.dart';

class FullscreenVideoPlayer extends StatelessWidget {
  const FullscreenVideoPlayer({super.key, required this.controller});

  final LevonsPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.exitFullScreen();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        endDrawerEnableOpenDragGesture: false,
        body: Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: VideoPlayerWidget(controller: controller),
        ),
      ),
    );
  }
}
