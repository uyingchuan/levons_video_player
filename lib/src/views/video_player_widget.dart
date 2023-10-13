import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../levons_video_player.dart';
import 'widgets/controls_overlay_widget.dart';

class VideoPlayerWidget extends StatelessWidget {
  const VideoPlayerWidget({super.key, required this.controller});

  final VideoPlayerWidgetController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return Container(
        width: constraints.maxWidth,
        height: controller.controlsController.fullScreen.value
            ? MediaQuery.of(context).size.height
            : constraints.maxWidth * controller.aspectRatio,
        color: Colors.black,
        child: ValueListenableBuilder(
            valueListenable: controller.isInitialize,
            builder: (_, val, __) {
              if (val) {
                return _buildPlayerView();
              }
              return controller.placeholder ??
                  const Center(
                    child: CircularProgressIndicator(),
                  );
            }),
      );
    });
  }

  Widget _buildPlayerView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // video player
        AspectRatio(
          aspectRatio: controller.playerController.value.aspectRatio,
          child: Hero(
            tag: 'Player',
            child: VideoPlayer(controller.playerController),
          ),
        ),

        // controls overlay
        ControlsOverlay(playerController: controller),
      ],
    );
  }
}
