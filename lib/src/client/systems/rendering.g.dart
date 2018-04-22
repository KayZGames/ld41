// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rendering.dart';

// **************************************************************************
// Generator: SystemGenerator
// **************************************************************************

abstract class _$TileRenderingSystem extends WebGlRenderingSystem {
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Position> positionMapper;
  Mapper<Camera> cameraMapper;
  TagManager tagManager;
  ViewProjectionManager viewProjectionManager;
  GameStateManager gameStateManager;
  _$TileRenderingSystem(RenderingContext2 gl, Aspect aspect)
      : super(gl, aspect..allOf([TilePosition, Position]));
  @override
  void initialize() {
    super.initialize();
    tilePositionMapper = new Mapper<TilePosition>(TilePosition, world);
    positionMapper = new Mapper<Position>(Position, world);
    cameraMapper = new Mapper<Camera>(Camera, world);
    tagManager = world.getManager(TagManager);
    viewProjectionManager = world.getManager(ViewProjectionManager);
    gameStateManager = world.getManager(GameStateManager);
  }
}

abstract class _$TerrainRenderingSystem extends TileRenderingSystem {
  Mapper<Color> colorMapper;
  _$TerrainRenderingSystem(RenderingContext2 gl)
      : super(gl, new Aspect.empty()..allOf([Color]));
  @override
  void initialize() {
    super.initialize();
    colorMapper = new Mapper<Color>(Color, world);
  }
}

abstract class _$TemperatureRenderingSystem extends TileRenderingSystem {
  Mapper<Temperature> temperatureMapper;
  _$TemperatureRenderingSystem(RenderingContext2 gl)
      : super(gl, new Aspect.empty()..allOf([Temperature]));
  @override
  void initialize() {
    super.initialize();
    temperatureMapper = new Mapper<Temperature>(Temperature, world);
  }
}

abstract class _$HumidityRenderingSystem extends TileRenderingSystem {
  Mapper<Humidity> humidityMapper;
  _$HumidityRenderingSystem(RenderingContext2 gl)
      : super(gl, new Aspect.empty()..allOf([Humidity]));
  @override
  void initialize() {
    super.initialize();
    humidityMapper = new Mapper<Humidity>(Humidity, world);
  }
}

abstract class _$FertilityRenderingSystem extends TileRenderingSystem {
  Mapper<Fertility> fertilityMapper;
  _$FertilityRenderingSystem(RenderingContext2 gl)
      : super(gl, new Aspect.empty()..allOf([Fertility]));
  @override
  void initialize() {
    super.initialize();
    fertilityMapper = new Mapper<Fertility>(Fertility, world);
  }
}

abstract class _$CursorRenderingSystem extends VoidWebGlRenderingSystem {
  Mapper<Position> positionMapper;
  Mapper<Camera> cameraMapper;
  TagManager tagManager;
  CameraManager cameraManager;
  CursorManager cursorManager;
  ViewProjectionManager viewProjectionManager;
  _$CursorRenderingSystem(RenderingContext2 gl) : super(gl);
  @override
  void initialize() {
    super.initialize();
    positionMapper = new Mapper<Position>(Position, world);
    cameraMapper = new Mapper<Camera>(Camera, world);
    tagManager = world.getManager(TagManager);
    cameraManager = world.getManager(CameraManager);
    cursorManager = world.getManager(CursorManager);
    viewProjectionManager = world.getManager(ViewProjectionManager);
  }
}

abstract class _$SelectedPowerRenderingSystem extends VoidEntitySystem {
  GameStateManager gameStateManager;
  CursorManager cursorManager;
  @override
  void initialize() {
    super.initialize();
    gameStateManager = world.getManager(GameStateManager);
    cursorManager = world.getManager(CursorManager);
  }
}

abstract class _$LogMessageSystem extends EntityProcessingSystem {
  Mapper<LogMessage> logMessageMapper;
  _$LogMessageSystem() : super(new Aspect.empty()..allOf([LogMessage]));
  @override
  void initialize() {
    super.initialize();
    logMessageMapper = new Mapper<LogMessage>(LogMessage, world);
  }
}

abstract class _$SpriteRenderingSystem extends WebGlSpriteRenderingSystem {
  Mapper<Camera> cameraMapper;
  ViewProjectionManager viewProjectionManager;
  _$SpriteRenderingSystem(RenderingContext2 gl, SpriteSheet sheet)
      : super(gl, sheet, new Aspect.empty());
  @override
  void initialize() {
    super.initialize();
    cameraMapper = new Mapper<Camera>(Camera, world);
    viewProjectionManager = world.getManager(ViewProjectionManager);
  }
}
