import 'package:flutter/material.dart';
import 'package:levons_video_player/levons_video_player.dart';

import 'controls_bar_widget.dart';
import 'controls_widget.dart';

class ControlsOverlay extends StatelessWidget {
  const ControlsOverlay({super.key, required this.playerController});

  final VideoPlayerWidgetController playerController;

  @override
  Widget build(BuildContext context) {
    final overlayController = playerController.controlsController;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => overlayController.toggleControlsView(),
      child: LayoutBuilder(builder: (_, constraints) {
        return Stack(
          children: [
            // bar
            Positioned(
              top: 0,
              child: ValueListenableBuilder(
                  valueListenable: overlayController.visible,
                  builder: (_, val, ___) {
                    return AnimatedSwitcher(
                      duration: overlayController.transitionDuration,
                      reverseDuration: overlayController.transitionDuration,
                      child: val
                          ? Container(
                              height: 40,
                              width: constraints.maxWidth,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Color.fromRGBO(0, 0, 0, .1),
                                    Color.fromRGBO(0, 0, 0, .7),
                                  ],
                                ),
                              ),
                              child: ControlsBarWidget(
                                playerController: playerController,
                              ),
                            )
                          : null,
                    );
                  }),
            ),

            // controls
            Positioned(
              bottom: 0,
              child: ValueListenableBuilder(
                  valueListenable: overlayController.visible,
                  builder: (_, val, ___) {
                    return AnimatedSwitcher(
                      duration: overlayController.transitionDuration,
                      reverseDuration: overlayController.transitionDuration,
                      child: val
                          ? Container(
                              height: 40,
                              width: constraints.maxWidth,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Color.fromRGBO(0, 0, 0, .7),
                                    Color.fromRGBO(0, 0, 0, .1),
                                  ],
                                ),
                              ),
                              child: ControlsWidget(
                                playerController: playerController,
                              ),
                            )
                          : null,
                    );
                  }),
            ),
          ],
        );
      }),
    );
  }
}
