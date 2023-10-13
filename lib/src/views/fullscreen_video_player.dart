import 'package:flutter/material.dart';
import 'package:levons_video_player/src/levons_player_controller.dart';
import 'package:levons_video_player/src/views/video_player_widget.dart';

class FullscreenVideoPlayer extends StatelessWidget {
  const FullscreenVideoPlayer({super.key, required this.controller});

  final LevonsPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.exitFullScreen();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        endDrawerEnableOpenDragGesture: false,
        body: Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: VideoPlayerWidget(controller: controller),
        ),
        endDrawer: Drawer(
          backgroundColor: Colors.black,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (var source in controller.sourcesMap.entries)
                  GestureDetector(
                    onTap: () {
                      controller.changeVideoSource(source.key);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: controller.sourceName,
                        builder: (_, val, __) {
                          return Text(
                            source.key,
                            style: TextStyle(
                              color: val == source.key
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
