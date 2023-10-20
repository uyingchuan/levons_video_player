import 'package:flutter/material.dart';

@immutable
class LevonsPlayerSettings {
  /// player controller initialized 之前的占位组件
  final Widget? placeholder;

  /// player title
  final String title;

  /// player title visible
  final bool titleVisible;

  /// 播放器容器高比宽 default: 9 / 16
  final double aspectRatio;

  /// 是否显示当前播放的视频源
  /// 不显示则无法切换视频源
  final bool sourceVisible;

  /// 表明正在加载中状态的组件
  final Widget? buffering;

  const LevonsPlayerSettings({
    this.title = '',
    this.titleVisible = true,
    this.placeholder,
    this.aspectRatio = 9 / 16,
    this.sourceVisible = true,
    this.buffering,
  });

  LevonsPlayerSettings copyWith({
    String? title,
    bool? titleVisible,
    Widget? placeholder,
    double? aspectRatio,
    bool? sourceVisible,
    Widget? buffering,
  }) {
    return LevonsPlayerSettings(
      title: title ?? this.title,
      titleVisible: titleVisible ?? this.titleVisible,
      placeholder: placeholder ?? this.placeholder,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      sourceVisible: sourceVisible ?? this.sourceVisible,
      buffering: buffering ?? this.buffering,
    );
  }
}
