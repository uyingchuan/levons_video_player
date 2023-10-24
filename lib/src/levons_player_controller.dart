import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'levons_player_settings.dart';
import 'views/fullscreen_video_player.dart';

class LevonsPlayerController {
  late final GlobalKey playerKey;

  final LevonsPlayerSettings settings;

  /// 可提供多个视频源，键名为该源的名称，用来提示切换源
  /// E.g {'240p': 'https://www.w3school.com.cn/example/html5/mov_bbb.mp4'}
  final Map<String, String> sourcesMap;

  /// 视频的播放速度
  final ValueNotifier<double> speed = ValueNotifier(1.0);
  final List<double> speeds = [2.0, 1.5, 1.25, 1.0, 0.75, 0.5];

  /// 播放的视频源
  /// null 则默认播放第一个
  final ValueNotifier<String?> sourceName = ValueNotifier(null);

  /// 控制播放器控件视图展示隐藏
  final controlsVisible = ValueNotifier(false);
  final visibleDuration = const Duration(seconds: 3);
  final transitionDuration = const Duration(milliseconds: 300);
  Timer? controlsTimer;

  /// 控制全屏播放
  final fullScreen = ValueNotifier(false);

  final isInitialized = ValueNotifier(false);
  final isPlaying = ValueNotifier(false);
  final isBuffering = ValueNotifier(false);
  final isFinished = ValueNotifier(false);
  Timer? initialTimer;

  final position = ValueNotifier(Duration.zero);
  final duration = ValueNotifier(Duration.zero);
  Timer? positionTimer;

  late VideoPlayerController playerController;

  /// [defaultSourceName] 控制player初始化后自动播放的视频源
  /// 为空则自动播放[sourcesMap]中第一个
  LevonsPlayerController({
    required this.settings,
    required this.sourcesMap,
    defaultSourceName,
  }) {
    playerKey = GlobalKey();
    sourceName.value = defaultSourceName ?? sourcesMap.entries.first.key;
    playerController = VideoPlayerController.networkUrl(
        Uri.parse(sourcesMap[sourceName.value]!));
    playerController.initialize();
    playerController.addListener(_playerListener);
  }

  /// 切换视频播放速度
  Future<void> changeVideoSpeed(double speed) async {
    if (this.speed.value == speed) return;
    playerController.setPlaybackSpeed(speed);
    this.speed.value = speed;
    playingVideo();
  }

  /// 切换视频源
  Future<void> changeVideoSource(String sourceName) async {
    if (sourceName == this.sourceName.value) return;
    final position = this.position.value;
    await pauseVideo();
    isInitialized.value = false;
    await playerController.dispose();
    playerController =
        VideoPlayerController.networkUrl(Uri.parse(sourcesMap[sourceName]!));
    this.sourceName.value = sourceName;
    await playerController.initialize();
    playerController.addListener(_playerListener);
    await playerController.seekTo(position);
    await playerController.play();
  }

  /// 切换播放、暂停
  void togglePlayerStatus() {
    if (!isPlaying.value) {
      playingVideo();
    } else {
      pauseVideo();
    }
  }

  /// 播放视频
  void playingVideo() async {
    await playerController.play();
  }

  /// 暂停视频播放
  Future<void> pauseVideo() async {
    await playerController.pause();
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
  toggleFullScreen() {
    if (fullScreen.value) {
      exitFullScreen();
    } else {
      setFullScreen();
    }
  }

  /// 全屏播放
  void setFullScreen() async {
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
    await Navigator.of(playerKey.currentContext!).push(route);
  }

  /// 退出全屏
  exitFullScreen() async {
    if (!fullScreen.value) return;
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    fullScreen.value = false;
    Navigator.of(playerKey.currentContext!).pop();
  }

  _playerListener() {
    _playerInitialListener();
    _playerPositionListener();
    _playerStatusListener();
  }

  _playerInitialListener() {
    isInitialized.value = playerController.value.isInitialized;
    if (!isInitialized.value) {
      initialTimer?.cancel();
      initialTimer = Timer(const Duration(seconds: 5), () {
        playerController
            .initialize()
            .whenComplete(() => _playerInitialListener());
      });
    }
  }

  _playerPositionListener() {
    duration.value = playerController.value.duration;
    position.value = playerController.value.position;
    if (!playerController.value.isInitialized) {
      isBuffering.value = true;
      return;
    }
    if (!playerController.value.isPlaying) {
      positionTimer?.cancel();
      return;
    }
    positionTimer = Timer(const Duration(milliseconds: 100), () {
      _playerPositionListener();
    });
  }

  _playerStatusListener() {
    if (playerController.value.isCompleted) {
      isBuffering.value = false;
      isPlaying.value = false;
      isFinished.value = true;
      return;
    }
    isPlaying.value = playerController.value.isPlaying;
    isBuffering.value = playerController.value.isBuffering;
  }

  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    positionTimer?.cancel();
    initialTimer?.cancel();
    controlsTimer?.cancel();
    playerController.dispose();
    isInitialized.dispose();
    isPlaying.dispose();
    isBuffering.dispose();
    isFinished.dispose();
    position.dispose();
  }
}
