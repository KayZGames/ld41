library client;

import 'dart:html';
import 'package:ld41/shared.dart';
import 'package:gamedev_helpers/gamedev_helpers.dart';
import 'package:ld41/src/client/systems/hud_rendering.dart';
import 'package:ld41/src/shared/managers.dart';
import 'package:ld41/src/shared/systems/cellular_automaton_logic.dart';

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
    world.addManager(new ViewProjectionManager());
    world.addManager(new TerrainChangeManager());
    var tagManager = new TagManager();
    world.addManager(tagManager);

    final camera = addEntity([new Position(0.0, 0.0), new Camera()]);
    tagManager.register(camera, cameraTag);

    final radius = 20;
    var startX = 0;
    var endX = radius;
    final tilesForRandomDistribution = TerrainType.values
        .where((type) =>
            type != TerrainType.ocean &&
            type != TerrainType.glacier &&
            type != TerrainType.coast &&
            type != TerrainType.farm)
        .toList(growable: false);
    for (int y = -radius; y <= radius; y++) {
      for (int x = startX; x <= endX; x++) {
        Terrain tile;
        if (y.abs() == radius) {
          tile = new Terrain(TerrainType.glacier);
        } else if (y.abs() >= radius - 2 || x < startX + 2 || x > endX - 2) {
          tile = new Terrain(TerrainType.ocean);
        } else if (y.abs() == radius - 3 || x == startX + 2 || x == endX - 2) {
          tile = new Terrain(TerrainType.coast);
        } else {
          tile = new Terrain(tilesForRandomDistribution[
              random.nextInt(tilesForRandomDistribution.length)]);
        }
        final color = colorMap[tile.type];
        var components = [
          new TilePosition(x, y),
          new Position(x * hexagonWidth + y * hexagonWidth / 2,
              -y * hexagonHeight * 3 / 4),
          new Color(color.x, color.y, color.z, 1.0),
          new ChangeTerrain(),
          tile,
          new Temperature(temperatureRange[tile.type].start),
          new Humidity(humidityRange[tile.type].start),
          new Fertility(fertilityRange[tile.type].start),
        ];
        addEntity(components);
      }
      startX = max(startX - 1, -radius);
      if (y >= 0) {
        endX--;
      }
    }

    addEntity([
      new LogMessage(
          0,
          'You created a world by randomly throwing pieces of mud together. But it feels empty. Find a nice piece of grassland and let some humans settle there.',
          Severity.info)
    ]);
  }

  @override
  Map<int, List<EntitySystem>> getSystems() {
    return {
      GameBase.rendering: [
        new HudInteractionSystem(hudCanvas),
        new ExecutePowerSystem(),
        new CameraControllerSystem(),
        new PrepareTerrainChangeSystem(),
        new PrepareTemperatureChangeSystem(),
        new PrepareFertilityChangeSystem(),
        new PrepareHumidityChangeSystem(),
        new FireSystem(),
        new TerrainChangeSystem(),
        new TemperatureChangeSystem(),
        new FertilityChangeSystem(),
        new HumidityChangeSystem(),
        // rendering
        new WebGlCanvasCleaningSystem(gl),
        new TerrainRenderingSystem(gl),
        new TemperatureRenderingSystem(gl),
        new HumidityRenderingSystem(gl),
        new FertilityRenderingSystem(gl),
        new SpriteRenderingSystem(gl, spriteSheet),
        new CursorRenderingSystem(gl),
        new CanvasCleaningSystem(hudCanvas),
        new SelectedPowerRenderingSystem(hudCtx, spriteSheet),
        new FpsRenderingSystem(hudCtx, fillStyle: 'white'),
        new TerrainStatsUpdatingSystem(),
        new FinishGameStartedSystem(),
        new FinishEndTurnSystem(),
        new LogMessageSystem(),
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
