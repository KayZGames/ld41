import 'package:dartemis/dartemis.dart';
import 'package:gamedev_helpers/gamedev_helpers_shared.dart';
import 'package:ld41/shared.dart';
import 'package:ld41/src/shared/components.dart';
import 'package:ld41/src/shared/managers.dart';

part 'logic.g.dart';

@Generate(
  EntityProcessingSystem,
  allOf: [
    Fire,
    Terrain,
  ],
  manager: [
    TerrainChangeManager,
    GameStateManager,
  ],
)
class FireSystem extends _$FireSystem {
  @override
  void processEntity(Entity entity) {
    final fire = fireMapper[entity];
    fire.turnsBurned++;
    if (fire.turnsBurned > 1) {
      final terrain = terrainMapper[entity];
      terrainChangeManager.burnDown(entity, terrain);
    }
  }

  @override
  void end() {
    world.processEntityChanges();
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.endTurn;
}

@Generate(
  VoidEntitySystem,
  manager: [
    GameStateManager,
  ],
)
class FinishEndTurnSystem extends _$FinishEndTurnSystem {
  @override
  void processSystem() {
    gameStateManager.state = State.playersTurn;
    gameStateManager.turn++;
    if (gameStateManager.isIdleTurn) {
      gameStateManager.idleTurns++;
    }
    gameStateManager.isIdleTurn = true;
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.endTurn;
}

@Generate(
  VoidEntitySystem,
  manager: [
    GameStateManager,
  ],
)
class FinishGameStartedSystem extends _$FinishGameStartedSystem {
  @override
  void processSystem() {
    gameStateManager.state = State.playersTurn;
  }

  @override
  bool checkProcessing() => gameStateManager.state == State.started;
}

@Generate(
  EntityProcessingSystem,
  allOf: [
    ExecutePower,
    Terrain,
  ],
  manager: [
    GameStateManager,
    TerrainChangeManager,
  ],
  mapper: [
    Temperature,
    Fertility,
    Humidity,
  ],
)
class ExecutePowerSystem extends _$ExecutePowerSystem {
  @override
  void processEntity(Entity entity) {
    final power = executePowerMapper[entity].power;
    var powerCost = powerCostMap[power];
    if (gameStateManager.faith >= powerCost) {
      gameStateManager.isIdleTurn = false;
      gameStateManager.faith -= powerCost;
      entity
        ..removeComponent(ExecutePower)
        ..changedInWorld();
      if (power == PowerType.human) {
        terrainChangeManager.addHuman(entity);
        world.createAndAddEntity([
          new LogMessage(
              gameStateManager.turn, 'Humans have appeared!!!', Severity.info)
        ]);
      } else if (power == PowerType.forest) {
        var terrain = terrainMapper[entity];
        if (terrain.type == TerrainType.grass ||
            terrain.type == TerrainType.barren ||
            terrain.type == TerrainType.farm) {
          terrainChangeManager.changeTerrain(
              entity, terrain, TerrainType.forest);
          world.createAndAddEntity([
            new LogMessage(
                gameStateManager.turn, 'A new forest has grown.', Severity.info)
          ]);
        } else if (terrain.type == TerrainType.swamp) {
          terrainChangeManager.changeTerrain(
              entity, terrain, TerrainType.jungle);
          world.createAndAddEntity([
            new LogMessage(
                gameStateManager.turn, 'A new jungle has grown.', Severity.info)
          ]);
        } else {
          var fertility = fertilityMapper[entity];
          fertility.percentage = min(100.0, fertility.percentage + 1.0);
          world.createAndAddEntity([
            new LogMessage(
                gameStateManager.turn,
                'This ${terrain.type.toString().split('.')[1]} can\'t really support a forest, but the fertility increases.',
                Severity.info)
          ]);
        }
      } else if (power == PowerType.fire) {
        terrainChangeManager.addFire(entity, startedByGod: true);
        world.createAndAddEntity([
          new LogMessage(
              gameStateManager.turn,
              'A fire has started!! Why is there no fire brigade?!',
              Severity.warning)
        ]);
      } else if (power == PowerType.flood) {
        terrainChangeManager.addFlood(entity);
        world.createAndAddEntity([
          new LogMessage(
              gameStateManager.turn,
              'A flood!! Get onto higher ground! Oh no, it\'s a flat earth!',
              Severity.warning)
        ]);
      }
    }
  }

  @override
  void end() {
    world.processEntityChanges();
  }
}
