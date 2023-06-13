import 'package:accessibility_lints/shared/constants.dart';
import 'package:accessibility_lints/shared/utility_methods.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class RequireSemanticLabelFix extends DartFix {
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
      // check if the widget requires the desired property
      if (!containsSemanticLabel(node) &&
          requiresSemanticLabel(
              node.constructorName.staticElement!.displayName) &&
          !parentIsSemantic(node.parent, node)) {
        applyParameter(
          correctionMessage: semanticsLableCorrection,
          parameter: addRemainingParameter(
              newParameter: semanticLabelFix,
              arguments: node.argumentList.arguments),
          selectedNode: node,
          changeReporter: reporter,
        );
      }
    });
  }
}
