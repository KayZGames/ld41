import 'dart:typed_data';
import 'dart:web_gl';

import 'package:dartemis/dartemis.dart';
import 'package:gamedev_helpers/gamedev_helpers.dart';
import 'package:ld41/shared.dart';

part 'rendering.g.dart';

@Generate(
  WebGlRenderingSystem,
  allOf: [
    TilePosition,
    Position,
    Color,
  ],
  manager: [
    TagManager,
  ],
)
class TerrainRenderingSystem extends _$TerrainRenderingSystem {
  List<Attrib> attributes = const [
    const Attrib('pos', 2),
    const Attrib('color', 3),
  ];

  Uint16List indices;
  Float32List items;

  double scale = 0.2;
  double cameraX, cameraY;

  TerrainRenderingSystem(gl) : super(gl);


  @override
  void begin() {
    final camera = tagManager.getEntity(cameraTag);
    final cameraPosition = positionMapper[camera];
    cameraX = cameraPosition.x;
    cameraY = cameraPosition.y;
  }

  @override
  void processEntity(int index, Entity entity) {
    final position = positionMapper[entity];
    final color = colorMapper[entity];
    var hexagonIndex = index * 5 * 7;
    items[hexagonIndex] = position.x * scale - cameraX;
    items[hexagonIndex + 1] = position.y * scale - cameraY;
    items[hexagonIndex + 2] = color.r;
    items[hexagonIndex + 3] = color.g;
    items[hexagonIndex + 4] = color.b;

    for (int i = 0; i < 6; i++) {
      var edgeIndex = hexagonIndex + 5 + i * 5;
      items[edgeIndex] =
          (position.x + sin(pi / 5) * cos(pi / 6 + i * pi / 3)) * scale - cameraX;
      items[edgeIndex + 1] =
          (position.y + sin(pi / 5) * sin(pi / 6 + i * pi / 3)) * scale - cameraY;
      items[edgeIndex + 2] = color.r;
      items[edgeIndex + 3] = color.g;
      items[edgeIndex + 4] = color.b;
    }
    final triangleIndiceIndex = index * 3 * 6;
    final triangleIndex = index * 7;
    for (int i = 0; i < 6; i++) {
      indices[triangleIndiceIndex + i * 3] = triangleIndex;
      indices[triangleIndiceIndex + i * 3 + 1] = triangleIndex + i + 1;
      indices[triangleIndiceIndex + i * 3 + 2] = triangleIndex + i + 2;
    }
    indices[triangleIndiceIndex + 3 * 6 - 1] = triangleIndex + 1;
  }

  @override
  void render(int length) {
    drawTriangles(attributes, items, indices);
  }

  @override
  void updateLength(int length) {
    indices = new Uint16List(length * 3 * 7);
    items = new Float32List(length * 5 * 7);
  }

  @override
  String get fShaderFile => 'TerrainRenderingSystem';
  @override
  String get vShaderFile => 'TerrainRenderingSystem';
}

@Generate(
  WebGlRenderingSystem,
  allOf: [
    TilePosition,
    Position,
    Color,
  ],
)
class TerrainRenderingSystem2 extends _$TerrainRenderingSystem2 {
  List<Attrib> attributes = const [
    const Attrib('pos', 2),
    const Attrib('color', 3),
  ];

  Uint16List indices;
  Float32List items;

  TerrainRenderingSystem2(gl) : super(gl);

  @override
  void processEntities(Iterable<Entity> entities) {
    final length = entities.length;
    if (length > 0) {
      gl.useProgram(program);
      if (length > maxLength) {
        updateLength(length);
        maxLength = length;
      }
      // length = 3 * (radius * radius + radius) + 1
      final maxRadius = sqrt(length / 3).floor();
      final offset = length ~/ 2;
      for (final entity in entities) {
        final tilePosition = tilePositionMapper[entity];
        final position = positionMapper[entity];
        final color = colorMapper[entity];
        var hexagonIndex = offset;
        if (tilePosition.y > 0) {
          hexagonIndex = length - 1;
          var row = maxRadius;
          var rowCounter = 2;
          while (row > tilePosition.y) {
            hexagonIndex -= maxRadius + rowCounter;
            row--;
            rowCounter++;
          }
        } else if (tilePosition.y < 0) {
          hexagonIndex = 0;
          var row = -maxRadius;
          var rowCounter = 2;
          while (row < tilePosition.y) {
            hexagonIndex += maxRadius + rowCounter;
            row++;
            rowCounter++;
          }
        }
        hexagonIndex += tilePosition.x;
        hexagonIndex *= 5;
        items[hexagonIndex] = position.x * 0.2;
        items[hexagonIndex + 1] = position.y * 0.2;
        items[hexagonIndex + 2] = color.r;
        items[hexagonIndex + 3] = color.g;
        items[hexagonIndex + 4] = color.b;
      }
      var indexOffset = 0;
      var triangleOffset = 0;
      for (int row = 0; row < maxRadius; row++) {
        final itemsInRow = maxRadius + row + 1;
        for (int column = 0; column < itemsInRow; column++) {
          final index = (indexOffset + column) * 3;
          indices[index] = triangleOffset + column;
          indices[index + 1] = triangleOffset + column + itemsInRow + 1;
          indices[index + 2] = triangleOffset + column + itemsInRow;
        }
        indexOffset += itemsInRow;
        triangleOffset += itemsInRow;
      }
      triangleOffset = 0;
      for (int row = 0; row < maxRadius; row++) {
        final itemsInRow = maxRadius + row + 1;
        for (int column = 0; column < itemsInRow - 1; column++) {
          final index = (indexOffset + column) * 3;
          indices[index] = triangleOffset + column;
          indices[index + 1] = triangleOffset + column + 1;
          indices[index + 2] = triangleOffset + column + itemsInRow + 1;
        }
        indexOffset += itemsInRow - 1;
        triangleOffset += itemsInRow;
      }
      triangleOffset = length - 1;
      for (int row = 0; row > -maxRadius; row--) {
        final itemsInRow = maxRadius + row.abs() + 1;
        for (int column = 0; column < itemsInRow; column++) {
          final index = (indexOffset + column) * 3;
          indices[index] = triangleOffset - column;
          indices[index + 1] = triangleOffset - column - itemsInRow - 1;
          indices[index + 2] = triangleOffset - column - itemsInRow;
        }
        indexOffset += itemsInRow;
        triangleOffset -= itemsInRow;
      }
      triangleOffset = length - 1;
      for (int row = 0; row > -maxRadius; row--) {
        final itemsInRow = maxRadius + row.abs() + 1;
        for (int column = 0; column < itemsInRow - 1; column++) {
          final index = (indexOffset + column) * 3;
          indices[index] = triangleOffset - column;
          indices[index + 1] = triangleOffset - column - 1;
          indices[index + 2] = triangleOffset - column - itemsInRow - 1;
        }
        indexOffset += itemsInRow - 1;
        triangleOffset -= itemsInRow;
      }
      render(length);
    }
  }

  @override
  void processEntity(int index, Entity entity) => null;

  @override
  void render(int length) {
    drawTriangles(attributes, items, indices);
  }

  @override
  void updateLength(int length) {
    items = new Float32List(length * 5);
    final maxRadius = sqrt(length / 3).floor();
    indices = new Uint16List(3 * (maxRadius * maxRadius * 6));
  }

  @override
  String get fShaderFile => 'TerrainRenderingSystem2';
  @override
  String get vShaderFile => 'TerrainRenderingSystem2';
}
