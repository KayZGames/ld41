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

class Camera extends Component {
  double _zoom;
  Camera([this._zoom = 1.0]);
  set zoom(double value) {
    if (value >= 0.1 && value <= 3.0) {
      _zoom = value;
    }
  }

  double get zoom => _zoom;
}

class ExecutePower extends Component {
  PowerType power;
  ExecutePower(this.power);
}

class Human extends Component {}

class Fire extends Component {
  int turnsBurned;
  Fire(this.turnsBurned);
}

class Flood extends Component {}

class LogMessage extends Component {
  int turn;
  String message;
  Severity severity;
  LogMessage(this.turn, this.message, this.severity);
}

enum Severity {
  info,
  warning,
  danger,
}

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

enum PowerType { human, forest, fire, flood }
