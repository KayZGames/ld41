import 'dart:html';

import 'package:gamedev_helpers/gamedev_helpers.dart';
import 'package:ld41/shared.dart';
import 'package:ld41/src/shared/managers.dart';

part 'events.g.dart';

@Generate(
  VoidEntitySystem,
  manager: [
    GameStateManager,
    WorldMapManager,
    CursorManager,
  ],
  mapper: [
    Terrain,
  ],
)
class HudInteractionSystem extends _$HudInteractionSystem {
  bool endTurn = false;
  bool clicked = false;
  bool cancelPower = false;
  PowerType selectedPower;
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
    document
        .querySelector('.power.human')
        .onClick
        .listen((event) => selectedPower = PowerType.human);
    document
        .querySelector('.power.forest')
        .onClick
        .listen((event) => selectedPower = PowerType.forest);
    document
        .querySelector('.power.fire')
        .onClick
        .listen((event) => selectedPower = PowerType.fire);
    document
        .querySelector('.power.flood')
        .onClick
        .listen((event) => selectedPower = PowerType.flood);

    hud.onMouseMove.listen((mouseEvent) => mouseOffset = mouseEvent.offset);
    hud.onContextMenu.listen((event) => event.preventDefault());
    hud.onMouseUp.listen((event) {
      if (event.button == 0) {
        clicked = true;
      } else if (event.button == 2) {
        cancelPower = true;
      }
    });
  }

  @override
  void processSystem() {
    if (gameStateManager.state == State.playersTurn && endTurn) {
      gameStateManager.state = State.endTurn;
    }
    cursorManager.cursorX = mouseOffset.x;
    cursorManager.cursorY = mouseOffset.y;

    if (selectedPower != null) {
      gameStateManager.selectedPower = selectedPower;
    } else if (cancelPower) {
      gameStateManager.selectedPower = null;
    } else if (clicked && gameStateManager.selectedPower != null) {
      final selectedTile = cursorManager.getCurrentHexagonFromCursorPosition();
      final entity = worldMapManager.worldMap[selectedTile.x][selectedTile.y];
      entity
        ..addComponent(new ExecutePower(gameStateManager.selectedPower))
        ..changedInWorld();
      gameStateManager.selectedPower = null;
    }
  }

  @override
  void end() {
    endTurn = false;
    clicked = false;
    cancelPower = false;
    selectedPower = null;
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
      position.y += 0.3 * sqrt(camera.zoom) * hexagonSize;
    } else if (down) {
      position.y -= 0.3 * sqrt(camera.zoom) * hexagonSize;
    }
    if (left) {
      position.x -= 0.3 * sqrt(camera.zoom) * hexagonSize;
    } else if (right) {
      position.x += 0.3 * sqrt(camera.zoom) * hexagonSize;
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
