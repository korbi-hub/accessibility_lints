import 'package:accessibility_lints/fixes/require_semantic_label_fix.dart';
import 'package:accessibility_lints/shared/constants.dart';
import 'package:accessibility_lints/shared/utility_methods.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class RequireSemanticLabel extends DartLintRule {
  RequireSemanticLabel() : super(code: _code);

  // define an error code consisting of an error name, a problem message and a correction message
  static const _code = LintCode(
    name: semanticLabelName,
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
      // check if the widget requires the desired property
      if (!containsSemanticLabel(node) &&
          requiresSemanticLabel(
              node.constructorName.staticElement!.displayName) &&
          !parentIsSemantic(node.parent, node)) {
        // display the respective error message
        reporter.reportErrorForNode(_code, node);
      }
    });
  }

  @override
  List<Fix> getFixes() => [RequireSemanticLabelFix()];
}
