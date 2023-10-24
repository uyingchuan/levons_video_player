part of 'controls_overlay_widget.dart';

class ControlsBottomWidget extends StatelessWidget {
  const ControlsBottomWidget({super.key, required this.controller});

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
                  onPressed: () => controller.togglePlayerStatus(),
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
            margin: const EdgeInsets.only(left: 10, right: 10),
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
          if (!controller.fullScreen.value)
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
                    onPressed: () => controller.toggleFullScreen(),
                  );
                }),
          if (controller.fullScreen.value)
            GestureDetector(
              onTap: () => openEndDrawer(
                context: context,
                drawer: _SpeedListDrawer(controller: controller),
              ),
              child: Container(
                padding: const EdgeInsets.only(right: 16),
                child: ValueListenableBuilder(
                    valueListenable: controller.speed,
                    builder: (_, val, ___) {
                      return Text(
                        '${controller.speed.value}X',
                        style: const TextStyle(color: Colors.white),
                      );
                    }),
              ),
            ),
          if (controller.fullScreen.value)
            GestureDetector(
              onTap: () => openEndDrawer(
                context: context,
                drawer: _SourceListDrawer(controller: controller),
              ),
              child: Container(
                padding: const EdgeInsets.only(right: 16),
                child: ValueListenableBuilder(
                    valueListenable: controller.sourceName,
                    builder: (_, val, ___) {
                      return Text(
                        controller.sourceName.value ?? '',
                        style: const TextStyle(color: Colors.white),
                      );
                    }),
              ),
            ),
        ],
      ),
    );
  }
}

class _SpeedListDrawer extends StatelessWidget {
  const _SpeedListDrawer({required this.controller});

  final LevonsPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 240,
        height: double.infinity,
        alignment: Alignment.center,
        color: Colors.black54,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (var speed in controller.speeds)
              GestureDetector(
                onTap: () {
                  controller.changeVideoSpeed(speed);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: controller.speed,
                    builder: (_, val, __) {
                      return Text(
                        '${speed}X',
                        style: TextStyle(
                          color: val == speed
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
    );
  }
}

class _SourceListDrawer extends StatelessWidget {
  const _SourceListDrawer({required this.controller});

  final LevonsPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 240,
        height: double.infinity,
        alignment: Alignment.center,
        color: Colors.black54,
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
    );
  }
}
