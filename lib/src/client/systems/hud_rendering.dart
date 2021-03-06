import 'dart:html';

import 'package:dartemis/dartemis.dart';
import 'package:ld41/shared.dart';
import 'package:ld41/src/shared/managers.dart';

part 'hud_rendering.g.dart';

@Generate(
  EntityProcessingSystem,
  allOf: [
    Terrain,
  ],
  manager: [
    GameStateManager,
  ],
)
class TerrainStatsUpdatingSystem extends _$TerrainStatsUpdatingSystem {
  Map<TerrainType, int> terrainStats = new Map.fromIterable(TerrainType.values,
      key: (key) => key, value: (value) => 0);

  @override
  void initialize() {
    super.initialize();
    for (final terrainType in TerrainType.values) {
      final color = colorMap[terrainType];
      final colorString =
          '#${_toHex(color.x)}${_toHex(color.y)}${_toHex(color.z)}';
      querySelector('#${terrainType.toString().split('.')[1]} > .icon')
          .style
          .backgroundColor = colorString;
    }
  }

  String _toHex(double colorFragment) =>
      (colorFragment * 255).toInt().toRadixString(16).padLeft(2, '0');

  @override
  void processEntity(Entity entity) {
    final terrain = terrainMapper[entity];
    terrainStats[terrain.type]++;
  }

  @override
  void begin() {
    terrainStats = new Map.fromIterable(TerrainType.values,
        key: (key) => key, value: (value) => 0);
  }

  @override
  void end() {
    terrainStats.forEach((key, value) => document
        .querySelector('#${key.toString().split('.')[1]} > .count')
        ?.innerHtml = '$value');
  }

  @override
  bool checkProcessing() =>
      gameStateManager.state == State.endTurn ||
      gameStateManager.state == State.started;
}

@Generate(
  VoidEntitySystem,
  manager: [
    GameStateManager,
  ],
)
class GodlyPowersStatusSystem extends _$GodlyPowersStatusSystem {
  final Element currentTurn = querySelector('#currentTurn');
  final Element faithTitle = querySelector('#faithtitle');
  final Element faithpercent = querySelector('#faithpercent');

  @override
  void initialize() {
    super.initialize();
    for (final powerType in PowerType.values) {
      final powerCost = powerCostMap[powerType];
      querySelector('#${powerType.toString().split('.')[1]}Cost').innerHtml =
          '$powerCost';
    }
  }

  @override
  void processSystem() {
    currentTurn.innerHtml = '${gameStateManager.turn}';
    faithTitle.title = '${gameStateManager.faith}/${gameStateManager.maxFaith}';
    faithpercent.style.width =
        '${100 * gameStateManager.faith/gameStateManager.maxFaith}%';
    for (final powerType in PowerType.values) {
      final powerElement =
          querySelector('.power.${powerType.toString().split('.')[1]}');
      final powerCost = powerCostMap[powerType];
      var isDisabled = powerElement.classes.contains('disabled');
      if (powerCost > gameStateManager.faith && !isDisabled) {
        powerElement.classes.add('disabled');
      } else if (powerCost <= gameStateManager.faith && isDisabled) {
        powerElement.classes.remove('disabled');
      }
    }
  }
}
