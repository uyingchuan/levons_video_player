import 'package:flutter/material.dart';
import 'package:levons_video_player/src/levons_player_controller.dart';
import 'package:levons_video_player/src/utils/date.dart';
import 'package:video_player/video_player.dart';

class ControlsWidget extends StatelessWidget {
  const ControlsWidget({super.key, required this.controller});

  final LevonsPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.paddingOf(context).left,
      ),
      child: Row(
        children: [
          ValueListenableBuilder(
              valueListenable: controller.isPlaying,
              builder: (_, val, __) {
                return IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  icon: Icon(
                    val ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () =>
                      val ? controller.pauseVideo() : controller.playingVideo(),
                );
              }),
          Flexible(
            child: VideoProgressIndicator(
              controller.playerController,
              allowScrubbing: true,
              padding: EdgeInsets.zero,
              colors: const VideoProgressColors(
                playedColor: Colors.blueAccent,
                bufferedColor: Color.fromRGBO(255, 255, 255, .5),
                backgroundColor: Color.fromRGBO(255, 255, 255, .2),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: ValueListenableBuilder(
                valueListenable: controller.position,
                builder: (_, val, ___) {
                  final duration = controller.duration.value;
                  return Text(
                    '${DateUtil.formatDuration(val)}/${DateUtil.formatDuration(duration)}',
                    style: const TextStyle(color: Colors.white),
                  );
                }),
          ),
          ValueListenableBuilder(
              valueListenable: controller.fullScreen,
              builder: (_, val, __) {
                return IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 26,
                  icon: Icon(
                    val ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                  ),
                  onPressed: () => controller.toggleFullScreen(context),
                );
              })
        ],
      ),
    );
  }
}
