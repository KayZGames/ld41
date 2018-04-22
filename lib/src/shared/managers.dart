import 'package:dartemis/dartemis.dart';
import 'package:ld41/shared.dart';

part 'managers.g.dart';

@Generate(Manager, mapper: [TilePosition, Terrain])
class WorldMapManager extends _$WorldMapManager {
  final List<List<int>> neighborDirections = [
    [-1, 1],
    [0, 1],
    [1, 0],
    [1, -1],
    [0, -1],
    [-1, 0],
  ];
  final Map<int, Map<int, Entity>> worldMap = {};

  @override
  void added(Entity entity) {
    if (terrainMapper.has(entity)) {
      final tilePosition = tilePositionMapper[entity];
      worldMap.putIfAbsent(tilePosition.x, () => <int, Entity>{});
      worldMap[tilePosition.x][tilePosition.y] = entity;
    }
  }

  List<Entity> getNeigbhors(int x, int y) {
    final result = <Entity>[];
    for (final direction in neighborDirections) {
      result.add(worldMap[x + direction[0]][y + direction[1]]);
    }
    return result;
  }

  Map<TerrainType, int> getSurroundingTerrainTypes(int x, int y) {
    final result = <TerrainType, int>{};
    final neighbors = getNeigbhors(x, y);
    for (final neighbor in neighbors) {
      var type = terrainMapper[neighbor].type;
      result.putIfAbsent(type, () => 0);
      result[type]++;
    }
    return result;
  }
}

@Generate(Manager)
class GameStateManager extends _$GameStateManager {
  State state = State.started;
  PowerType selectedPower;
  int turn = 1;
}

enum State { playersTurn, endTurn, started }

@Generate(
  Manager,
  manager: [
    TagManager,
    CameraManager,
  ],
  mapper: [
    Position,
    Camera,
  ],
)
class CursorManager extends _$CursorManager {
  double cursorX, cursorY;

  Point<int> getCurrentHexagonFromCursorPosition() {
    final camera = tagManager.getEntity(cameraTag);
    final cameraPosition = positionMapper[camera];
    final zoom = cameraMapper[camera].zoom;
    final relCursorX = cursorX - cameraManager.width / 2;
    final relCursorY = cursorY - cameraManager.height / 2;

    final cameraX = cameraPosition.x;
    final cameraY = cameraPosition.y;
    final cursorInCameraX = cameraX + relCursorX * zoom;
    final cursorInCameraY = -cameraY + relCursorY * zoom;

    final x =
        (cursorInCameraX * sqrt(3) / 3 - cursorInCameraY * 1 / 3) / hexagonSize;
    final y = (cursorInCameraY * 2 / 3) / hexagonSize;
    final z = -x - y;

    var rx = x.round();
    var ry = y.round();
    var rz = z.round();

    final xDiff = (rx - x).abs();
    final yDiff = (ry - y).abs();
    final zDiff = (rz - z).abs();

    if (xDiff > yDiff && xDiff > zDiff) {
      rx = -ry - rz;
    } else if (yDiff > zDiff) {
      ry = -rx - rz;
    } else {
      rz = -rx - ry;
    }
    return new Point(rx, ry);
  }
}

@Generate(
  Manager,
  mapper: [
    Camera,
  ],
  manager: [
    CameraManager,
  ],
)
class ViewProjectionManager extends _$ViewProjectionManager {
  Matrix4 getOrthographicMatrix(Position cameraPosition, double zoom) {
    final cameraX = cameraPosition.x;
    final cameraY = cameraPosition.y;
    final width = cameraManager.width;
    final height = cameraManager.height;

    final orthographicMatrix = new Matrix4.identity();
    setOrthographicMatrix(
        orthographicMatrix,
        cameraX - (width / 2) * zoom,
        cameraX + (width / 2) * zoom,
        cameraY - (height / 2) * zoom,
        cameraY + (height / 2) * zoom,
        1.0,
        -1.0);
    return orthographicMatrix;
  }
}
