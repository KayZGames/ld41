// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rendering.dart';

// **************************************************************************
// SystemGenerator
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
    tilePositionMapper = Mapper<TilePosition>(world);
    positionMapper = Mapper<Position>(world);
    cameraMapper = Mapper<Camera>(world);
    tagManager = world.getManager<TagManager>();
    viewProjectionManager = world.getManager<ViewProjectionManager>();
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$TerrainRenderingSystem extends TileRenderingSystem {
  Mapper<Color> colorMapper;
  _$TerrainRenderingSystem(RenderingContext2 gl)
      : super(gl, Aspect.empty()..allOf([Color]));
  @override
  void initialize() {
    super.initialize();
    colorMapper = Mapper<Color>(world);
  }
}

abstract class _$TemperatureRenderingSystem extends TileRenderingSystem {
  Mapper<Temperature> temperatureMapper;
  _$TemperatureRenderingSystem(RenderingContext2 gl)
      : super(gl, Aspect.empty()..allOf([Temperature]));
  @override
  void initialize() {
    super.initialize();
    temperatureMapper = Mapper<Temperature>(world);
  }
}

abstract class _$HumidityRenderingSystem extends TileRenderingSystem {
  Mapper<Humidity> humidityMapper;
  _$HumidityRenderingSystem(RenderingContext2 gl)
      : super(gl, Aspect.empty()..allOf([Humidity]));
  @override
  void initialize() {
    super.initialize();
    humidityMapper = Mapper<Humidity>(world);
  }
}

abstract class _$FertilityRenderingSystem extends TileRenderingSystem {
  Mapper<Fertility> fertilityMapper;
  _$FertilityRenderingSystem(RenderingContext2 gl)
      : super(gl, Aspect.empty()..allOf([Fertility]));
  @override
  void initialize() {
    super.initialize();
    fertilityMapper = Mapper<Fertility>(world);
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
    positionMapper = Mapper<Position>(world);
    cameraMapper = Mapper<Camera>(world);
    tagManager = world.getManager<TagManager>();
    cameraManager = world.getManager<CameraManager>();
    cursorManager = world.getManager<CursorManager>();
    viewProjectionManager = world.getManager<ViewProjectionManager>();
  }
}

abstract class _$SelectedPowerRenderingSystem extends VoidEntitySystem {
  GameStateManager gameStateManager;
  CursorManager cursorManager;
  @override
  void initialize() {
    super.initialize();
    gameStateManager = world.getManager<GameStateManager>();
    cursorManager = world.getManager<CursorManager>();
  }
}

abstract class _$LogMessageSystem extends EntityProcessingSystem {
  Mapper<LogMessage> logMessageMapper;
  GameStateManager gameStateManager;
  _$LogMessageSystem() : super(Aspect.empty()..allOf([LogMessage]));
  @override
  void initialize() {
    super.initialize();
    logMessageMapper = Mapper<LogMessage>(world);
    gameStateManager = world.getManager<GameStateManager>();
  }
}

abstract class _$SpriteRenderingSystem extends WebGlSpriteRenderingSystem {
  Mapper<Camera> cameraMapper;
  ViewProjectionManager viewProjectionManager;
  _$SpriteRenderingSystem(RenderingContext2 gl, SpriteSheet sheet)
      : super(gl, sheet, Aspect.empty());
  @override
  void initialize() {
    super.initialize();
    cameraMapper = Mapper<Camera>(world);
    viewProjectionManager = world.getManager<ViewProjectionManager>();
  }
}
