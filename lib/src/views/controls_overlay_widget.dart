import 'package:flutter/material.dart';

import '../levons_player_controller.dart';
import 'controls_bar_widget.dart';
import 'controls_widget.dart';

class ControlsOverlay extends StatelessWidget {
  const ControlsOverlay({super.key, required this.controller});

  final LevonsPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => controller.toggleControlsView(),
      child: LayoutBuilder(builder: (_, constraints) {
        return Stack(
          children: [
            // bar
            Positioned(
              top: 0,
              child: ValueListenableBuilder(
                  valueListenable: controller.controlsVisible,
                  builder: (_, val, ___) {
                    return AnimatedSwitcher(
                      duration: controller.transitionDuration,
                      reverseDuration: controller.transitionDuration,
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
                                controller: controller,
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
                  valueListenable: controller.controlsVisible,
                  builder: (_, val, ___) {
                    return AnimatedSwitcher(
                      duration: controller.transitionDuration,
                      reverseDuration: controller.transitionDuration,
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
                                controller: controller,
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
