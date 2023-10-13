import 'package:flutter/material.dart';
import 'package:levons_video_player/src/controllers/player_widget_controller.dart';
import 'package:levons_video_player/src/views/video_player_widget.dart';

class FullscreenVideoPlayer extends StatelessWidget {
  const FullscreenVideoPlayer({super.key, required this.controller});

  final VideoPlayerWidgetController controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: VideoPlayerWidget(controller: controller),
        ),
      ),
    );
  }
}
