import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fortune_game/system/fortune_game.dart';

class FortuneGameEntrance extends StatefulWidget {
  const FortuneGameEntrance({super.key});

  @override
  State<FortuneGameEntrance> createState() => _FortuneGameEntranceState();
}

class _FortuneGameEntranceState extends State<FortuneGameEntrance> {

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      //遊戲主體。
      game: FortuneGame(),
      //背景。
      // backgroundBuilder: (context) {
      //   return Container(
      //     color: Colors.black,
      //     // decoration: const BoxDecoration(
      //     //   image: DecorationImage(
      //     //     fit: BoxFit.cover,
      //     //     image: AssetImage('assets/images/background.png'),
      //     //   ),
      //     // ),
      //   );
      // },
    );
  }
}
