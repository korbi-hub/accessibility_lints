
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

      // extract the widget name
      final String? widgetName =
          node.constructorName.staticElement?.displayName;

      // check if the widget requires the desired property
      if (widgetName != null &&
          requireSemanticLabel.contains(widgetName) &&
          !UtilityMethods.hasParameter(
              parameter: 'semanticLabel',
              arguments: node.argumentList.arguments)) {
        // insert the missing parameter into the widget's arguments
        final String replacement = UtilityMethods.addRemainingParameter(
            newParameter: semanticLabelFix,
            arguments: node.argumentList.arguments);
        UtilityMethods.applyParameter(
          correctionMessage: semanticsLableCorrection,
          parameter: replacement,
          selectedNode: node,
          changeReporter: reporter,
        );
      }
    });
  }
}
