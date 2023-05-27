import 'package:ootdforyou/model/cloth.dart';

class WeatherConditionNode {
  Function conditionFunction;
  dynamic trueNode;
  dynamic falseNode;

  WeatherConditionNode(this.conditionFunction, this.trueNode, this.falseNode);

  decide() {
    if (conditionFunction()) {
      if (trueNode is WeatherConditionNode) {
        return trueNode.decide();
      } else {
        return trueNode;
      }
    } else {
      if (falseNode is WeatherConditionNode) {
        return falseNode.decide();
      } else {
        return falseNode;
      }
    }
  }
}

class ClothConditionNode {
  Function(Cloth) conditionFunction;
  dynamic trueNode;
  dynamic falseNode;

  ClothConditionNode(this.conditionFunction, this.trueNode, this.falseNode);

  decide(Cloth cloth) {
    if (conditionFunction(cloth)) {
      if (trueNode is ClothConditionNode) {
        return trueNode.decide(cloth);
      } else {
        return trueNode(cloth);
      }
    } else {
      if (falseNode is ClothConditionNode) {
        return falseNode.decide(cloth);
      } else {
        return falseNode(cloth);
      }
    }
  }
}