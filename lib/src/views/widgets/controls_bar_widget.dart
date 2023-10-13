import 'package:flutter/material.dart';
import 'package:levons_video_player/src/controllers/player_widget_controller.dart';

class ControlsBarWidget extends StatelessWidget {
  const ControlsBarWidget({super.key, required this.playerController});

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
          if (overlayController.fullScreen.value)
            IconButton(
              padding: EdgeInsets.zero,
              iconSize: 20,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => overlayController.toggleControlsView(),
            ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              playerController.title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
