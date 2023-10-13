import 'package:flutter/cupertino.dart';
import 'package:levons_video_player/src/levons_player_controller.dart';

class PlayerControllerWidget extends InheritedWidget {
  final LevonsPlayerController controller;

  const PlayerControllerWidget(
      {super.key, required super.child, required this.controller});

  static PlayerControllerWidget of(BuildContext context) {
    final PlayerControllerWidget? result =
        context.dependOnInheritedWidgetOfExactType<PlayerControllerWidget>();
    assert(result != null, 'No PlayerControllerWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant PlayerControllerWidget oldWidget) {
    return controller != oldWidget.controller;
  }
}
