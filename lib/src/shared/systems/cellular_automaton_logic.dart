import 'package:dartemis/dartemis.dart';
import 'package:ld41/shared.dart';
import 'package:ld41/src/shared/managers.dart';

part 'cellular_automaton_logic.g.dart';

@Generate(
  EntityProcessingSystem,
  allOf: [
    Temperature,
    TilePosition,
    Terrain,
  ],
  manager: [
    WorldMapManager,
    GameStateManager,
  ],
)
class PrepareTemperatureChangeSystem extends _$PrepareTemperatureChangeSystem {
  @override
  void processEntity(Entity entity) {
    final terrain = terrainMapper[entity];
    final tilePosition = tilePositionMapper[entity];
    final avgTemp = worldMapManager.getAverageSurroundingTemperature(
        tilePosition.x, tilePosition.y);
    final temperature = temperatureMapper[entity];
    final baseTemp = temperatureRange[terrain.type].start;
    temperature.nextCelcius =
        baseTemp * 0.01 + temperature.celsius * 0.95 + avgTemp * 0.04;
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.endTurn;
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Fertility,
    TilePosition,
    Terrain,
  ],
  manager: [
    WorldMapManager,
    GameStateManager,
  ],
)
class PrepareFertilityChangeSystem extends _$PrepareFertilityChangeSystem {
  @override
  void processEntity(Entity entity) {
    final terrain = terrainMapper[entity];
    final tilePosition = tilePositionMapper[entity];
    final avgFertility = worldMapManager.getAverageSurroundingFertility(
        tilePosition.x, tilePosition.y);
    final fertility = fertilityMapper[entity];
    final baseFertility = fertilityRange[terrain.type].start;
    fertility.nextPercentage = baseFertility * 0.01 +
        fertility.percentage * 0.95 +
        avgFertility * 0.04;
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.endTurn;
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Humidity,
    TilePosition,
    Terrain,
  ],
  manager: [
    WorldMapManager,
    GameStateManager,
  ],
)
class PrepareHumidityChangeSystem extends _$PrepareHumidityChangeSystem {
  @override
  void processEntity(Entity entity) {
    final terrain = terrainMapper[entity];
    final tilePosition = tilePositionMapper[entity];
    final avgHumidity = worldMapManager.getAverageSurroundingHumidity(
        tilePosition.x, tilePosition.y);
    final humidity = humidityMapper[entity];
    final baseHumidity = humidityRange[terrain.type].start;
    humidity.nextPercentage =
        baseHumidity * 0.01 + humidity.percentage * 0.95 + avgHumidity * 0.04;
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.endTurn;
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    Terrain,
    TilePosition,
    Temperature,
    Humidity,
    Fertility,
  ],
  manager: [
    WorldMapManager,
    GameStateManager,
    TerrainChangeManager,
  ],
)
class PrepareTerrainChangeSystem extends _$PrepareTerrainChangeSystem {
  int firesSpread = 0;

  @override
  void processEntity(Entity entity) {
    final terrain = terrainMapper[entity];
    final humidity = humidityMapper[entity];
    final temperature = temperatureMapper[entity];
    final fertility = fertilityMapper[entity];
    final tilePosition = tilePositionMapper[entity];

    var x = tilePosition.x;
    var y = tilePosition.y;
    var hasFire = worldMapManager.hasFire(x, y);
    var hasFlood = worldMapManager.hasFlood(x, y);
    if (hasFire) {
      final highestFlood = worldMapManager.getHighestAdjacentHighFlood(x, y);
      if (highestFlood > 0) {
        terrainChangeManager.douseFlames(entity, highestFlood);
      } else {
        temperature.nextCelcius += 5.0;
        humidity.nextPercentage -= 2.5;
        fertility.nextPercentage += 1.0;
      }
    } else if (hasFlood) {
      temperature.nextCelcius -= 1.0;
      humidity.nextPercentage += 1.0;
      fertility.nextPercentage += 1.0;
    } else {
      final highestFlood = worldMapManager.getHighestAdjacentHighFlood(x, y);
      final fires = worldMapManager.getSurroundingFires(x, y);
      var type = terrain.type;
      if (highestFlood > 0) {
        terrainChangeManager.addFlood(entity, highestFlood - 1);
      } else if (fires >= fireResistances[type].fireNeeded) {
        terrainChangeManager.addFire(entity, fireResistances[type].turnsToBurn);
        firesSpread++;
      } else {
        final possibleConversions = terrainConversion[type];
        final target = checkForConversion(
            type, possibleConversions, humidity, temperature, fertility);
        if (target != null) {
          terrainChangeManager.changeTerrain(entity, target);
        } else {
          final surroundingTypes =
              worldMapManager.getSurroundingTerrainTypes(x, y);
          if (type == TerrainType.grass) {
            final settlement = surroundingTypes[TerrainType.settlement];
            if (settlement != null) {
              terrainChangeManager.changeTerrain(entity, TerrainType.farm);
            }
          } else if (type == TerrainType.farm) {
            final settlement = surroundingTypes[TerrainType.settlement];
            if (settlement == null) {
              terrainChangeManager.changeTerrain(entity, TerrainType.grass);
            }
          }
        }
      }
    }
  }

  TerrainType checkForConversion(
      TerrainType currentType,
      Iterable<TerrainType> possibleConversions,
      Humidity humidity,
      Temperature temperature,
      Fertility fertility) {
    if (!(humidityRange[currentType].isInRange(humidity.percentage) &&
        temperatureRange[currentType].isInRange(temperature.celsius) &&
        fertilityRange[currentType].isInRange(fertility.percentage))) {
      for (final terrainType in possibleConversions) {
        if (humidityRange[terrainType].isInRange(humidity.percentage) &&
            temperatureRange[terrainType].isInRange(temperature.celsius) &&
            fertilityRange[terrainType].isInRange(fertility.percentage)) {
          return terrainType;
        }
      }
    }
    return null;
  }

  @override
  void end() {
    if (firesSpread > 0) {
      world.createAndAddEntity([
        new LogMessage(
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
    final colorVec = colorMap[terrain.type];
    color.r = colorVec.x;
    color.g = colorVec.y;
    color.b = colorVec.z;
  }
}
