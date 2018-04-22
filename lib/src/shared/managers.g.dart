// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'managers.dart';

// **************************************************************************
// Generator: SystemGenerator
// **************************************************************************

abstract class _$WorldMapManager extends Manager {
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Terrain> terrainMapper;
  Mapper<Fire> fireMapper;
  Mapper<Temperature> temperatureMapper;
  Mapper<Fertility> fertilityMapper;
  Mapper<Humidity> humidityMapper;
  @override
  void initialize() {
    super.initialize();
    tilePositionMapper = new Mapper<TilePosition>(TilePosition, world);
    terrainMapper = new Mapper<Terrain>(Terrain, world);
    fireMapper = new Mapper<Fire>(Fire, world);
    temperatureMapper = new Mapper<Temperature>(Temperature, world);
    fertilityMapper = new Mapper<Fertility>(Fertility, world);
    humidityMapper = new Mapper<Humidity>(Humidity, world);
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

abstract class _$ViewProjectionManager extends Manager {
  Mapper<Camera> cameraMapper;
  CameraManager cameraManager;
  @override
  void initialize() {
    super.initialize();
    cameraMapper = new Mapper<Camera>(Camera, world);
    cameraManager = world.getManager(CameraManager);
  }
}

abstract class _$TerrainChangeManager extends Manager {
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Terrain> terrainMapper;
  @override
  void initialize() {
    super.initialize();
    tilePositionMapper = new Mapper<TilePosition>(TilePosition, world);
    terrainMapper = new Mapper<Terrain>(Terrain, world);
  }
}
