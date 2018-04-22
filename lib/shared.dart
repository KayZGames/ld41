library shared;

import 'package:ld41/shared.dart';

export 'package:gamedev_helpers/gamedev_helpers_shared.dart';

export 'src/shared/components.dart';
export 'src/shared/systems/logic.dart';

const String cameraTag = 'camera';
const double hexagonSize = 50.0;
const double hexagonWidth = 1.732 * hexagonSize;
const double hexagonHeight = 2 * hexagonSize;

const Map<TerrainType, Range> temperatureRange = {
  TerrainType.glacier: const Range(-100.0, 5.0, -25.0),
  TerrainType.ocean: const Range(-5.0, 20.0, 10.0),
  TerrainType.coast: const Range(-5.0, 50.0, 15.0),
  TerrainType.grass: const Range(-5.0, 30.0, 25.0),
  TerrainType.forest: const Range(-5.0, 25.0, 16.0),
  TerrainType.jungle: const Range(25.0, 50.0, 30.0),
  TerrainType.barren: const Range(25.0, 35.0, 30.0),
  TerrainType.lake: const Range(-5.0, 30.0, 14.0),
  TerrainType.desert: const Range(35.0, 100.0, 50.0),
  TerrainType.swamp: const Range(10.0, 35.0, 25.0),
  TerrainType.farm: const Range(10.0, 30.0, 20.0),
};

const Map<TerrainType, Range> humidityRange = {
  TerrainType.glacier: const Range(0.0, 20.0, 10.0),
  TerrainType.ocean: const Range(20.0, 80.0, 50.0),
  TerrainType.coast: const Range(20.0, 50.0, 40.0),
  TerrainType.grass: const Range(15.0, 40.0, 35.0),
  TerrainType.forest: const Range(20.0, 60.0, 50.0),
  TerrainType.jungle: const Range(50.0, 100.0, 70.0),
  TerrainType.barren: const Range(10.0, 30.0, 25.0),
  TerrainType.lake: const Range(20.0, 80.0, 50.0),
  TerrainType.desert: const Range(0.0, 10.0, 0.0),
  TerrainType.swamp: const Range(30.0, 100.0, 60.0),
  TerrainType.farm: const Range(15.0, 45.0, 40.0),
};

const Map<TerrainType, Range> fertilityRange = {
  TerrainType.glacier: const Range(0.0, 20.0, 0.0),
  TerrainType.ocean: const Range(20.0, 80.0, 40.0),
  TerrainType.coast: const Range(0.0, 20.0, 10.0),
  TerrainType.grass: const Range(15.0, 50.0, 25.0),
  TerrainType.forest: const Range(25.0, 60.0, 40.0),
  TerrainType.jungle: const Range(50.0, 100.0, 70.0),
  TerrainType.barren: const Range(0.0, 20.0, 10.0),
  TerrainType.lake: const Range(20.0, 80.0, 40.0),
  TerrainType.desert: const Range(0.0, 10.0, 0.0),
  TerrainType.swamp: const Range(15.0, 50.0, 30.0),
  TerrainType.farm: const Range(15.0, 50.0, 30.0),
};

class Range {
  final double min, max, start;
  const Range(this.min, this.max, this.start);
}
