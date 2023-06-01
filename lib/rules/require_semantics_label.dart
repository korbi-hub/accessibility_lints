import 'package:accessibility_lints/fixes/require_semantics_label_fix.dart';
import 'package:accessibility_lints/fixes/require_semantics_widget_fix.dart';
import 'package:accessibility_lints/shared/constants.dart';
import 'package:accessibility_lints/shared/utility_methods.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class RequireSemanticsLabel extends DartLintRule {
  RequireSemanticsLabel() : super(code: _code);

  // define an error code consisting of an error name, a problem message and a correction message
  static const _code = LintCode(
    name: semanticsLabelName,
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
      final String? widgetName =
          node.constructorName.staticElement?.displayName;

      // check if the widget requires the desired property
      if (widgetName != null &&
          requireSemanticsLabel.contains(widgetName) &&
          !UtilityMethods.hasParameter(
            parameter: 'semanticsLabel',
            arguments: node.argumentList.arguments,
          ) &&
          UtilityMethods.parentIsNotSemantic(node)) {
        // display the respective error message
        reporter.reportErrorForNode(_code, node);
      }
    });
  }

  @override
  List<Fix> getFixes() => [
        RequireSemanticsLabelFix(),
        RequireSemanticsWidgetFix(),
      ];
}
