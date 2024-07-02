import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:fortune_game/symbol/enum.dart';


class SlotMachineRollerBlock extends SpriteComponent {
  String image;
  BlockType blockType;
  int rollerIndex;

  SlotMachineRollerBlock({
    required this.image,
    required this.blockType,
    required this.rollerIndex,
    super.anchor,
    super.position,
    super.size,
  });

  MoveEffect? moveEffect;

  late RectangleComponent rectangleComponent;

  @override
  void onLoad() async {
    //Set sprite on load.
    sprite = await Sprite.load(image);

    //特殊方块需要比较大尺寸
    scale = Vector2(0.75,0.75);
    priority = 1;
    if(image == 'blocks/symbol_wild.png'){
      size = Vector2(140,110);
      if(rollerIndex >= 2){
        priority = 2;
        scale = Vector2(1.2,1.2);
      }
    }
    if(blockType == BlockType.magnification){
      scale = Vector2(1,1);
      size = Vector2(125,93);
    }

    Vector2 rectangleComponentSize = size;
    Vector2 rectangleComponentScale =  Vector2(1,1);

    if(image == 'blocks/symbol_wild.png'){
      rectangleComponentSize = Vector2(140,110);
      if(rollerIndex >= 2){
        rectangleComponentScale = Vector2(1,1);
      }
    }

    if(blockType == BlockType.magnification){
      rectangleComponentSize = Vector2(125,93);
      rectangleComponentScale = Vector2(1,1);
    }

    rectangleComponent = RectangleComponent(size: rectangleComponentSize,scale: rectangleComponentScale, paint: Paint()..color = Colors.black.withOpacity(0.5));

    super.onLoad();
  }

  Future<void> addMask() async {
    await add(rectangleComponent);
  }

  void removeMask(){
      if(rectangleComponent.isMounted){
        remove(rectangleComponent);
      }
  }

}
