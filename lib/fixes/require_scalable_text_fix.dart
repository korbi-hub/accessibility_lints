
import 'package:accessibility_lints/shared/constants.dart';
import 'package:accessibility_lints/shared/utility_methods.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

///
/// append textScaleFactor to the widget
///
class RequireScalableTextFix extends DartFix {
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
          widgetName == 'Text' &&
          !UtilityMethods.hasParameter(
            parameter: 'textScaleFactor',
            arguments: node.argumentList.arguments,
          )) {
        // insert the missing parameter into the widget's arguments
        final String replacement = UtilityMethods.addRemainingParameter(
          newParameter: scalableTextFix,
          arguments: node.argumentList.arguments,
        );

        // apply the correction
        UtilityMethods.applyParameter(
          correctionMessage: scalableTextCorrection,
          parameter: replacement,
          selectedNode: node,
          changeReporter: reporter,
        );
      }
    });
  }
}