import 'package:dartemis/dartemis.dart';
import 'package:gamedev_helpers/gamedev_helpers_shared.dart';
import 'package:ld41/src/shared/components.dart';
import 'package:ld41/src/shared/managers.dart';

part 'logic.g.dart';

@Generate(
  EntityProcessingSystem,
  allOf: [
    Terrain,
    Color,
    ChangeTerrain,
  ],
)
class TerrainChangeSystem extends _$TerrainChangeSystem {
  @override
  void processEntity(Entity entity) {
    entity
      ..removeComponent(ChangeTerrain)
      ..changedInWorld();
    final terrain = terrainMapper[entity];
    final color = colorMapper[entity];
    terrain.type = terrain.nextType;
    switch (terrain.type) {
      case TerrainType.glacier:
        color.r = 1.0;
        color.g = 1.0;
        color.b = 1.0;
        break;
      case TerrainType.endOfWorld:
        color.r = 0.0;
        color.g = 0.0;
        color.b = 0.0;
        break;
      case TerrainType.ocean:
        color.r = 0.0;
        color.g = 0.0;
        color.b = 1.0;
        break;
      case TerrainType.grass:
        color.r = 0.0;
        color.g = 1.0;
        color.b = 0.0;
        break;
      case TerrainType.shore:
        color.r = 1.0;
        color.g = 1.0;
        color.b = 0.0;
        break;
      case TerrainType.swamp:
        color.r = 0.0;
        color.g = 0.2;
        color.b = 0.0;
        break;
      case TerrainType.forest:
        color.r = 0.0;
        color.g = 0.8;
        color.b = 0.0;
        break;
      case TerrainType.jungle:
        color.r = 0.0;
        color.g = 0.5;
        color.b = 0.0;
        break;
      case TerrainType.barren:
        color.r = 0.5;
        color.g = 0.5;
        color.b = 0.2;
        break;
      case TerrainType.desert:
        color.r = 1.0;
        color.g = 1.0;
        color.b = 0.0;
        break;
      case TerrainType.lake:
        color.r = 0.0;
        color.g = 0.5;
        color.b = 1.0;
        break;
      case TerrainType.farm:
        color.r = 1.0;
        color.g = 1.0;
        color.b = 0.0;
        break;
      default:
        throw new ArgumentError.value(terrain.type, 'tile.type',
            'no color defined for type ${terrain.type}');
    }
  }
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Terrain,
    TilePosition,
  ],
  manager: [
    WorldMapManager,
    GameStateManager,
  ],
)
class PrepareTerrainChangeSystem extends _$PrepareTerrainChangeSystem {
  @override
  void processEntity(Entity entity) {
    final terrain = terrainMapper[entity];
    if (terrain.type == TerrainType.endOfWorld) return;
    final tilePosition = tilePositionMapper[entity];
    final surroundingTypes = worldMapManager.getSurroundingTerrainTypes(
        tilePosition.x, tilePosition.y);
    if (terrain.type == TerrainType.grass) {
      var forests = surroundingTypes[TerrainType.forest];
      if (forests != null) {
        terrain.nextType = TerrainType.forest;
        entity
          ..addComponent(new ChangeTerrain())
          ..changedInWorld();
      }
    }
  }

  @override
  void end() {
    world.processEntityChanges();
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.endTurn;
}

@Generate(
  VoidEntitySystem,
  manager: [
    GameStateManager,
  ],
)
class EndTurnSystem extends _$EndTurnSystem {
  @override
  void processSystem() {
    gameStateManager.state = State.playersTurn;
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.endTurn;
}
