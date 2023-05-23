import 'package:accessibility_lints/shared/constants.dart';
import 'package:accessibility_lints/shared/utility_methods.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class RequireScalableText extends DartLintRule {

  RequireScalableText() : super(code: _code);

  // define an error code consisting of an error name, a problem message and a correction message
  static const _code = LintCode(
    name: 'require_scalable_text',
    problemMessage: scalableTextMsg,
    correctionMessage: scalableTextCorrection,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
      ) {
    context.registry.addInstanceCreationExpression((node) {

      // extract the widget name
      final String? widgetName = node.constructorName.staticElement?.displayName;

      // check if the widget requires the desired property
      if (widgetName != null &&
          widgetName == 'Text'
      ) {
        if (!UtilityMethods.hasParameter('textScaleFactor', node.argumentList.arguments)) {
          // display the respective error message
          reporter.reportErrorForNode(_code, node);
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [_RequireScalableTextFix()];

}

class _RequireScalableTextFix extends DartFix {

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
      final String? widgetName = node.constructorName.staticElement?.displayName;

      // check if the widget requires the desired property
      if (widgetName != null && widgetName == 'Text') {

        // insert the missing parameter into the widget's arguments
        final String replacement = UtilityMethods
            .addRemainingParameter(scalableTextFix, node.argumentList.arguments);

        final changeBuilder = reporter.createChangeBuilder(
          message: scalableTextCorrection,
          priority: 1,
        );

        // apply the fix to the incorrect line
        changeBuilder.addDartFileEdit((builder) {
          builder.addSimpleReplacement(SourceRange(node.argumentList.offset, node.argumentList.length), replacement);
        });
      }
    });
  }


}