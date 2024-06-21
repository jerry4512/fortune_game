
//方块类型
enum BlockType {
  block,
  magnification
}

//当前滚动状态
enum RollerState {
  stopped,
  starting,
  rolling,
  stopping,
  bouncing
}

//按钮类型
enum ButtonType {
  single,
  continuous
}

//线连接类型
enum LineConnectionType {
  // //第一列
  // horizontalTop,
  // //第二列
  // horizontalCenter,
  // //第三列
  // horizontalBottom,
  horizontal,
  //左上右下
  leftUpRightDown,
  //左下右上
  leftDownRightUp,
}

enum RollerType {
  firstRoller,
  secondRoller,
  thirdRoller,
  magnificationRoller
}

