// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logic.dart';

// **************************************************************************
// Generator: SystemGenerator
// **************************************************************************

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
  GameStateManager gameStateManager;
  TerrainChangeManager terrainChangeManager;
  _$ExecutePowerSystem()
      : super(new Aspect.empty()..allOf([ExecutePower, Terrain]));
  @override
  void initialize() {
    super.initialize();
    executePowerMapper = new Mapper<ExecutePower>(ExecutePower, world);
    terrainMapper = new Mapper<Terrain>(Terrain, world);
    gameStateManager = world.getManager(GameStateManager);
    terrainChangeManager = world.getManager(TerrainChangeManager);
  }
}
