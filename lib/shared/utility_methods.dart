import 'package:analyzer/dart/ast/ast.dart';

class UtilityMethods {

  ///
  /// adds a [fix] to the provided [arguments] of an instance creation
  ///
  static String addRemainingParameter(String fix, NodeList<Expression> arguments) {
    String s = '';
    for (Expression e in arguments) {
      s += '${e.toSource()}, ';
    }
    return '($s$fix,)';
  }

  ///
  /// checks if the [arguments] of an instace creation contain a certain [parameter]
  ///
  static bool hasParameter(String parameter, NodeList<Expression> arguments) {
    for (var argument in arguments) {
      if (argument.toString().contains('semanticsLabel')) {
        return true;
      }
    }
    return false;
  }

}