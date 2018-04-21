import 'package:dartemis/dartemis.dart';

class TilePosition extends Component {
  int x, y, z;
  TilePosition(this.x, this.y) : z = -x - y;
}

class Tile extends Component {
  CellType type;
  Tile(this.type);
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

enum CellType {
  glacier,
  ocean,
  lake,
  grass,
  forest,
  desert,
  barren,
  farm,
  village,
  town,
  city,
  shore,
  jungle,
  swamp,
  endOfWorld,
}

enum OverlayCellType {
  fire,
  flood,
}
