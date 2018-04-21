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
  double cursorX, cursorY;
}

enum State {
  playersTurn, endTurn, started
}