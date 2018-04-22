// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cellular_automaton_logic.dart';

// **************************************************************************
// Generator: SystemGenerator
// **************************************************************************

abstract class _$PrepareTemperatureChangeSystem extends EntityProcessingSystem {
  Mapper<Temperature> temperatureMapper;
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Terrain> terrainMapper;
  WorldMapManager worldMapManager;
  GameStateManager gameStateManager;
  _$PrepareTemperatureChangeSystem()
      : super(new Aspect.empty()..allOf([Temperature, TilePosition, Terrain]));
  @override
  void initialize() {
    super.initialize();
    temperatureMapper = new Mapper<Temperature>(Temperature, world);
    tilePositionMapper = new Mapper<TilePosition>(TilePosition, world);
    terrainMapper = new Mapper<Terrain>(Terrain, world);
    worldMapManager = world.getManager(WorldMapManager);
    gameStateManager = world.getManager(GameStateManager);
  }
}

abstract class _$PrepareFertilityChangeSystem extends EntityProcessingSystem {
  Mapper<Fertility> fertilityMapper;
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Terrain> terrainMapper;
  WorldMapManager worldMapManager;
  GameStateManager gameStateManager;
  _$PrepareFertilityChangeSystem()
      : super(new Aspect.empty()..allOf([Fertility, TilePosition, Terrain]));
  @override
  void initialize() {
    super.initialize();
    fertilityMapper = new Mapper<Fertility>(Fertility, world);
    tilePositionMapper = new Mapper<TilePosition>(TilePosition, world);
    terrainMapper = new Mapper<Terrain>(Terrain, world);
    worldMapManager = world.getManager(WorldMapManager);
    gameStateManager = world.getManager(GameStateManager);
  }
}

abstract class _$PrepareHumidityChangeSystem extends EntityProcessingSystem {
  Mapper<Humidity> humidityMapper;
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Terrain> terrainMapper;
  WorldMapManager worldMapManager;
  GameStateManager gameStateManager;
  _$PrepareHumidityChangeSystem()
      : super(new Aspect.empty()..allOf([Humidity, TilePosition, Terrain]));
  @override
  void initialize() {
    super.initialize();
    humidityMapper = new Mapper<Humidity>(Humidity, world);
    tilePositionMapper = new Mapper<TilePosition>(TilePosition, world);
    terrainMapper = new Mapper<Terrain>(Terrain, world);
    worldMapManager = world.getManager(WorldMapManager);
    gameStateManager = world.getManager(GameStateManager);
  }
}

abstract class _$PrepareTerrainChangeSystem extends EntityProcessingSystem {
  Mapper<Terrain> terrainMapper;
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Fire> fireMapper;
  WorldMapManager worldMapManager;
  GameStateManager gameStateManager;
  TerrainChangeManager terrainChangeManager;
  _$PrepareTerrainChangeSystem()
      : super(new Aspect.empty()..allOf([Terrain, TilePosition]));
  @override
  void initialize() {
    super.initialize();
    terrainMapper = new Mapper<Terrain>(Terrain, world);
    tilePositionMapper = new Mapper<TilePosition>(TilePosition, world);
    fireMapper = new Mapper<Fire>(Fire, world);
    worldMapManager = world.getManager(WorldMapManager);
    gameStateManager = world.getManager(GameStateManager);
    terrainChangeManager = world.getManager(TerrainChangeManager);
  }
}

abstract class _$TemperatureChangeSystem extends EntityProcessingSystem {
  Mapper<Temperature> temperatureMapper;
  GameStateManager gameStateManager;
  _$TemperatureChangeSystem() : super(new Aspect.empty()..allOf([Temperature]));
  @override
  void initialize() {
    super.initialize();
    temperatureMapper = new Mapper<Temperature>(Temperature, world);
    gameStateManager = world.getManager(GameStateManager);
  }
}

abstract class _$FertilityChangeSystem extends EntityProcessingSystem {
  Mapper<Fertility> fertilityMapper;
  GameStateManager gameStateManager;
  _$FertilityChangeSystem() : super(new Aspect.empty()..allOf([Fertility]));
  @override
  void initialize() {
    super.initialize();
    fertilityMapper = new Mapper<Fertility>(Fertility, world);
    gameStateManager = world.getManager(GameStateManager);
  }
}

abstract class _$HumidityChangeSystem extends EntityProcessingSystem {
  Mapper<Humidity> humidityMapper;
  GameStateManager gameStateManager;
  _$HumidityChangeSystem() : super(new Aspect.empty()..allOf([Humidity]));
  @override
  void initialize() {
    super.initialize();
    humidityMapper = new Mapper<Humidity>(Humidity, world);
    gameStateManager = world.getManager(GameStateManager);
  }
}

abstract class _$TerrainChangeSystem extends EntityProcessingSystem {
  Mapper<Terrain> terrainMapper;
  Mapper<Color> colorMapper;
  Mapper<ChangeTerrain> changeTerrainMapper;
  _$TerrainChangeSystem()
      : super(new Aspect.empty()..allOf([Terrain, Color, ChangeTerrain]));
  @override
  void initialize() {
    super.initialize();
    terrainMapper = new Mapper<Terrain>(Terrain, world);
    colorMapper = new Mapper<Color>(Color, world);
    changeTerrainMapper = new Mapper<ChangeTerrain>(ChangeTerrain, world);
  }
}
