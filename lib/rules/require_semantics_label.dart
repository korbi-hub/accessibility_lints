import 'package:accessibility_lints/shared/constants.dart';
import 'package:accessibility_lints/shared/utility_methods.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// constants
const semanticsLabelFix = 'semanticsLabel: semanticsLabelText';
const semanticLabelFix = 'semanticLabel: semanticLabelText';
const semanticsLabelFlag = 'semanticsLabel';
const semanticsLabelName = 'require_semantics_label';
const semanticsLabelMsg =
    'This Widget requires a semantic label to improve the overall accessibility of this application.\n\n'
    '''A semantic label provides a full sentence to describe a widget's content.''';
const semanticsLabelCorrection = 'add a semantic label';
const semanticLabelFlag = 'semanticLabel';
const semanticLabelName = 'require_semantic_label';

class RequireSemanticsLabel extends DartLintRule {
  RequireSemanticsLabel() : super(code: _lintCode);

  // define an error code consisting of an error name, a problem message and a correction message
  static const _lintCode = LintCode(
    name: semanticsLabelName,
    problemMessage: semanticsLabelMsg,
    correctionMessage: semanticsLabelCorrection,
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
          (requiresSemanticsLabel(
                  node.constructorName.staticElement!.displayName) ||
              requiresSemanticLabel(
                  node.constructorName.staticElement!.displayName)) &&
          !parentIsSemantic(node.parent, node)) {
        reporter.reportErrorForNode(_lintCode, node);
      }
    });
  }

  @override
  List<Fix> getFixes() => [
        RequireSemanticsLabelFix(),
      ];
}

class RequireSemanticsLabelFix extends DartFix {
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
          (requiresSemanticsLabel(
                  node.constructorName.staticElement!.displayName) ||
              requiresSemanticLabel(
                  node.constructorName.staticElement!.displayName)) &&
          !parentIsSemantic(node.parent, node)) {
        final String parameter;
        if (requiresSemanticsLabel(
            node.constructorName.staticElement!.displayName)) {
          parameter = semanticsLabelFix;
        } else {
          parameter = semanticLabelFix;
        }
        applyParameter(
          correctionMessage: semanticsLabelCorrection,
          parameter: addRemainingParameter(
              newParameter: parameter, arguments: node.argumentList.arguments),
          selectedNode: node,
          changeReporter: reporter,
        );
      }
    });
  }
}
