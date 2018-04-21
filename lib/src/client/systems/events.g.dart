// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// Generator: SystemGenerator
// **************************************************************************

abstract class _$HudInteractionSystem extends VoidEntitySystem {
  GameStateManager gameStateManager;
  @override
  void initialize() {
    super.initialize();
    gameStateManager = world.getManager(GameStateManager);
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
