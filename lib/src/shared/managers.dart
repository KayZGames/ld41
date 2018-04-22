import 'package:dartemis/dartemis.dart';
import 'package:ld41/shared.dart';

part 'managers.g.dart';

@Generate(
  Manager,
  mapper: [
    TilePosition,
    Terrain,
    Fire,
    Temperature,
    Fertility,
    Humidity,
  ],
)
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
  final Map<int, Map<int, Entity>> fireMap = {};

  @override
  void added(Entity entity) {
    if (terrainMapper.has(entity)) {
      _addEntityToMap(worldMap, entity);
    }
    if (fireMapper.has(entity)) {
      _addEntityToMap(fireMap, entity);
    }
  }

  @override
  void changed(Entity entity) {
    if (fireMapper.has(entity)) {
      _addEntityToMap(fireMap, entity);
    } else {
      _removeEntityFromMap(fireMap, entity);
    }
  }

  void _addEntityToMap(Map<int, Map<int, Entity>> map, Entity entity) {
    final tilePosition = tilePositionMapper[entity];
    map.putIfAbsent(tilePosition.x, () => <int, Entity>{});
    map[tilePosition.x][tilePosition.y] = entity;
  }

  void _removeEntityFromMap(Map<int, Map<int, Entity>> map, Entity entity) {
    final tilePosition = tilePositionMapper[entity];
    if (map.containsKey(tilePosition.x)) {
      map[tilePosition.x].remove(tilePosition.y);
    }
  }

  List<Entity> _getNeigbhors(Map<int, Map<int, Entity>> map, int x, int y) {
    final result = <Entity>[];
    for (final direction in neighborDirections) {
      var column = map[x + direction[0]];
      if (column != null) {
        final entity = column[y + direction[1]];
        if (entity != null) {
          result.add(entity);
        }
      }
    }
    return result;
  }

  Map<TerrainType, int> getSurroundingTerrainTypes(int x, int y) {
    final result = <TerrainType, int>{};
    final neighbors = _getNeigbhors(worldMap, x, y);
    for (final neighbor in neighbors) {
      if (!fireMapper.has(neighbor)) {
        var type = terrainMapper[neighbor].type;
        result.putIfAbsent(type, () => 0);
        result[type]++;
      }
    }
    return result;
  }

  int getSurroundingFires(int x, int y) {
    return _getNeigbhors(fireMap, x, y).length;
  }

  double getAverageSurroundingTemperature(int x, int y) {
    return _getAverage(x, y, (entity) => temperatureMapper[entity].celsius);
  }

  double getAverageSurroundingFertility(int x, int y) {
    return _getAverage(x, y, (entity) => fertilityMapper[entity].percentage);
  }

  double getAverageSurroundingHumidity(int x, int y) {
    return _getAverage(x, y, (entity) => humidityMapper[entity].percentage);
  }

  double _getAverage(int x, int y, double getValue(Entity entity)) {
    final neighbors = _getNeigbhors(worldMap, x, y);
    final sum = neighbors
        .map((entity) => getValue(entity))
        .fold(0.0, (sum, element) => sum += element);
    return sum / neighbors.length;
  }
}

@Generate(Manager)
class GameStateManager extends _$GameStateManager {
  State state = State.started;
  PowerType selectedPower;
  int turn = 1;
  String selectedView = 'terrain';
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

@Generate(Manager)
class TerrainChangeManager extends _$TerrainChangeManager {
  void addFire(Entity entity, {bool startedByGod: false}) {
    _addSprite(entity, new Fire(startedByGod ? 1 : 0), 'fire');
  }

  void burnDown(Entity entity, Terrain terrain) {
    changeTerrain(entity, terrain, TerrainType.barren);
    _removeSprite(entity, Fire);
  }

  void addFlood(Entity entity) {
    _addSprite(entity, new Flood(), 'flood');
  }

  void removeFlood(Entity entity) {
    _removeSprite(entity, Flood);
  }

  void addHuman(Entity entity) {
    _addSprite(entity, new Human(), 'human');
  }

  void removeHuman(Entity entity) {
    _removeSprite(entity, Human);
  }

  void changeTerrain(Entity entity, Terrain terrain, TerrainType to) {
    terrain.nextType = to;
    entity
      ..addComponent(new ChangeTerrain())
      ..changedInWorld();
  }

  void _addSprite(Entity entity, Component component, String sprite) {
    entity
      ..addComponent(component)
      ..addComponent(new Renderable(sprite, facesRight: false))
      ..addComponent(new Orientation(pi))
      ..changedInWorld();
  }

  void _removeSprite(Entity entity, Type type) {
    entity
      ..removeComponent(type)
      ..removeComponent(Renderable)
      ..removeComponent(Orientation)
      ..changedInWorld();
  }
}
