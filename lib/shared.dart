library shared;

import 'package:ld41/shared.dart';

export 'package:gamedev_helpers/gamedev_helpers_shared.dart';

export 'src/shared/components.dart';
export 'src/shared/systems/logic.dart';

const int worldRadius = 20;
const String cameraTag = 'camera';
const double hexagonSize = 50.0;
const double hexagonWidth = 1.732 * hexagonSize;
const double hexagonHeight = 2 * hexagonSize;

const Map<TerrainType, Range> temperatureRange = {
  TerrainType.glacier: const Range(-100.0, 10.0, -35.0),
  TerrainType.ocean: const Range(-5.0, 20.0, 10.0),
  TerrainType.coast: const Range(-5.0, 50.0, 15.0),
  TerrainType.grass: const Range(-5.0, 30.0, 25.0),
  TerrainType.forest: const Range(-5.0, 35.0, 16.0),
  TerrainType.jungle: const Range(25.0, 50.0, 30.0),
  TerrainType.barren: const Range(25.0, 35.0, 30.0),
  TerrainType.lake: const Range(-5.0, 30.0, 14.0),
  TerrainType.desert: const Range(35.0, 100.0, 50.0),
  TerrainType.swamp: const Range(10.0, 30.0, 20.0),
  TerrainType.farm: const Range(10.0, 35.0, 30.0),
  TerrainType.settlement: const Range(20.0, 50.0, 40.0),
};

const Map<TerrainType, Range> humidityRange = {
  TerrainType.glacier: const Range(0.0, 20.0, 10.0),
  TerrainType.ocean: const Range(20.0, 80.0, 40.0),
  TerrainType.coast: const Range(20.0, 50.0, 40.0),
  TerrainType.grass: const Range(15.0, 60.0, 35.0),
  TerrainType.forest: const Range(20.0, 70.0, 50.0),
  TerrainType.jungle: const Range(50.0, 100.0, 70.0),
  TerrainType.barren: const Range(10.0, 30.0, 25.0),
  TerrainType.lake: const Range(20.0, 80.0, 50.0),
  TerrainType.desert: const Range(0.0, 10.0, 0.0),
  TerrainType.swamp: const Range(40.0, 100.0, 60.0),
  TerrainType.farm: const Range(15.0, 45.0, 30.0),
  TerrainType.settlement: const Range(10.0, 30.0, 20.0),
};

const Map<TerrainType, Range> fertilityRange = {
  TerrainType.glacier: const Range(0.0, 20.0, 0.0),
  TerrainType.ocean: const Range(20.0, 80.0, 30.0),
  TerrainType.coast: const Range(0.0, 20.0, 10.0),
  TerrainType.grass: const Range(15.0, 50.0, 25.0),
  TerrainType.forest: const Range(20.0, 60.0, 40.0),
  TerrainType.jungle: const Range(40.0, 100.0, 70.0),
  TerrainType.barren: const Range(0.0, 20.0, 10.0),
  TerrainType.lake: const Range(20.0, 80.0, 40.0),
  TerrainType.desert: const Range(0.0, 10.0, 0.0),
  TerrainType.swamp: const Range(15.0, 50.0, 30.0),
  TerrainType.farm: const Range(15.0, 50.0, 30.0),
  TerrainType.settlement: const Range(5.0, 20.0, 10.0),
};

final Map<TerrainType, Vector3> colorMap = {
  TerrainType.glacier: new Vector3(189 / 255, 221 / 255, 252 / 255),
  TerrainType.ocean: new Vector3(41 / 255, 145 / 255, 212 / 255),
  TerrainType.coast: new Vector3(246 / 255, 237 / 255, 223 / 255),
  TerrainType.grass: new Vector3(171 / 255, 252 / 255, 150 / 255),
  TerrainType.forest: new Vector3(85 / 255, 166 / 255, 64 / 255),
  TerrainType.jungle: new Vector3(7 / 255, 114 / 255, 18 / 255),
  TerrainType.barren: new Vector3(125 / 255, 81 / 255, 44 / 255),
  TerrainType.lake: new Vector3(9 / 255, 107 / 255, 182 / 255),
  TerrainType.desert: new Vector3(255 / 255, 223 / 255, 65 / 255),
  TerrainType.swamp: new Vector3(137 / 255, 120 / 255, 50 / 255),
  TerrainType.farm: new Vector3(229 / 255, 176 / 255, 96 / 255),
  TerrainType.settlement: new Vector3(200 / 255, 200 / 255, 200 / 255),
};

final Map<TerrainType, List<TerrainType>> terrainConversion = {
  TerrainType.grass: [
    TerrainType.forest,
    TerrainType.swamp,
    TerrainType.barren
  ],
  TerrainType.forest: [
    TerrainType.grass,
    TerrainType.jungle,
    TerrainType.swamp
  ],
  TerrainType.swamp: [
    TerrainType.grass,
    TerrainType.jungle,
    TerrainType.forest,
    TerrainType.barren
  ],
  TerrainType.barren: [
    TerrainType.grass,
    TerrainType.desert,
  ],
  TerrainType.jungle: [TerrainType.swamp, TerrainType.forest],
  TerrainType.desert: [TerrainType.barren, TerrainType.grass, TerrainType.swamp],
  TerrainType.lake: [TerrainType.swamp, TerrainType.barren],
  TerrainType.farm: [],
  TerrainType.coast: [],
  TerrainType.ocean: [TerrainType.glacier],
  TerrainType.glacier: [TerrainType.ocean],
  TerrainType.settlement: [],
};

Map<TerrainType, FireResistance> fireResistances = {
  TerrainType.glacier: const FireResistance(7, 0),
  TerrainType.ocean: const FireResistance(7, 0),
  TerrainType.coast: const FireResistance(4, 1),
  TerrainType.grass: const FireResistance(7, 0),
  TerrainType.forest: const FireResistance(1, 2),
  TerrainType.jungle: const FireResistance(3, 3),
  TerrainType.barren: const FireResistance(7, 0),
  TerrainType.lake: const FireResistance(7, 0),
  TerrainType.desert: const FireResistance(7, 0),
  TerrainType.swamp: const FireResistance(2, 3),
  TerrainType.farm: const FireResistance(1, 2),
  TerrainType.settlement: const FireResistance(3, 5),
};

final Map<PowerType, int> powerCostMap = {
  PowerType.human: 1001,
  PowerType.forest: 50,
  PowerType.fire: 100,
  PowerType.flood: 200,
};

class Range {
  final double min, max, start;
  const Range(this.min, this.max, this.start);
  bool isInRange(double value) => value >= min && value <= max;
}

class FireResistance {
  final int fireNeeded;
  final int turnsToBurn;
  const FireResistance(this.fireNeeded, this.turnsToBurn);
}
