// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rendering.dart';

// **************************************************************************
// Generator: SystemGenerator
// **************************************************************************

abstract class _$TerrainRenderingSystem extends WebGlRenderingSystem {
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Position> positionMapper;
  Mapper<Color> colorMapper;
  Mapper<Camera> cameraMapper;
  TagManager tagManager;
  ViewProjectionManager viewProjectionManager;
  _$TerrainRenderingSystem(RenderingContext2 gl)
      : super(gl, new Aspect.empty()..allOf([TilePosition, Position, Color]));
  @override
  void initialize() {
    super.initialize();
    tilePositionMapper = new Mapper<TilePosition>(TilePosition, world);
    positionMapper = new Mapper<Position>(Position, world);
    colorMapper = new Mapper<Color>(Color, world);
    cameraMapper = new Mapper<Camera>(Camera, world);
    tagManager = world.getManager(TagManager);
    viewProjectionManager = world.getManager(ViewProjectionManager);
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
