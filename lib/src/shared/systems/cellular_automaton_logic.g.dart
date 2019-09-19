// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cellular_automaton_logic.dart';

// **************************************************************************
// SystemGenerator
// **************************************************************************

abstract class _$PrepareTemperatureChangeSystem extends EntityProcessingSystem {
  Mapper<Temperature> temperatureMapper;
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Terrain> terrainMapper;
  WorldMapManager worldMapManager;
  GameStateManager gameStateManager;
  _$PrepareTemperatureChangeSystem()
      : super(Aspect.empty()..allOf([Temperature, TilePosition, Terrain]));
  @override
  void initialize() {
    super.initialize();
    temperatureMapper = Mapper<Temperature>(world);
    tilePositionMapper = Mapper<TilePosition>(world);
    terrainMapper = Mapper<Terrain>(world);
    worldMapManager = world.getManager<WorldMapManager>();
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$PrepareFertilityChangeSystem extends EntityProcessingSystem {
  Mapper<Fertility> fertilityMapper;
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Terrain> terrainMapper;
  WorldMapManager worldMapManager;
  GameStateManager gameStateManager;
  _$PrepareFertilityChangeSystem()
      : super(Aspect.empty()..allOf([Fertility, TilePosition, Terrain]));
  @override
  void initialize() {
    super.initialize();
    fertilityMapper = Mapper<Fertility>(world);
    tilePositionMapper = Mapper<TilePosition>(world);
    terrainMapper = Mapper<Terrain>(world);
    worldMapManager = world.getManager<WorldMapManager>();
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$PrepareHumidityChangeSystem extends EntityProcessingSystem {
  Mapper<Humidity> humidityMapper;
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Terrain> terrainMapper;
  WorldMapManager worldMapManager;
  GameStateManager gameStateManager;
  _$PrepareHumidityChangeSystem()
      : super(Aspect.empty()..allOf([Humidity, TilePosition, Terrain]));
  @override
  void initialize() {
    super.initialize();
    humidityMapper = Mapper<Humidity>(world);
    tilePositionMapper = Mapper<TilePosition>(world);
    terrainMapper = Mapper<Terrain>(world);
    worldMapManager = world.getManager<WorldMapManager>();
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$PrepareTerrainChangeSystem extends EntityProcessingSystem {
  Mapper<Terrain> terrainMapper;
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Temperature> temperatureMapper;
  Mapper<Humidity> humidityMapper;
  Mapper<Fertility> fertilityMapper;
  WorldMapManager worldMapManager;
  GameStateManager gameStateManager;
  TerrainChangeManager terrainChangeManager;
  _$PrepareTerrainChangeSystem()
      : super(Aspect.empty()
          ..allOf([Terrain, TilePosition, Temperature, Humidity, Fertility]));
  @override
  void initialize() {
    super.initialize();
    terrainMapper = Mapper<Terrain>(world);
    tilePositionMapper = Mapper<TilePosition>(world);
    temperatureMapper = Mapper<Temperature>(world);
    humidityMapper = Mapper<Humidity>(world);
    fertilityMapper = Mapper<Fertility>(world);
    worldMapManager = world.getManager<WorldMapManager>();
    gameStateManager = world.getManager<GameStateManager>();
    terrainChangeManager = world.getManager<TerrainChangeManager>();
  }
}

abstract class _$TemperatureChangeSystem extends EntityProcessingSystem {
  Mapper<Temperature> temperatureMapper;
  GameStateManager gameStateManager;
  _$TemperatureChangeSystem() : super(Aspect.empty()..allOf([Temperature]));
  @override
  void initialize() {
    super.initialize();
    temperatureMapper = Mapper<Temperature>(world);
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$FertilityChangeSystem extends EntityProcessingSystem {
  Mapper<Fertility> fertilityMapper;
  GameStateManager gameStateManager;
  _$FertilityChangeSystem() : super(Aspect.empty()..allOf([Fertility]));
  @override
  void initialize() {
    super.initialize();
    fertilityMapper = Mapper<Fertility>(world);
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$HumidityChangeSystem extends EntityProcessingSystem {
  Mapper<Humidity> humidityMapper;
  GameStateManager gameStateManager;
  _$HumidityChangeSystem() : super(Aspect.empty()..allOf([Humidity]));
  @override
  void initialize() {
    super.initialize();
    humidityMapper = Mapper<Humidity>(world);
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$TerrainChangeSystem extends EntityProcessingSystem {
  Mapper<Terrain> terrainMapper;
  Mapper<Color> colorMapper;
  Mapper<ChangeTerrain> changeTerrainMapper;
  _$TerrainChangeSystem()
      : super(Aspect.empty()..allOf([Terrain, Color, ChangeTerrain]));
  @override
  void initialize() {
    super.initialize();
    terrainMapper = Mapper<Terrain>(world);
    colorMapper = Mapper<Color>(world);
    changeTerrainMapper = Mapper<ChangeTerrain>(world);
  }
}
