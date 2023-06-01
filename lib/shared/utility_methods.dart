import 'package:accessibility_lints/shared/constants.dart';
import 'package:accessibility_lints/shared/node_visitors/instance_creation_visitor.dart';
import 'package:accessibility_lints/shared/node_visitors/parent_node_visitor.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';


class UtilityMethods {
  ///
  /// adds a [newParameter] to the provided [arguments] of an instance creation
  ///
  static String addRemainingParameter(
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
  static bool hasParameter(
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
  static void applyParameter(
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
          SourceRange(selectedNode.argumentList.offset,
              selectedNode.argumentList.length),
          parameter);
    });
  }

  ///
  /// wraps the passed [widget] inside a semantics widget
  ///
  static String wrapInSemanticsWidget(
      {required InstanceCreationExpression widget}) {
    return 'Semantics.fromProperties(properties: $defaultSemanticsProperties, child: $widget,)';
  }

  ///
  /// displays a [correctionMessage] using the [changeReporter] in order to replace the current widget in the [selectedNode] with a [semanticsWidget]
  ///
  static void insertSemanticsWidget(
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

  ///
  /// determines whether the parent of a [node] is a Semantics widget
  ///
  static bool parentIsNotSemantic(InstanceCreationExpression node) {
    return _parentIsSemantic(node, ParentNodeVisitor());
  }

  static bool _parentIsSemantic(
      InstanceCreationExpression node, ParentNodeVisitor visitor) {
    node.accept(visitor);
    AstNode? parent = visitor.parent;

    if (parent != null) {
      InstanceCreationVisitor instanceCreationVisitor =
          InstanceCreationVisitor();
      CompilationUnit compilationUnit =
          parseString(content: parent.toSource()).unit;
      compilationUnit.accept(instanceCreationVisitor);
      InstanceCreationExpression expression =
          instanceCreationVisitor.instanceCreationExpression!;
      if (expression.constructorName.staticElement?.displayName ==
          'Semantics') {
        return true;
      } else {
        return _parentIsSemantic(expression, visitor);
      }
    }
    return false;
  }
}
