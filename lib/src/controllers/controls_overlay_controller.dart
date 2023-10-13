import 'dart:async';

import 'package:flutter/material.dart';

class ControlsOverlayController {
  final transitionDuration = const Duration(milliseconds: 300);
  final visibleDuration = const Duration(seconds: 3);

  final visible = ValueNotifier(false);
  final fullScreen = ValueNotifier(false);

  Timer? timer;

  toggleControlsView() {
    visible.value = !visible.value;
    _resetControlViewTimer();
  }

  _resetControlViewTimer() {
    timer?.cancel();
    timer = Timer(visibleDuration, () {
      visible.value = false;
    });
  }
}
