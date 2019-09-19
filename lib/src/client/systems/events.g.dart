// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// SystemGenerator
// **************************************************************************

abstract class _$HudInteractionSystem extends VoidEntitySystem {
  Mapper<Terrain> terrainMapper;
  GameStateManager gameStateManager;
  WorldMapManager worldMapManager;
  CursorManager cursorManager;
  @override
  void initialize() {
    super.initialize();
    terrainMapper = Mapper<Terrain>(world);
    gameStateManager = world.getManager<GameStateManager>();
    worldMapManager = world.getManager<WorldMapManager>();
    cursorManager = world.getManager<CursorManager>();
  }
}

abstract class _$CameraControllerSystem extends GenericInputHandlingSystem {
  Mapper<Camera> cameraMapper;
  Mapper<Position> positionMapper;
  _$CameraControllerSystem() : super(Aspect.empty()..allOf([Camera, Position]));
  @override
  void initialize() {
    super.initialize();
    cameraMapper = Mapper<Camera>(world);
    positionMapper = Mapper<Position>(world);
  }
}
