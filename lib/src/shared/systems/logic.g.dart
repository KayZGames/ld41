// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logic.dart';

// **************************************************************************
// Generator: SystemGenerator
// **************************************************************************

abstract class _$FireSystem extends EntityProcessingSystem {
  Mapper<Fire> fireMapper;
  Mapper<Terrain> terrainMapper;
  TerrainChangeManager terrainChangeManager;
  GameStateManager gameStateManager;
  _$FireSystem() : super(new Aspect.empty()..allOf([Fire, Terrain]));
  @override
  void initialize() {
    super.initialize();
    fireMapper = new Mapper<Fire>(Fire, world);
    terrainMapper = new Mapper<Terrain>(Terrain, world);
    terrainChangeManager = world.getManager(TerrainChangeManager);
    gameStateManager = world.getManager(GameStateManager);
  }
}

abstract class _$FinishEndTurnSystem extends VoidEntitySystem {
  GameStateManager gameStateManager;
  @override
  void initialize() {
    super.initialize();
    gameStateManager = world.getManager(GameStateManager);
  }
}

abstract class _$FinishGameStartedSystem extends VoidEntitySystem {
  GameStateManager gameStateManager;
  @override
  void initialize() {
    super.initialize();
    gameStateManager = world.getManager(GameStateManager);
  }
}

abstract class _$ExecutePowerSystem extends EntityProcessingSystem {
  Mapper<ExecutePower> executePowerMapper;
  Mapper<Terrain> terrainMapper;
  Mapper<Temperature> temperatureMapper;
  Mapper<Fertility> fertilityMapper;
  Mapper<Humidity> humidityMapper;
  GameStateManager gameStateManager;
  TerrainChangeManager terrainChangeManager;
  _$ExecutePowerSystem()
      : super(new Aspect.empty()..allOf([ExecutePower, Terrain]));
  @override
  void initialize() {
    super.initialize();
    executePowerMapper = new Mapper<ExecutePower>(ExecutePower, world);
    terrainMapper = new Mapper<Terrain>(Terrain, world);
    temperatureMapper = new Mapper<Temperature>(Temperature, world);
    fertilityMapper = new Mapper<Fertility>(Fertility, world);
    humidityMapper = new Mapper<Humidity>(Humidity, world);
    gameStateManager = world.getManager(GameStateManager);
    terrainChangeManager = world.getManager(TerrainChangeManager);
  }
}
