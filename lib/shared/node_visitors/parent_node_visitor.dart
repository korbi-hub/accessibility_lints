import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class ParentNodeVisitor extends GeneralizingAstVisitor<void> {
  late AstNode? parent;

  @override
  void visitNode(AstNode node) {
    if (node.parent != null) {
      parent = node.parent!;
    }
    super.visitNode(node);
  }
}