// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hud_rendering.dart';

// **************************************************************************
// SystemGenerator
// **************************************************************************

abstract class _$TerrainStatsUpdatingSystem extends EntityProcessingSystem {
  Mapper<Terrain> terrainMapper;
  GameStateManager gameStateManager;
  _$TerrainStatsUpdatingSystem() : super(Aspect.empty()..allOf([Terrain]));
  @override
  void initialize() {
    super.initialize();
    terrainMapper = Mapper<Terrain>(world);
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$GodlyPowersStatusSystem extends VoidEntitySystem {
  GameStateManager gameStateManager;
  @override
  void initialize() {
    super.initialize();
    gameStateManager = world.getManager<GameStateManager>();
  }
}
