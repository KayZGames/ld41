import 'package:dartemis/dartemis.dart';
import 'package:ld41/shared.dart';

part 'managers.g.dart';

@Generate(
  Manager,
  mapper: [
    TilePosition,
    Terrain,
    Fire,
    Flood,
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
  final Map<int, Map<int, Entity>> floodMap = {};

  @override
  void added(Entity entity) {
    if (terrainMapper.has(entity)) {
      _addEntityToMap(worldMap, entity);
    }
    if (fireMapper.has(entity)) {
      _addEntityToMap(fireMap, entity);
    }
    if (floodMapper.has(entity)) {
      _addEntityToMap(floodMap, entity);
    }
  }

  @override
  void changed(Entity entity) {
    if (fireMapper.has(entity)) {
      _addEntityToMap(fireMap, entity);
    } else {
      _removeEntityFromMap(fireMap, entity);
    }
    if (floodMapper.has(entity)) {
      _addEntityToMap(floodMap, entity);
    } else {
      _removeEntityFromMap(floodMap, entity);
    }
  }

  @override
  void deleted(Entity entity) {
    _removeEntityFromMap(fireMap, entity);
    _removeEntityFromMap(floodMap, entity);
  }

  void _addEntityToMap(Map<int, Map<int, Entity>> map, Entity entity) {
    final tilePosition = tilePositionMapper[entity];
    map.putIfAbsent(tilePosition.x, () => <int, Entity>{});
    map[tilePosition.x][tilePosition.y] = entity;
  }

  void _removeEntityFromMap(Map<int, Map<int, Entity>> map, Entity entity) {
    final tilePosition = tilePositionMapper[entity];
    if (tilePosition != null &&
        map[tilePosition.x] != null &&
        map[tilePosition.x][tilePosition.y] == entity) {
      map[tilePosition.x].remove(tilePosition.y);
    }
  }

  List<Entity> _getNeigbhors(Map<int, Map<int, Entity>> map, int x, int y) {
    final result = <Entity>[];
    for (final direction in neighborDirections) {
      final entity = _getEntity(map, x + direction[0], y + direction[1]);
      if (entity != null) {
        result.add(entity);
      }
    }
    return result;
  }

  Entity _getEntity(Map<int, Map<int, Entity>> map, int x, int y) {
    var column = map[x];
    if (column != null) {
      final entity = column[y];
      return entity;
    }
    return null;
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

  int getHighestAdjacentHighFlood(int x, int y) {
    var result = 0;
    final floodedNeighbors = _getNeigbhors(floodMap, x, y);
    for (final floodedNeighbor in floodedNeighbors) {
      result = max(floodMapper[floodedNeighbor].turnsRemaining, result);
    }
    return result;
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

  List<int> getDirectionToClosest(TerrainType type, int x, int y) {
    final neighbors = _getNeigbhors(worldMap, x, y);
    final grassland = neighbors
        .where((entity) => terrainMapper[entity].type == TerrainType.grass)
        .map((entity) => tilePositionMapper[entity])
        .toList();
    if (grassland.isNotEmpty) {
      grassland.shuffle(random);
      final target = grassland.first;
      return [target.x - x, target.y - y];
    }
    List<int> randomDirectionProvider = [-1, 0, 1];
    randomDirectionProvider.shuffle(random);
    return [randomDirectionProvider[0], randomDirectionProvider[1]];
  }

  bool hasFire(int x, int y) => _getEntity(fireMap, x, y) != null;
  bool hasFlood(int x, int y) => _getEntity(floodMap, x, y) != null;
}

@Generate(Manager)
class GameStateManager extends _$GameStateManager {
  State state = State.started;
  PowerType selectedPower;
  int turn = 0;
  int idleTurns = 0;
  bool isIdleTurn = true;
  String selectedView = 'terrain';
  int faith = 1001;
  final int maxFaith = 1000;
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

@Generate(
  Manager,
  mapper: [
    TilePosition,
    Terrain,
    Humidity,
    Temperature,
    Fertility,
    Settlement,
  ],
  manager: [
    WorldMapManager,
  ],
)
class TerrainChangeManager extends _$TerrainChangeManager {
  void addFire(Entity entity, int turnsToBurn, {bool startedByGod: false}) {
    _addThingAt(
        entity, new Fire(turnsToBurn + (startedByGod ? -1 : 0)), 'fire');
  }

  void burnDown(Entity entity) {
    final tilePosition = tilePositionMapper[entity];
    final target = worldMapManager.worldMap[tilePosition.x][tilePosition.y];
    if (settlementMapper.has(target)) {
      removeSettlement(target);
      world.createAndAddEntity(
          [new LogMessage('A settlement has burned down.', Severity.warning)]);
    }
    changeTerrain(target, TerrainType.barren);
    entity.deleteFromWorld();
  }

  void addFlood(Entity entity, int turnsRemaining) {
    _addThingAt(entity, new Flood(turnsRemaining), 'flood');
  }

  void removeFlood(Entity entity) {
    entity.deleteFromWorld();
  }

  void addHuman(Entity entity, {int food: 10}) {
    _addThingAt(entity, new Human(food), 'human');
  }

  void _addThingAt(Entity terrainTile, Component component, String sprite) {
    final tilePosition = tilePositionMapper[terrainTile];
    var x = tilePosition.x;
    var y = tilePosition.y;
    final entity = world.createAndAddEntity([
      new TilePosition(x, y),
      new Position(
          x * hexagonWidth + y * hexagonWidth / 2, -y * hexagonHeight * 3 / 4)
    ]);
    _addSprite(entity, component, sprite, changedInWorld: false);
    world.addEntity(entity);
  }

  void removeHuman(Entity entity) {
    entity.deleteFromWorld();
  }

  void changeTerrain(Entity entity, TerrainType to,
      {bool startedByGod: false}) {
    final terrain = terrainMapper[entity];
    terrain.nextType = to;
    if (startedByGod) {
      humidityMapper[entity].percentage = humidityRange[to].start;
      fertilityMapper[entity].percentage = fertilityRange[to].start;
      temperatureMapper[entity].celsius = temperatureRange[to].start;
    }
    entity
      ..addComponent(new ChangeTerrain())
      ..changedInWorld();
  }

  void _addSprite(Entity entity, Component component, String sprite,
      {bool changedInWorld: true}) {
    entity
      ..addComponent(component)
      ..addComponent(new Renderable(sprite, facesRight: false))
      ..addComponent(new Orientation(pi));
    if (changedInWorld) {
      entity.changedInWorld();
    }
  }

  void _removeSprite<T extends Component>(Entity entity) {
    entity
      ..removeComponent<T>()
      ..removeComponent<Renderable>()
      ..removeComponent<Orientation>()
      ..changedInWorld();
  }

  void addSettlement(Entity entity, Terrain terrain, int food) {
    changeTerrain(entity, TerrainType.settlement);
    _addSprite(entity, new Settlement(food), 'settlement1');
  }

  void removeSettlement(Entity entity) {
    changeTerrain(entity, TerrainType.grass);
    _removeSprite<Settlement>(entity);
  }

  void douseFlames(Entity entity, int highestFlood) {
    addFlood(entity, highestFlood - 1);
    final tilePosition = tilePositionMapper[entity];
    worldMapManager.fireMap[tilePosition.x][tilePosition.y].deleteFromWorld();
  }
}
