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
  CameraManager cameraManager;
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
    cameraManager = world.getManager(CameraManager);
  }
}

abstract class _$CursorRenderingSystem extends VoidWebGlRenderingSystem {
  Mapper<Position> positionMapper;
  Mapper<Camera> cameraMapper;
  GameStateManager gameStateManager;
  TagManager tagManager;
  CameraManager cameraManager;
  _$CursorRenderingSystem(RenderingContext2 gl) : super(gl);
  @override
  void initialize() {
    super.initialize();
    positionMapper = new Mapper<Position>(Position, world);
    cameraMapper = new Mapper<Camera>(Camera, world);
    gameStateManager = world.getManager(GameStateManager);
    tagManager = world.getManager(TagManager);
    cameraManager = world.getManager(CameraManager);
  }
}
