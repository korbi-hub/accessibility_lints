import 'package:accessibility_lints/shared/constants.dart';
import 'package:accessibility_lints/shared/utility_methods.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

///
/// This class offers an alternative solution for missing semantic labels.
/// Contrary to adding single labels to a widget, the widget can be wrapped
/// in a Semantics widget, in order to provide a broad range of possible
/// semantic parameters.
///
class RequireSemanticsWidgetFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      if (node.constructorName.staticElement?.displayName != null) {
        if (!containsSemanticLabel(node) &&
            (requiresSemanticLabel(
                node.constructorName.staticElement!.displayName) ||
            requiresSemanticsLabel(
                node.constructorName.staticElement!.displayName)) &&
            !parentIsSemantic(node.parent, node)) {
          final String semanticsWidget = wrapInSemanticsWidget(widget: node);
          insertSemanticsWidget(
            correctionMessage: semanticsWidgetCorrection,
            semanticsWidget: semanticsWidget,
            selectedNode: node,
            changeReporter: reporter,
          );
        }
      }
    });
  }
}
