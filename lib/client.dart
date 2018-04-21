library client;

import 'dart:html';
import 'package:ld41/shared.dart';
import 'package:gamedev_helpers/gamedev_helpers.dart';
import 'package:ld41/src/client/systems/hud_rendering.dart';
import 'package:ld41/src/shared/managers.dart';

import 'src/client/systems/events.dart';
import 'src/client/systems/rendering.dart';

class Game extends GameBase {
  CanvasElement hudCanvas;
  CanvasRenderingContext2D hudCtx;
  DivElement container;

  Game() : super('ld41', '#game', webgl: true, bodyDefsName: null) {
    container = querySelector('#gamecontainer');
    hudCanvas = querySelector('#hud');
    hudCtx = hudCanvas.context2D;
    _configureHud();
  }

  @override
  void createEntities() {
    var gameStateManager = new GameStateManager();
    world.addManager(gameStateManager);
    world.addManager(new WorldMapManager());
    world.addManager(new CursorManager());
    var tagManager = new TagManager();
    world.addManager(tagManager);

    final camera = addEntity([new Position(0.0, 0.0), new Camera()]);
    tagManager.register(camera, cameraTag);

    final radius = 20;
    var startX = 0;
    var endX = radius;
    final tilesForRandomDistribution = TerrainType.values
        .where((type) =>
            type != TerrainType.endOfWorld &&
            type != TerrainType.ocean &&
            type != TerrainType.glacier &&
            type != TerrainType.coast &&
            type != TerrainType.farm)
        .toList(growable: false);
    for (int y = -radius; y <= radius; y++) {
      for (int x = startX; x <= endX; x++) {
        Terrain tile;
        if (y.abs() == radius || x == startX || x == endX) {
          tile = new Terrain(TerrainType.endOfWorld);
        } else if (y.abs() == radius - 1) {
          tile = new Terrain(TerrainType.glacier);
        } else if (y.abs() >= radius - 3 || x < startX + 3 || x > endX - 3) {
          tile = new Terrain(TerrainType.ocean);
        } else if (y.abs() == radius - 4 || x == startX + 3 || x == endX - 3) {
          tile = new Terrain(TerrainType.coast);
        } else {
          tile = new Terrain(tilesForRandomDistribution[
              random.nextInt(tilesForRandomDistribution.length)]);
        }
        addEntity([
          new TilePosition(x, y),
          new Position(x * hexagonWidth + y * hexagonWidth / 2,
              -y * hexagonHeight * 3 / 4),
          new Color(1.0, 0.0, 0.0, 1.0),
          new ChangeTerrain(),
          tile,
        ]);
      }
      startX = max(startX - 1, -radius);
      if (y >= 0) {
        endX--;
      }
    }
  }

  @override
  Map<int, List<EntitySystem>> getSystems() {
    return {
      GameBase.rendering: [
        new HudInteractionSystem(hudCanvas),
        new ExecutePowerSystem(),
        new CameraControllerSystem(),
        new PrepareTerrainChangeSystem(),
        new TerrainChangeSystem(),
        new WebGlCanvasCleaningSystem(gl),
        new TerrainRenderingSystem(gl),
        new CursorRenderingSystem(gl),
        new CanvasCleaningSystem(hudCanvas),
        new SelectedPowerRenderingSystem(hudCtx, spriteSheet),
        new FpsRenderingSystem(hudCtx, fillStyle: 'white'),
        new TerrainStatsUpdatingSystem(),
        new FinishGameStartedSystem(),
        new FinishEndTurnSystem(),
      ],
      GameBase.physics: [
        // add at least one
      ]
    };
  }

  @override
  void handleResize(int width, int height) {
    width = max(800, width);
    height = max(450, height);
    if (width / height > 16 / 9) {
      width = (16 * height) ~/ 9;
    } else if (width / height < 16 / 9) {
      height = (9 * width) ~/ 16;
    }
    container.style
      ..width = '${width}px'
      ..height = '${height}px';
    resizeCanvas(hudCanvas, width, height);
    _configureHud();
    super.handleResize(width, height);
  }

  void _configureHud() {
    hudCtx
      ..textBaseline = 'top'
      ..font = '16px Verdana';
  }
}
