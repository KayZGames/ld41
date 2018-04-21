import 'dart:typed_data';
import 'dart:web_gl';

import 'package:dartemis/dartemis.dart';
import 'package:gamedev_helpers/gamedev_helpers.dart';
import 'package:ld41/shared.dart';
import 'package:ld41/src/shared/managers.dart';

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
    CameraManager,
  ],
  mapper: [
    Camera,
  ],
)
class TerrainRenderingSystem extends _$TerrainRenderingSystem {
  List<Attrib> attributes = const [
    const Attrib('pos', 2),
    const Attrib('color', 3),
  ];
  static const double spacingNumber = 0.98;

  Uint16List indices;
  Float32List items;

  double cameraX, cameraY;

  Matrix4 twodOrthographicMatrix;

  TerrainRenderingSystem(gl) : super(gl);

  @override
  void begin() {
    final camera = tagManager.getEntity(cameraTag);
    final cameraPosition = positionMapper[camera];
    cameraX = cameraPosition.x;
    cameraY = cameraPosition.y;
    final width = cameraManager.width;
    final height = cameraManager.height;

    final zoom = cameraMapper[camera].zoom;
    final orthographicMatrix = new Matrix4.identity();
    setOrthographicMatrix(
        orthographicMatrix,
        cameraX - (width / 2) * zoom,
        cameraX + (width / 2) * zoom,
        cameraY - (height / 2) * zoom,
        cameraY + (height / 2) * zoom,
        1.0,
        -1.0);
    twodOrthographicMatrix = orthographicMatrix;
  }

  @override
  void processEntity(int index, Entity entity) {
    final position = positionMapper[entity];
    final color = colorMapper[entity];
    var hexagonIndex = index * 5 * 7;
    items[hexagonIndex] = position.x;
    items[hexagonIndex + 1] = position.y;
    items[hexagonIndex + 2] = color.r;
    items[hexagonIndex + 3] = color.g;
    items[hexagonIndex + 4] = color.b;

    for (int i = 0; i < 6; i++) {
      var edgeIndex = hexagonIndex + 5 + i * 5;
      items[edgeIndex] =
          position.x + spacingNumber * hexagonSize * cos(pi / 6 + i * pi / 3);
      items[edgeIndex + 1] =
          position.y + spacingNumber * hexagonSize * sin(pi / 6 + i * pi / 3);
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
    final location = gl.getUniformLocation(program, 'uViewProjectionMatrix');
    gl.uniformMatrix4fv(location, false, twodOrthographicMatrix.storage);
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
  VoidWebGlRenderingSystem,
  manager: [
    GameStateManager,
    TagManager,
    CameraManager,
  ],
  mapper: [
    Position,
    Camera,
  ],
)
class CursorRenderingSystem extends _$CursorRenderingSystem {
  List<Attrib> attributes = const [const Attrib('pos', 2)];

  Uint16List indices = new Uint16List(6 * 6);
  Float32List items = new Float32List(12 * 2);

  CursorRenderingSystem(RenderingContext2 gl) : super(gl);

  @override
  void render() {
    final cursorX = gameStateManager.cursorX;
    final cursorY = gameStateManager.cursorY;
    final camera = tagManager.getEntity(cameraTag);
    final cameraPosition = positionMapper[camera];
    final zoom = cameraMapper[camera].zoom;

    var cameraX = cameraPosition.x;
    var cameraY = cameraPosition.y;
    final cursorInCameraX = cameraX + cursorX * zoom;
    final cursorInCameraY = -cameraY + cursorY * zoom;

    final x =
        (cursorInCameraX * sqrt(3) / 3 - cursorInCameraY * 1 / 3) / hexagonSize;
    final y = (cursorInCameraY * 2 / 3) / hexagonSize;
    final z = -x - y;

    var rx = x.round();
    var ry = y.round();
    var rz = z.round();

    var xDiff = (rx - x).abs();
    var yDiff = (ry - y).abs();
    var zDiff = (rz - z).abs();

    if (xDiff > yDiff && xDiff > zDiff) {
      rx = -ry - rz;
    } else if (yDiff > zDiff) {
      ry = -rx - rz;
    } else {
      rz = -rx - ry;
    }

    final centerX = rx * hexagonWidth + ry * hexagonWidth / 2;
    final centerY = -ry * hexagonHeight * 3 / 4;

    for (int i = 0; i < 6; i++) {
      final index = i * 4;
      items[index] = (centerX + hexagonSize * cos(pi / 6 + i * pi / 3) * 0.95);
      items[index + 1] =
          (centerY + hexagonSize * sin(pi / 6 + i * pi / 3) * 0.95);
      items[index + 2] =
          (centerX + hexagonSize * cos(pi / 6 + i * pi / 3) * 1.02);
      items[index + 3] =
          (centerY + hexagonSize * sin(pi / 6 + i * pi / 3) * 1.02);
    }

    for (int i = 0; i < 6; i++) {
      final index = i * 6;
      indices[index] = 2 * i;
      indices[index + 1] = 2 * i + 1;
      indices[index + 2] = 2 * i + 2;

      indices[index + 3] = 2 * i + 1;
      indices[index + 4] = 2 * i + 2;
      indices[index + 5] = 2 * i + 3;
    }
    indices[6 * 6 - 1] = 1;
    indices[6 * 6 - 2] = 0;
    indices[6 * 6 - 4] = 0;

    final width = cameraManager.width;
    final height = cameraManager.height;

    final orthographicMatrix = new Matrix4.identity();
    setOrthographicMatrix(
        orthographicMatrix,
        cameraX - (width / 2) * zoom,
        cameraX + (width / 2) * zoom,
        cameraY - (height / 2) * zoom,
        cameraY + (height / 2) * zoom,
        1.0,
        -1.0);
    final location = gl.getUniformLocation(program, 'uViewProjectionMatrix');
    gl.uniformMatrix4fv(location, false, orthographicMatrix.storage);
    drawTriangles(attributes, items, indices);
  }

  @override
  String get fShaderFile => 'CursorRenderingSystem';
  @override
  String get vShaderFile => 'CursorRenderingSystem';
}
