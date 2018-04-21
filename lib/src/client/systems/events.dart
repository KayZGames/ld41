import 'dart:html';

import 'package:gamedev_helpers/gamedev_helpers.dart';
import 'package:ld41/shared.dart';
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
  int zoomDelta = 0;

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
    if (zoomDelta > 0) {}
  }

  @override
  void end() {
    endTurn = false;
  }
}

@Generate(
  GenericInputHandlingSystem,
  allOf: [
    Camera,
    Position,
  ],
)
class CameraControllerSystem extends _$CameraControllerSystem {
  num zoomDelta = 0;

  @override
  void initialize() {
    super.initialize();

    document.onMouseWheel.listen((wheelEvent) => zoomDelta = wheelEvent.deltaY);
  }

  @override
  void processEntity(Entity entity) {
    final position = positionMapper[entity];
    final camera = cameraMapper[entity];
    if (up) {
      position.y += 0.03 * camera.zoom;
    } else if (down) {
      position.y -= 0.03 * camera.zoom;
    }
    if (left) {
      position.x -= 0.03 * camera.zoom;
    } else if (right) {
      position.x += 0.03 * camera.zoom;
    }
    if (zoomDelta > 0) {
      camera.zoom += 0.1 * camera.zoom;
    } else if (zoomDelta < 0) {
      camera.zoom -= 0.1 * camera.zoom;
    }
  }

  @override
  void end() {
    zoomDelta = 0;
  }
}
