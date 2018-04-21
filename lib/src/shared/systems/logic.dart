import 'package:dartemis/dartemis.dart';
import 'package:gamedev_helpers/gamedev_helpers_shared.dart';
import 'package:ld41/src/shared/components.dart';

part 'logic.g.dart';

@Generate(EntityProcessingSystem, allOf: [Terrain, Color])
class TerrainColoringSystem extends _$TileColoringSystem {
  @override
  void processEntity(Entity entity) {
    final terrain = terrainMapper[entity];
    final color = colorMapper[entity];
    switch (terrain.type) {
      case TerrainType.glacier:
        color.r = 1.0;
        color.g = 1.0;
        color.b = 1.0;
        break;
      case TerrainType.endOfWorld:
        color.r = 0.0;
        color.g = 0.0;
        color.b = 0.0;
        break;
      case TerrainType.ocean:
        color.r = 0.0;
        color.g = 0.0;
        color.b = 1.0;
        break;
      case TerrainType.grass:
        color.r = 0.0;
        color.g = 1.0;
        color.b = 0.0;
        break;
      case TerrainType.shore:
        color.r = 1.0;
        color.g = 1.0;
        color.b = 0.0;
        break;
      case TerrainType.swamp:
        color.r = 0.0;
        color.g = 0.2;
        color.b = 0.0;
        break;
      case TerrainType.forest:
        color.r = 0.0;
        color.g = 0.8;
        color.b = 0.0;
        break;
      case TerrainType.jungle:
        color.r = 0.0;
        color.g = 0.5;
        color.b = 0.0;
        break;
      case TerrainType.barren:
        color.r = 0.5;
        color.g = 0.5;
        color.b = 0.2;
        break;
      case TerrainType.desert:
        color.r = 1.0;
        color.g = 1.0;
        color.b = 0.0;
        break;
      case TerrainType.lake:
        color.r = 0.0;
        color.g = 0.5;
        color.b = 1.0;
        break;
      case TerrainType.farm:
        color.r = 1.0;
        color.g = 1.0;
        color.b = 0.0;
        break;
      default:
        throw new ArgumentError.value(
            terrain.type, 'tile.type', 'no color defined for type ${terrain.type}');
    }
  }
}
