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
  WorldMapManager worldMapManager;
  GameStateManager gameStateManager;
  _$PrepareTerrainChangeSystem()
      : super(new Aspect.empty()..allOf([Terrain, TilePosition]));
  @override
  void initialize() {
    super.initialize();
    terrainMapper = new Mapper<Terrain>(Terrain, world);
    tilePositionMapper = new Mapper<TilePosition>(TilePosition, world);
    worldMapManager = world.getManager(WorldMapManager);
    gameStateManager = world.getManager(GameStateManager);
  }
}

abstract class _$EndTurnSystem extends VoidEntitySystem {
  GameStateManager gameStateManager;
  @override
  void initialize() {
    super.initialize();
    gameStateManager = world.getManager(GameStateManager);
  }
}
