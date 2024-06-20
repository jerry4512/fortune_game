import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:fortune_game/component/slot_machine/slot_machine.dart';
/// 遊戲本體，據說繼承 SingleGameInstance 會有一些效能好處??
/// https://docs.flame-engine.org/latest/flame/game.html
class FortuneGame extends FlameGame  {

  SlotMachine? slotMachine;

  FortuneGame() : super(camera: CameraComponent.withFixedResolution(width: 900, height: 1600)) {
    //這個可以允許遊戲在背景執行? 不確定是否在 web 上可行，需要試驗。
    pauseWhenBackgrounded = false;

    //這個可以讓畫面顯示 debug 訊息。
    // debugMode = true;
  }

  @override
  Future<void> onLoad() async {
    await initSpineFlutter();
    //上方背景
    world.add(SpriteComponent(
      sprite: await Sprite.load('background.png'),
      anchor: Anchor.bottomCenter,
    ));

    //遊戲標題
    world.add(SpriteComponent(
      sprite: await Sprite.load('logo.png'),
      anchor: Anchor.bottomCenter,
      position: Vector2(0, -700)
    ));

    //拉霸机主体
    slotMachine = SlotMachine();
    world.add(slotMachine!);

    super.onLoad();
  }


  @override
  void onTap() {

  }

  @override
  void onGameResize(Vector2 size) {
    // TODO: implement onGameResize
    // log('[onGameResize]: $size');
    super.onGameResize(size);
  }

  @override
  void onMount() {
    // TODO: implement onMount
    super.onMount();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    // log('[camera]: ${camera.viewport.size} | ${camera.viewport.virtualSize} | ${camera.viewport.position}');
    super.update(dt);
  }

  @override
  void onRemove() {
    // Optional based on your game needs.

    //這個會讓 hot reload 掛掉??
    // removeAll(children);

    processLifecycleEvents();
    Flame.images.clearCache();
    Flame.assets.clearCache();

    // Todo: Any other code that you want to run when the game is removed.
    super.onRemove();
  }



}
