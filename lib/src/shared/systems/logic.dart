import 'package:dartemis/dartemis.dart';
import 'package:gamedev_helpers/gamedev_helpers_shared.dart';
import 'package:ld41/shared.dart';
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
      case TerrainType.coast:
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
    TerrainChangeManager,
  ],
  mapper: [
    Fire,
  ],
)
class PrepareTerrainChangeSystem extends _$PrepareTerrainChangeSystem {
  int firesSpread = 0;

  @override
  void processEntity(Entity entity) {
    final terrain = terrainMapper[entity];
    if (terrain.type == TerrainType.endOfWorld) return;
    final tilePosition = tilePositionMapper[entity];
    final surroundingTypes = worldMapManager.getSurroundingTerrainTypes(
        tilePosition.x, tilePosition.y);
    if (terrain.type == TerrainType.grass) {
      final forests = surroundingTypes[TerrainType.forest];
      final jungles = surroundingTypes[TerrainType.jungle];
      if (jungles != null || (forests != null && forests > 1)) {
        terrainChangeManager.changeTerrain(entity, terrain, TerrainType.forest);
      }
    } else if (terrain.type == TerrainType.forest) {
      if (!fireMapper.has(entity)) {
        final fires =
            worldMapManager.getSurroundingFires(tilePosition.x, tilePosition.y);
        if (fires > 0) {
          terrainChangeManager.addFire(entity);
          firesSpread++;
        }
      }
    } else if (terrain.type == TerrainType.barren) {
      final grasslands = surroundingTypes[TerrainType.grass];
      final forests = surroundingTypes[TerrainType.forest];
      final jungles = surroundingTypes[TerrainType.jungle];
      if (forests != null ||
          jungles != null ||
          (grasslands != null && grasslands > 1)) {
        terrainChangeManager.changeTerrain(entity, terrain, TerrainType.grass);
      }
    }
  }

  @override
  void end() {
    if (firesSpread > 0) {
      world.createAndAddEntity([
        new LogMessage(
            gameStateManager.turn,
            'The fire is spreading!! $firesSpread new ${firesSpread == 1
                ? 'fire has'
                : 'fires have'} started!',
            Severity.warning)
      ]);
    }
    firesSpread = 0;
    world.processEntityChanges();
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.endTurn;
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Fire,
    Terrain,
  ],
  manager: [
    TerrainChangeManager,
    GameStateManager,
  ],
)
class FireSystem extends _$FireSystem {
  @override
  void processEntity(Entity entity) {
    final fire = fireMapper[entity];
    fire.turnsBurned++;
    if (fire.turnsBurned > 1) {
      final terrain = terrainMapper[entity];
      terrainChangeManager.burnDown(entity, terrain);
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
class FinishEndTurnSystem extends _$FinishEndTurnSystem {
  @override
  void processSystem() {
    gameStateManager.state = State.playersTurn;
    gameStateManager.turn++;
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
class FinishGameStartedSystem extends _$FinishGameStartedSystem {
  @override
  void processSystem() {
    gameStateManager.state = State.playersTurn;
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.started;
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    ExecutePower,
    Terrain,
  ],
  manager: [
    GameStateManager,
    TerrainChangeManager,
  ],
)
class ExecutePowerSystem extends _$ExecutePowerSystem {
  @override
  void processEntity(Entity entity) {
    final power = executePowerMapper[entity].power;
    entity.removeComponent(ExecutePower);
    if (power == PowerType.human) {
      terrainChangeManager.addHuman(entity);
      world.createAndAddEntity([
        new LogMessage(
            gameStateManager.turn, 'Humans have appeared!!!', Severity.info)
      ]);
    } else if (power == PowerType.forest) {
      var terrain = terrainMapper[entity];
      if (terrain.type == TerrainType.grass ||
          terrain.type == TerrainType.barren ||
          terrain.type == TerrainType.farm) {
        terrainChangeManager.changeTerrain(entity, terrain, TerrainType.forest);
        world.createAndAddEntity([
          new LogMessage(
              gameStateManager.turn, 'A new forest has grown.', Severity.info)
        ]);
      } else if (terrain.type == TerrainType.swamp) {
        terrainChangeManager.changeTerrain(entity, terrain, TerrainType.jungle);
        world.createAndAddEntity([
          new LogMessage(
              gameStateManager.turn, 'A new jungle has grown.', Severity.info)
        ]);
      }
    } else if (power == PowerType.fire) {
      terrainChangeManager.addFire(entity, startedByGod: true);
      world.createAndAddEntity([
        new LogMessage(
            gameStateManager.turn,
            'A fire has started!! Why is there no fire brigade?!',
            Severity.warning)
      ]);
    } else if (power == PowerType.flood) {
      terrainChangeManager.addFlood(entity);
      world.createAndAddEntity([
        new LogMessage(
            gameStateManager.turn,
            'A flood!! Get onto higher ground! Oh no, it\'s a flat earth!',
            Severity.warning)
      ]);
    }
  }

  @override
  void end() {
    world.processEntityChanges();
  }
}
