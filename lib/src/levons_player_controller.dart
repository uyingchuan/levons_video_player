import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:levons_video_player/src/views/fullscreen_video_player.dart';
import 'package:video_player/video_player.dart';

class LevonsPlayerController {
  late final GlobalKey playerKey;

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

  /// 控制播放器控件视图展示隐藏
  final controlsVisible = ValueNotifier(false);
  final visibleDuration = const Duration(seconds: 3);
  final transitionDuration = const Duration(milliseconds: 300);
  Timer? controlsTimer;

  /// 控制全屏播放
  final fullScreen = ValueNotifier(false);

  final isInitialize = ValueNotifier(false);
  final isPlaying = ValueNotifier(false);
  final isBuffering = ValueNotifier(false);
  final isFinished = ValueNotifier(false);

  final position = ValueNotifier(Duration.zero);
  final duration = ValueNotifier(Duration.zero);
  Timer? positionTimer;

  late final VideoPlayerController playerController;

  LevonsPlayerController({
    required this.title,
    required this.sourcesMap,
    this.defaultSourceName,
    this.placeholder,
  }) {
    playerKey = GlobalKey();
    playerController = VideoPlayerController.networkUrl(Uri.parse(
        sourcesMap[defaultSourceName] ?? sourcesMap.entries.first.value));
    playerController.initialize().then((_) => isInitialize.value = true);
    playerController.addListener(_playerListener);
  }

  /// 播放视频
  playingVideo() {
    playerController.play();
  }

  /// 暂停视频播放
  pauseVideo() {
    playerController.pause();
  }

  /// 控制视图的显示与隐藏
  void toggleControlsView() {
    controlsVisible.value = !controlsVisible.value;
    _resetControlViewTimer();
  }

  // 重置控制视图的自动隐藏定时器
  _resetControlViewTimer() {
    controlsTimer?.cancel();
    controlsTimer = Timer(visibleDuration, () {
      controlsVisible.value = false;
    });
  }

  /// 控制播放器的全屏状态
  toggleFullScreen(context) {
    if (fullScreen.value) {
      exitFullScreen(context);
    } else {
      setFullScreen(context);
    }
  }

  /// 全屏播放
  void setFullScreen(context) async {
    if (fullScreen.value) return;
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
    fullScreen.value = true;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await Navigator.of(context).push(route);
  }

  /// 推出全屏
  exitFullScreen(context) async {
    if (!fullScreen.value) return;
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    fullScreen.value = false;
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
