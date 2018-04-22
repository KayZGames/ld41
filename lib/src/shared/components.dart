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

class Temperature extends Component {
  double celsius;
  double nextCelcius;
  Temperature(this.celsius) : nextCelcius = celsius;

  double get fahrenheit => celsius * 9 / 5 + 32;
}

class Humidity extends Component {
  double percentage;
  double nextPercentage;
  Humidity(this.percentage) : nextPercentage = percentage;
}

class Fertility extends Component {
  double percentage;
  double nextPercentage;
  Fertility(this.percentage) : nextPercentage = percentage;
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

class Human extends Component {
  int food;
  Human(this.food);
}

class Fire extends Component {
  int turnsBurned;
  Fire(this.turnsBurned);
}

class Flood extends Component {}

class Settlement extends Component {}

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
  settlement
}

enum OverlayCellType {
  fire,
  flood,
}

enum PowerType { human, forest, fire, flood }


