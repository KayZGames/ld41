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
  final CanvasElement hud;
  Point<num> mouseOffset = new Point(0, 0);

  HudInteractionSystem(this.hud);

  @override
  void initialize() {
    super.initialize();
    document
        .querySelector('#endturn')
        .onClick
        .listen((event) => endTurn = event.button == 0);

    hud.onMouseMove.listen((mouseEvent) => mouseOffset = mouseEvent.offset);
  }

  @override
  void processSystem() {
    if (gameStateManager.state == State.playersTurn && endTurn) {
      gameStateManager.state = State.endTurn;
    }
    gameStateManager.cursorX = mouseOffset.x - hud.width / 2;
    gameStateManager.cursorY = mouseOffset.y - hud.height / 2;
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
      position.y += 0.2 * camera.zoom * hexagonSize;
    } else if (down) {
      position.y -= 0.2 * camera.zoom * hexagonSize;
    }
    if (left) {
      position.x -= 0.2 * camera.zoom * hexagonSize;
    } else if (right) {
      position.x += 0.2 * camera.zoom * hexagonSize;
    }
    if (zoomDelta > 0) {
      camera.zoom += 0.1 * camera.zoom;
    } else if (zoomDelta < 0) {
      camera.zoom -= 0.1 * camera.zoom;
    }
    if (isPressed(KeyCode.SPACE)) {
      position
        ..x = 0.0
        ..y = 0.0;
    }
  }

  @override
  void end() {
    zoomDelta = 0;
  }
}
