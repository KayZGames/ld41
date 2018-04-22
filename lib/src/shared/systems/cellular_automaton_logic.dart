import 'package:dartemis/dartemis.dart';
import 'package:ld41/shared.dart';
import 'package:ld41/src/shared/managers.dart';

part 'cellular_automaton_logic.g.dart';

@Generate(
  EntityProcessingSystem,
  allOf: [
    Temperature,
    TilePosition,
  ],
  manager: [
    WorldMapManager,
    GameStateManager,
  ],
)
class PrepareTemperatureChangeSystem extends _$PrepareTemperatureChangeSystem {
  @override
  void processEntity(Entity entity) {
    final tilePosition = tilePositionMapper[entity];
    final avgTemp = worldMapManager.getAverageSurroundingTemperature(
        tilePosition.x, tilePosition.y);
    final temperature = temperatureMapper[entity];
    temperature.nextCelcius = temperature.celsius * 0.95 + avgTemp * 0.05;
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.endTurn;
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Fertility,
    TilePosition,
  ],
  manager: [
    WorldMapManager,
    GameStateManager,
  ],
)
class PrepareFertilityChangeSystem extends _$PrepareFertilityChangeSystem {
  @override
  void processEntity(Entity entity) {
    final tilePosition = tilePositionMapper[entity];
    final avgTemp = worldMapManager.getAverageSurroundingFertility(
        tilePosition.x, tilePosition.y);
    final fertility = fertilityMapper[entity];
    fertility.nextPercentage = fertility.percentage * 0.95 + avgTemp * 0.05;
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.endTurn;
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Humidity,
    TilePosition,
  ],
  manager: [
    WorldMapManager,
    GameStateManager,
  ],
)
class PrepareHumidityChangeSystem extends _$PrepareHumidityChangeSystem {
  @override
  void processEntity(Entity entity) {
    final tilePosition = tilePositionMapper[entity];
    final avgTemp = worldMapManager.getAverageSurroundingHumidity(
        tilePosition.x, tilePosition.y);
    final humidity = humidityMapper[entity];
    humidity.nextPercentage = humidity.percentage * 0.95 + avgTemp * 0.05;
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.endTurn;
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
    Temperature,
  ],
  manager: [
    GameStateManager,
  ],
)
class TemperatureChangeSystem extends _$TemperatureChangeSystem {
  @override
  void processEntity(Entity entity) {
    final temperature = temperatureMapper[entity];
    temperature.celsius = temperature.nextCelcius;
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.endTurn;
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Fertility,
  ],
  manager: [
    GameStateManager,
  ],
)
class FertilityChangeSystem extends _$FertilityChangeSystem {
  @override
  void processEntity(Entity entity) {
    final fertility = fertilityMapper[entity];
    fertility.percentage = fertility.nextPercentage;
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.endTurn;
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Humidity,
  ],
  manager: [
    GameStateManager,
  ],
)
class HumidityChangeSystem extends _$HumidityChangeSystem {
  @override
  void processEntity(Entity entity) {
    final humidity = humidityMapper[entity];
    humidity.percentage = humidity.nextPercentage;
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.endTurn;
}

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
