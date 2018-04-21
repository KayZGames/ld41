import 'package:gamedev_helpers/gamedev_helpers.dart';
import 'package:ld41/src/shared/components.dart';

part 'events.g.dart';

@Generate(GenericInputHandlingSystem, allOf: const [Controller])
class ControllerSystem extends _$ControllerSystem {

  @override
  void processEntity(Entity entity) {
    final c = controllerMapper[entity]..reset();
    if (up) {
      if (left) {
        c.upleft = true;
      } else if (right) {
        c.upright = true;
      } else {
        c.up = true;
      }
    } else if (down) {
      if (left) {
        c.downleft = true;
      } else if (right) {
        c.downright = true;
      } else {
        c.down = true;
      }
    } else if (left) {
      c.left = true;
    } else if (right) {
      c.right = true;
    }
  }
}
