import 'package:flutter/material.dart';
import 'package:levons_video_player/src/levons_player_controller.dart';

class ControlsBarWidget extends StatelessWidget {
  const ControlsBarWidget({super.key, required this.controller});

  final LevonsPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.paddingOf(context).left,
      ),
      child: Row(
        children: [
          if (controller.fullScreen.value)
            IconButton(
              padding: EdgeInsets.zero,
              iconSize: 20,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => controller.toggleControlsView(),
            ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              controller.title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
