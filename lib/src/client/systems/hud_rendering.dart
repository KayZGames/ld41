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
