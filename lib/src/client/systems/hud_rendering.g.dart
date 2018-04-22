// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hud_rendering.dart';

// **************************************************************************
// Generator: SystemGenerator
// **************************************************************************

abstract class _$TerrainStatsUpdatingSystem extends EntityProcessingSystem {
  Mapper<Terrain> terrainMapper;
  GameStateManager gameStateManager;
  _$TerrainStatsUpdatingSystem() : super(new Aspect.empty()..allOf([Terrain]));
  @override
  void initialize() {
    super.initialize();
    terrainMapper = new Mapper<Terrain>(Terrain, world);
    gameStateManager = world.getManager(GameStateManager);
  }
}

abstract class _$GodlyPowersStatusSystem extends VoidEntitySystem {
  GameStateManager gameStateManager;
  @override
  void initialize() {
    super.initialize();
    gameStateManager = world.getManager(GameStateManager);
  }
}
