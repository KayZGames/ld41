// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logic.dart';

// **************************************************************************
// Generator: SystemGenerator
// **************************************************************************

abstract class _$ControllerToActionSystem extends EntityProcessingSystem {
  Mapper<Controller> controllerMapper;
  Mapper<Acceleration> accelerationMapper;
  _$ControllerToActionSystem()
      : super(new Aspect.empty()..allOf([Controller, Acceleration]));
  @override
  void initialize() {
    super.initialize();
    controllerMapper = new Mapper<Controller>(Controller, world);
    accelerationMapper = new Mapper<Acceleration>(Acceleration, world);
  }
}
