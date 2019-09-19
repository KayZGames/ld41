// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logic.dart';

// **************************************************************************
// SystemGenerator
// **************************************************************************

abstract class _$FireSystem extends EntityProcessingSystem {
  Mapper<Fire> fireMapper;
  TerrainChangeManager terrainChangeManager;
  GameStateManager gameStateManager;
  _$FireSystem() : super(Aspect.empty()..allOf([Fire]));
  @override
  void initialize() {
    super.initialize();
    fireMapper = Mapper<Fire>(world);
    terrainChangeManager = world.getManager<TerrainChangeManager>();
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$FloodSystem extends EntityProcessingSystem {
  Mapper<Flood> floodMapper;
  TerrainChangeManager terrainChangeManager;
  GameStateManager gameStateManager;
  _$FloodSystem() : super(Aspect.empty()..allOf([Flood]));
  @override
  void initialize() {
    super.initialize();
    floodMapper = Mapper<Flood>(world);
    terrainChangeManager = world.getManager<TerrainChangeManager>();
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$FinishEndTurnSystem extends VoidEntitySystem {
  GameStateManager gameStateManager;
  @override
  void initialize() {
    super.initialize();
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$FinishGameStartedSystem extends VoidEntitySystem {
  GameStateManager gameStateManager;
  @override
  void initialize() {
    super.initialize();
    gameStateManager = world.getManager<GameStateManager>();
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
      : super(Aspect.empty()..allOf([ExecutePower, Terrain]));
  @override
  void initialize() {
    super.initialize();
    executePowerMapper = Mapper<ExecutePower>(world);
    terrainMapper = Mapper<Terrain>(world);
    temperatureMapper = Mapper<Temperature>(world);
    fertilityMapper = Mapper<Fertility>(world);
    humidityMapper = Mapper<Humidity>(world);
    gameStateManager = world.getManager<GameStateManager>();
    terrainChangeManager = world.getManager<TerrainChangeManager>();
  }
}

abstract class _$HumanAiSystem extends EntityProcessingSystem {
  Mapper<Human> humanMapper;
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Position> positionMapper;
  Mapper<Terrain> terrainMapper;
  WorldMapManager worldMapManager;
  TerrainChangeManager terrainChangeManager;
  GameStateManager gameStateManager;
  _$HumanAiSystem()
      : super(Aspect.empty()..allOf([Human, TilePosition, Position]));
  @override
  void initialize() {
    super.initialize();
    humanMapper = Mapper<Human>(world);
    tilePositionMapper = Mapper<TilePosition>(world);
    positionMapper = Mapper<Position>(world);
    terrainMapper = Mapper<Terrain>(world);
    worldMapManager = world.getManager<WorldMapManager>();
    terrainChangeManager = world.getManager<TerrainChangeManager>();
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$SettlementGrowthSystem extends EntityProcessingSystem {
  Mapper<Settlement> settlementMapper;
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Renderable> renderableMapper;
  Mapper<Fire> fireMapper;
  WorldMapManager worldMapManager;
  TerrainChangeManager terrainChangeManager;
  GameStateManager gameStateManager;
  _$SettlementGrowthSystem()
      : super(Aspect.empty()..allOf([Settlement, TilePosition, Renderable]));
  @override
  void initialize() {
    super.initialize();
    settlementMapper = Mapper<Settlement>(world);
    tilePositionMapper = Mapper<TilePosition>(world);
    renderableMapper = Mapper<Renderable>(world);
    fireMapper = Mapper<Fire>(world);
    worldMapManager = world.getManager<WorldMapManager>();
    terrainChangeManager = world.getManager<TerrainChangeManager>();
    gameStateManager = world.getManager<GameStateManager>();
  }
}
