import 'package:accessibility_lints/shared/constants.dart';
import 'package:accessibility_lints/shared/utility_methods.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class RequireSemanticsLabel extends DartLintRule {

  RequireSemanticsLabel() : super(code: _code);

  // define an error code consisting of an error name, a problem message and a correction message
  static const _code = LintCode(
    name: 'require_semantics_label',
    problemMessage: semanticsLabelMsg,
    correctionMessage: semanticsLableCorrection,
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
          requireSemanticLabel.contains(widgetName) ||
          requireSemanticsLabel.contains(widgetName)
      ) {
        if (!UtilityMethods.hasParameter('semanticsLabel', node.argumentList.arguments) ||
          !UtilityMethods.hasParameter('semanticsLabel', node.argumentList.arguments)
        ) {
          // display the respective error message
          reporter.reportErrorForNode(_code, node);
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [_RequireSemanitcsLabelFix()];

}

class _RequireSemanitcsLabelFix extends DartFix {

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
      if (widgetName != null &&
          requireSemanticLabel.contains(widgetName) ||
          requireSemanticsLabel.contains(widgetName)
      ) {

        // insert the missing parameter into the widget's arguments
        final String replacement = UtilityMethods
            .addRemainingParameter(
              requireSemanticLabel
                  .contains(widgetName)
                    ? semanticLabelFix : semanticsLabelFix,
              node.argumentList.arguments
        );

        final changeBuilder = reporter.createChangeBuilder(
          message: semanticsLableCorrection,
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