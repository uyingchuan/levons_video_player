import 'package:flutter/material.dart';
import 'package:levons_video_player/src/controllers/player_widget_controller.dart';
import 'package:levons_video_player/src/utils/date.dart';
import 'package:video_player/video_player.dart';

class ControlsWidget extends StatelessWidget {
  const ControlsWidget({super.key, required this.playerController});

  final VideoPlayerWidgetController playerController;

  @override
  Widget build(BuildContext context) {
    final overlayController = playerController.controlsController;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.paddingOf(context).left,
      ),
      child: Row(
        children: [
          ValueListenableBuilder(
              valueListenable: playerController.isPlaying,
              builder: (_, val, __) {
                return IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  icon: Icon(
                    val ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () => val
                      ? playerController.pauseVideo()
                      : playerController.playingVideo(),
                );
              }),
          Flexible(
            child: VideoProgressIndicator(
              playerController.playerController,
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
                valueListenable: playerController.position,
                builder: (_, val, ___) {
                  final duration = playerController.duration.value;
                  return Text(
                    '${DateUtil.formatDuration(val)}/${DateUtil.formatDuration(duration)}',
                    style: const TextStyle(color: Colors.white),
                  );
                }),
          ),
          ValueListenableBuilder(
              valueListenable: overlayController.fullScreen,
              builder: (_, val, __) {
                return IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 26,
                  icon: Icon(
                    val ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                  ),
                  onPressed: () => playerController.toggleFullScreen(context),
                );
              })
        ],
      ),
    );
  }
}
