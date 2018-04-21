// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'managers.dart';

// **************************************************************************
// Generator: SystemGenerator
// **************************************************************************

abstract class _$WorldMapManager extends Manager {
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Terrain> terrainMapper;
  @override
  void initialize() {
    super.initialize();
    tilePositionMapper = new Mapper<TilePosition>(TilePosition, world);
    terrainMapper = new Mapper<Terrain>(Terrain, world);
  }
}

abstract class _$GameStateManager extends Manager {}
