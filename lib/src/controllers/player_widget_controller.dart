import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:levons_video_player/src/views/fullscreen_video_player.dart';
import 'package:video_player/video_player.dart';

import 'controls_overlay_controller.dart';

class VideoPlayerWidgetController {
  final String title;

  /// 可提供多个视频源，键名为该源的名称，用来提示切换源
  /// E.g {'240p': 'https://www.w3school.com.cn/example/html5/mov_bbb.mp4'}
  final Map<String, String> sourcesMap;

  /// 默认播放的视频源
  /// null 则默认播放第一个
  final String? defaultSourceName;

  /// 播放器比例，默认 9 / 16
  final double aspectRatio = 9 / 16;

  /// 播放器初始化阶段视图
  final Widget? placeholder;

  final isInitialize = ValueNotifier(false);
  final isPlaying = ValueNotifier(false);
  final isBuffering = ValueNotifier(false);
  final isFinished = ValueNotifier(false);

  final position = ValueNotifier(Duration.zero);
  final duration = ValueNotifier(Duration.zero);
  Timer? positionTimer;

  late final VideoPlayerController playerController;

  /// 播放器控件
  final controlsController = ControlsOverlayController();

  VideoPlayerWidgetController({
    required this.title,
    required this.sourcesMap,
    this.defaultSourceName,
    this.placeholder,
  }) {
    playerController = VideoPlayerController.networkUrl(Uri.parse(
        sourcesMap[defaultSourceName] ?? sourcesMap.entries.first.value));
    playerController.initialize().then((_) => isInitialize.value = true);
    playerController.addListener(_playerListener);
  }

  playingVideo() {
    playerController.play();
  }

  pauseVideo() {
    playerController.pause();
  }

  toggleFullScreen(context) {
    if (controlsController.fullScreen.value) {
      exitFullScreen(context);
    } else {
      setFullScreen(context);
    }
  }

  setFullScreen(context) {
    final TransitionRoute<void> route = PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return FullscreenVideoPlayer(
              controller: this,
            );
          },
        );
      },
    );
    controlsController.fullScreen.value = true;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    Navigator.of(context).push(route);
  }

  exitFullScreen(context) async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    controlsController.fullScreen.value = false;
    Navigator.of(context).pop();
  }

  _playerListener() {
    _playerPositionListener();
    _playerStatusListener();
  }

  _playerPositionListener() {
    duration.value = playerController.value.duration;
    position.value = playerController.value.position;
    if (!playerController.value.isPlaying) {
      positionTimer?.cancel();
      return;
    }
    positionTimer = Timer(const Duration(milliseconds: 100), () {
      _playerPositionListener();
    });
  }

  _playerStatusListener() {
    isPlaying.value = playerController.value.isPlaying;
    isBuffering.value = playerController.value.isBuffering;
    isFinished.value = playerController.value.isCompleted;
  }

  void dispose() {
    positionTimer?.cancel();
    playerController.dispose();
    isInitialize.dispose();
    isPlaying.dispose();
    isBuffering.dispose();
    isFinished.dispose();
    position.dispose();
  }
}
