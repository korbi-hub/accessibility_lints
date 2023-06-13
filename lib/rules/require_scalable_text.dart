import 'package:accessibility_lints/fixes/require_scalable_text_fix.dart';
import 'package:accessibility_lints/shared/constants.dart';
import 'package:accessibility_lints/shared/utility_methods.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class RequireScalableText extends DartLintRule {
  RequireScalableText() : super(code: _code);

  // define an error code consisting of an error name, a problem message and a correction message
  static const _code = LintCode(
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
      if (widgetName != null && widgetName == 'Text') {
        if (!hasParameter(
          parameter: 'textScaleFactor',
          arguments: node.argumentList.arguments,
        )) {
          // display the respective error message
          reporter.reportErrorForNode(_code, node);
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [RequireScalableTextFix()];
}
