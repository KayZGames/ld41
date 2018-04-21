// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// Generator: SystemGenerator
// **************************************************************************

abstract class _$HudInteractionSystem extends VoidEntitySystem {
  Mapper<Terrain> terrainMapper;
  GameStateManager gameStateManager;
  WorldMapManager worldMapManager;
  CursorManager cursorManager;
  @override
  void initialize() {
    super.initialize();
    terrainMapper = new Mapper<Terrain>(Terrain, world);
    gameStateManager = world.getManager(GameStateManager);
    worldMapManager = world.getManager(WorldMapManager);
    cursorManager = world.getManager(CursorManager);
  }
}

abstract class _$CameraControllerSystem extends GenericInputHandlingSystem {
  Mapper<Camera> cameraMapper;
  Mapper<Position> positionMapper;
  _$CameraControllerSystem()
      : super(new Aspect.empty()..allOf([Camera, Position]));
  @override
  void initialize() {
    super.initialize();
    cameraMapper = new Mapper<Camera>(Camera, world);
    positionMapper = new Mapper<Position>(Position, world);
  }
}
