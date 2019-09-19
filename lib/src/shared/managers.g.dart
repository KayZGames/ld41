// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'managers.dart';

// **************************************************************************
// SystemGenerator
// **************************************************************************

abstract class _$WorldMapManager extends Manager {
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Terrain> terrainMapper;
  Mapper<Fire> fireMapper;
  Mapper<Flood> floodMapper;
  Mapper<Temperature> temperatureMapper;
  Mapper<Fertility> fertilityMapper;
  Mapper<Humidity> humidityMapper;
  @override
  void initialize() {
    super.initialize();
    tilePositionMapper = Mapper<TilePosition>(world);
    terrainMapper = Mapper<Terrain>(world);
    fireMapper = Mapper<Fire>(world);
    floodMapper = Mapper<Flood>(world);
    temperatureMapper = Mapper<Temperature>(world);
    fertilityMapper = Mapper<Fertility>(world);
    humidityMapper = Mapper<Humidity>(world);
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
    positionMapper = Mapper<Position>(world);
    cameraMapper = Mapper<Camera>(world);
    tagManager = world.getManager<TagManager>();
    cameraManager = world.getManager<CameraManager>();
  }
}

abstract class _$ViewProjectionManager extends Manager {
  Mapper<Camera> cameraMapper;
  CameraManager cameraManager;
  @override
  void initialize() {
    super.initialize();
    cameraMapper = Mapper<Camera>(world);
    cameraManager = world.getManager<CameraManager>();
  }
}

abstract class _$TerrainChangeManager extends Manager {
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Terrain> terrainMapper;
  Mapper<Humidity> humidityMapper;
  Mapper<Temperature> temperatureMapper;
  Mapper<Fertility> fertilityMapper;
  Mapper<Settlement> settlementMapper;
  WorldMapManager worldMapManager;
  @override
  void initialize() {
    super.initialize();
    tilePositionMapper = Mapper<TilePosition>(world);
    terrainMapper = Mapper<Terrain>(world);
    humidityMapper = Mapper<Humidity>(world);
    temperatureMapper = Mapper<Temperature>(world);
    fertilityMapper = Mapper<Fertility>(world);
    settlementMapper = Mapper<Settlement>(world);
    worldMapManager = world.getManager<WorldMapManager>();
  }
}
