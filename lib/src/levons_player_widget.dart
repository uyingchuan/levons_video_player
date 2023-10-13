import 'package:flutter/material.dart';

import '../levons_video_player.dart';
import 'levons_player_controller.dart';
import 'views/player_controller_widget.dart';
import 'views/video_player_widget.dart';

class LevonsPlayerWidget extends StatelessWidget {
  const LevonsPlayerWidget({super.key, required this.controller});

  final LevonsPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return PlayerControllerWidget(
      controller: controller,
      child: VideoPlayerWidget(
        key: controller.playerKey,
        controller: controller,
      ),
    );
  }
}
