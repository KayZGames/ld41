// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rendering.dart';

// **************************************************************************
// Generator: SystemGenerator
// **************************************************************************

abstract class _$TerrainRenderingSystem extends WebGlRenderingSystem {
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Position> positionMapper;
  Mapper<Color> colorMapper;
  _$TerrainRenderingSystem(RenderingContext2 gl)
      : super(gl, new Aspect.empty()..allOf([TilePosition, Position, Color]));
  @override
  void initialize() {
    super.initialize();
    tilePositionMapper = new Mapper<TilePosition>(TilePosition, world);
    positionMapper = new Mapper<Position>(Position, world);
    colorMapper = new Mapper<Color>(Color, world);
  }
}

abstract class _$TerrainRenderingSystem2 extends WebGlRenderingSystem {
  Mapper<TilePosition> tilePositionMapper;
  Mapper<Position> positionMapper;
  Mapper<Color> colorMapper;
  _$TerrainRenderingSystem2(RenderingContext2 gl)
      : super(gl, new Aspect.empty()..allOf([TilePosition, Position, Color]));
  @override
  void initialize() {
    super.initialize();
    tilePositionMapper = new Mapper<TilePosition>(TilePosition, world);
    positionMapper = new Mapper<Position>(Position, world);
    colorMapper = new Mapper<Color>(Color, world);
  }
}
