import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

/// visitor class to extract the InstanceCreationExpression from a node
class InstanceCreationVisitor extends RecursiveAstVisitor<void> {
  late InstanceCreationExpression? instanceCreationExpression;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    instanceCreationExpression = node;
    super.visitInstanceCreationExpression(node);
  }
}
