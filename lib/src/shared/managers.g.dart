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

abstract class _$CursorManager extends Manager {
  Mapper<Position> positionMapper;
  Mapper<Camera> cameraMapper;
  TagManager tagManager;
  CameraManager cameraManager;
  @override
  void initialize() {
    super.initialize();
    positionMapper = new Mapper<Position>(Position, world);
    cameraMapper = new Mapper<Camera>(Camera, world);
    tagManager = world.getManager(TagManager);
    cameraManager = world.getManager(CameraManager);
  }
}
