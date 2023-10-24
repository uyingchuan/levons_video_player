import 'package:flutter/material.dart';
import 'package:levons_video_player/src/drawer/drawer.dart';
import 'package:levons_video_player/src/levons_player_controller.dart';
import 'package:levons_video_player/src/utils/date.dart';
import 'package:video_player/video_player.dart';

part 'controls_bar_widget.dart';
part 'controls_bottom_widget.dart';

class ControlsOverlay extends StatelessWidget {
  const ControlsOverlay({super.key, required this.controller});

  final LevonsPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => controller.toggleControlsView(),
      onDoubleTap: () => controller.togglePlayerStatus(),
      child: LayoutBuilder(builder: (_, constraints) {
        return ValueListenableBuilder(
            valueListenable: controller.controlsVisible,
            builder: (_, val, __) {
              return AnimatedSwitcher(
                duration: controller.transitionDuration,
                reverseDuration: controller.transitionDuration,
                child: val
                    ? Stack(
                        children: [
                          // bar
                          Positioned(
                            top: 0,
                            child: Container(
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
                                controller: controller,
                              ),
                            ),
                          ),

                          // controls
                          Positioned(
                            bottom: 0,
                            child: Container(
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
                              child: ControlsBottomWidget(
                                controller: controller,
                              ),
                            ),
                          ),
                        ],
                      )
                    : null,
              );
            });
      }),
    );
  }
}
