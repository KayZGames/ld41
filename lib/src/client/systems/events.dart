import 'dart:html';

import 'package:gamedev_helpers/gamedev_helpers.dart';
import 'package:ld41/src/shared/managers.dart';

part 'events.g.dart';

@Generate(
  VoidEntitySystem,
  manager: [
    GameStateManager,
  ],
)
class HudInteractionSystem extends _$HudInteractionSystem {
  bool endTurn = false;

  @override
  void initialize() {
    super.initialize();
    document
        .querySelector('#endturn')
        .onClick
        .listen((event) => endTurn = event.button == 0);
  }

  @override
  void processSystem() {
    if (gameStateManager.state == State.playersTurn && endTurn) {
      gameStateManager.state = State.endTurn;
    }
  }

  @override
  void end() {
    endTurn = false;
  }
}
