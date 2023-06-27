import 'package:accessibility_lints/fixes/require_semantics_widget_fix.dart';
import 'package:accessibility_lints/shared/constants.dart';
import 'package:accessibility_lints/shared/utility_methods.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class RequireSemanticsWidget extends DartLintRule {
  RequireSemanticsWidget() : super(code: _code);

  static const _code = LintCode(
    name: semanticsWidgetName,
    problemMessage: semanticsWidgetMsg,
    correctionMessage: semanticsWidgetCorrection,
  );

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter,
      CustomLintContext context) {
    context.registry.addInstanceCreationExpression((node) {
      if (node.constructorName.staticElement?.displayName != null) {
        if (!containsSemanticLabel(node) &&
            (requiresSemanticLabel(
                    node.constructorName.staticElement!.displayName) ||
                requiresSemanticsLabel(
                    node.constructorName.staticElement!.displayName)) &&
            !parentIsSemantic(node.parent, node)) {
          reporter.reportErrorForNode(_code, node);
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [
        RequireSemanticsWidgetFix(),
      ];
}
