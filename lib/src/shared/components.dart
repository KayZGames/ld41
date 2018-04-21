import 'package:dartemis/dartemis.dart';
import 'package:gamedev_helpers/gamedev_helpers_shared.dart';

class TilePosition extends Component {
  int x, y, z;
  TilePosition(this.x, this.y) : z = -x - y;
}

class Terrain extends Component {
  TerrainType type;
  TerrainType nextType;
  Terrain(this.type) : nextType = type;
}

class Temerature extends Component {
  double celcius;
  Temerature(this.celcius);

  double get fahrenheit => celcius;
}

class Humidity extends Component {
  double percentage;
  Humidity(this.percentage);
}

class Fertility extends Component {
  double percentage;
  Fertility(this.percentage);
}

class ChangeTerrain extends Component {}
class Camera extends Component {}

enum TerrainType {
  glacier,
  ocean,
  lake,
  grass,
  forest,
  desert,
  barren,
  farm,
  coast,
  jungle,
  swamp,
  endOfWorld,
}

enum OverlayCellType {
  fire,
  flood,
}
