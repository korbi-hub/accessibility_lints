import 'package:accessibility_lints/shared/constants.dart';
import 'package:accessibility_lints/shared/utility_methods.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// constants
const scalableTextName = 'require_scalable_text';
const scalableTextMsg =
    'To meet accessibility criteria Text widgets must contain the textScaleFactor property.';
const scalableTextCorrection = 'add textScaleFactor.';
const scalableTextFix =
    'textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3)';

class RequireScalableText extends DartLintRule {
  RequireScalableText() : super(code: _lintCode);

  // define an error code consisting of an error name, a problem message and a correction message
  static const _lintCode = LintCode(
    name: scalableTextName,
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
      final String? widgetName =
          node.constructorName.staticElement?.displayName;

      // check if the widget requires the desired property
      if (isTextWidget(widgetName)) {
        if (!hasParameter(
          parameter: 'textScaleFactor',
          arguments: node.argumentList.arguments,
        )) {
          // display the respective error message
          reporter.reportErrorForNode(_lintCode, node);
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [RequireScalableTextFix()];
}

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
      if (isTextWidget(widgetName) &&
          !hasParameter(
            parameter: 'textScaleFactor',
            arguments: node.argumentList.arguments,
          )) {
        // insert the missing parameter into the widget's arguments
        final String replacement = addRemainingParameter(
          newParameter: scalableTextFix,
          arguments: node.argumentList.arguments,
        );

        // apply the correction
        applyParameter(
          correctionMessage: scalableTextCorrection,
          parameter: replacement,
          selectedNode: node,
          changeReporter: reporter,
        );
      }
    });
  }
}
