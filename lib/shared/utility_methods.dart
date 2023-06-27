import 'package:accessibility_lints/shared/constants.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

///
/// adds a [newParameter] to the provided [arguments] of an instance creation
///
String addRemainingParameter(
    {required String newParameter, required NodeList<Expression> arguments}) {
  String s = '';
  for (Expression e in arguments) {
    s += '${e.toSource()}, ';
  }
  return '($s$newParameter,)';
}

///
/// checks if the [arguments] of an instance creation contain a certain [parameter]
///
bool hasParameter(
    {required String parameter, required NodeList<Expression> arguments}) {
  for (var argument in arguments) {
    if (argument.toString().contains(parameter)) {
      return true;
    }
  }
  return false;
}

///
/// displays a [correctionMessage] using the [changeReporter] in order to append the missing [parameter] to the [selectedNode]
///
void applyParameter(
    {required String correctionMessage,
    required String parameter,
    required InstanceCreationExpression selectedNode,
    required ChangeReporter changeReporter}) {
// instantiate a ChangeBuilder
  final changeBuilder = changeReporter.createChangeBuilder(
    message: correctionMessage,
    priority: 1,
  );
// apply the fix to the incorrect line
  changeBuilder.addDartFileEdit((builder) {
    builder.addSimpleReplacement(
        SourceRange(
            selectedNode.argumentList.offset, selectedNode.argumentList.length),
        parameter);
  });
}

///
/// wraps the passed [widget] inside a semantics widget
///
String wrapInSemanticsWidget({required InstanceCreationExpression widget}) {
  return 'Semantics.fromProperties(properties: $defaultSemanticsProperties, child: $widget,)';
}

///
/// displays a [correctionMessage] using the [changeReporter] in order to replace the current widget in the [selectedNode] with a [semanticsWidget]
///
void insertSemanticsWidget(
    {required String correctionMessage,
    required String semanticsWidget,
    required InstanceCreationExpression selectedNode,
    required ChangeReporter changeReporter}) {
  final changeBuilder = changeReporter.createChangeBuilder(
      message: correctionMessage, priority: 1);

  changeBuilder.addDartFileEdit((builder) {
    builder.addSimpleReplacement(selectedNode.sourceRange, semanticsWidget);
  });
}

bool needsFix(InstanceCreationExpression node, String parameter) {
  for (var v in node.argumentList.arguments) {
    if (v.toString().contains(RegExp(parameter))) {
      return false; // return false, if the desired parameter is contained in the widget
    }
  }
  return _hasSemanticParent(node
      .parent); // || hasParameter(parameter: parameter, arguments: node.argumentList.arguments);
}

bool avoidDuplicateSemanticsFix(
    InstanceCreationExpression node, String parameter) {
  return _hasSemanticParent(node
      .parent); // && hasParameter(parameter: parameter, arguments: node.argumentList.arguments);
}

///
/// determines whether a Semantic widget has been inserted as the Parent of [ast]
///
bool _hasSemanticParent(AstNode? ast) {
  if (ast == null) {
    return false;
  }
  if (ast.toString().contains(RegExp(r'SemanticsProperties'))) {
    return true;
  } else {
    return false;
  }
}

///
/// checks if a [node] contains a semantic label
///
bool containsSemanticLabel(InstanceCreationExpression node) {
  if (hasParameter(
      parameter: semanticsLabelFlag, arguments: node.argumentList.arguments)) {
    return true;
  } else if (hasParameter(
      parameter: semanticsLabelFlag, arguments: node.argumentList.arguments)) {
    return true;
  }
  return false;
}

///
/// checks if the [constructorName] contains the semanticLabel property
///
bool requiresSemanticLabel(String? constructorName) {
  if (constructorName == null) {
    return false; // to avoid unnecessary null check in the rule's if clause
  }
  for (String label in requireSemanticLabel) {
    if (constructorName == label) return true;
  }
  return false;
}

///
/// checks if the [constructorName] contains the semanticsLabel property
///
bool requiresSemanticsLabel(String? constructorName) {
  if (constructorName == null) {
    return false; // to avoid unnecessary null check in the rule's if clause
  }
  for (String label in requireSemanticsLabel) {
    if (constructorName == label) return true;
  }
  return false;
}

///
/// checks wether the [parentNode] of a node is a Semantics widget
///
bool parentIsSemantic(AstNode? parentNode, InstanceCreationExpression node) {
  if (parentNode == null || parentNode.parent == null) return false;
  String parentContent = parentNode.parent.toString();
  if (!parentContent.contains('[')) {
    return parentNode.parent
        .toString()
        .contains(RegExp(r'SemanticsProperties'));
  }
  // structures like e.g. Columns need to be parsed differently
  else {
    parentContent = parentContent.split(node.toString())[0];
    if (parentContent.contains('[')) {
      return false;
    } else {
      parentContent =
          parentContent.split(node.constructorName.staticElement!.name).last;
      return parentContent.contains(RegExp(r'SemanticsProperties'));
    }
  }
}
