import 'dart:html';
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
    TagManager,
    CameraManager,
    CursorManager,
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
    final camera = tagManager.getEntity(cameraTag);
    final zoom = cameraMapper[camera].zoom;
    final selectedTile = cursorManager.getCurrentHexagonFromCursorPosition();
    final cameraPosition = positionMapper[camera];
    final cameraX = cameraPosition.x;
    final cameraY = cameraPosition.y;

    final centerX =
        selectedTile.x * hexagonWidth + selectedTile.y * hexagonWidth / 2;
    final centerY = -selectedTile.y * hexagonHeight * 3 / 4;

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

@Generate(
  VoidEntitySystem,
  manager: [
    GameStateManager,
    CursorManager,
  ],
)
class SelectedPowerRenderingSystem extends _$SelectedPowerRenderingSystem {
  CanvasRenderingContext2D ctx;
  SpriteSheet sheet;
  SelectedPowerRenderingSystem(this.ctx, this.sheet);

  @override
  void processSystem() {
    final sprite =
        sheet.sprites[gameStateManager.selectedPower.toString().split('.')[1]];
    final image = sheet.image;
    final cursorX = cursorManager.cursorX;
    final cursorY = cursorManager.cursorY;
    ctx.drawImageToRect(
        image,
        new Rectangle(sprite.dst.left + cursorX, sprite.dst.top + cursorY,
            sprite.dst.width, sprite.dst.height),
        sourceRect: sprite.src);
  }

  @override
  bool checkProcessing() => gameStateManager.selectedPower != null;
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    LogMessage,
  ],
)
class LogMessageSystem extends _$LogMessageSystem {
  final DivElement logMessagesElement = document.querySelector('#logmessages');
  DivElement lastNode;
  @override
  void processEntity(Entity entity) {
    final log = logMessageMapper[entity];
    final newNode = new DivElement()
      ..innerHtml = '[Turn ${log.turn}] ${log.message}';
    logMessagesElement.insertBefore(newNode, lastNode);
    lastNode = newNode;
    entity.deleteFromWorld();
  }
}
