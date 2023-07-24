import 'package:accessibility_lints/shared/utility_methods.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// constants
const semanticsWidgetFlag = 'Semantics';
const semanticsWidgetName = 'require_semantics_widget';
const semanticsWidgetMsg = '''This Widget requires to be wrapped inside a Semantics widget to enable visually impaired people to access the application's content''';
const semanticsWidgetCorrection = 'wrap widget inside a Semantics widget';

// default value for the SemanticsProperties parameter in a Semantics widget
const defaultSemanticsProperties = 'SemanticsProperties(enabled: true, attributedLabel: AttributedString(string),)';

class RequireSemanticsWidget extends DartLintRule {
  RequireSemanticsWidget() : super(code: _lintCode);

  static const _lintCode = LintCode(
    name: semanticsWidgetName,
    problemMessage: semanticsWidgetMsg,
    correctionMessage: semanticsWidgetCorrection,
  );

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter,
      CustomLintContext context) {
    context.registry.addInstanceCreationExpression((node) {
      String? widgetName = node.constructorName.staticElement?.displayName;
      if (widgetName != null) {
        if (!containsSemanticLabel(node) &&
            (requiresSemanticLabel(
                    widgetName) ||
                requiresSemanticsLabel(
                    widgetName) ||
                requiresSemanticWidget(
                    widgetName)) &&
            !parentIsSemantic(node.parent, node)) {
          reporter.reportErrorForNode(_lintCode, node);
        }
      }
    });
  }

  @override
  List<Fix> getFixes() => [
        RequireSemanticsWidgetFix(),
      ];
}

///
/// This class offers an alternative solution for missing semantic labels.
/// Contrary to adding single labels to a widget, the widget can be wrapped
/// in a Semantics widget, in order to provide a broad range of possible
/// semantic parameters.
///
class RequireSemanticsWidgetFix extends DartFix {
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
      String? widgetName = node.constructorName.staticElement?.displayName;
      if (widgetName != null) {
        if (!containsSemanticLabel(node) &&
            (requiresSemanticLabel(
                widgetName) ||
                requiresSemanticsLabel(
                    widgetName) ||
                requiresSemanticWidget(
                    widgetName)) &&
            !parentIsSemantic(node.parent, node)) {
          final String semanticsWidget = wrapInSemanticsWidget(widget: node);
          insertSemanticsWidget(
            correctionMessage: semanticsWidgetCorrection,
            semanticsWidget: semanticsWidget,
            selectedNode: node,
            changeReporter: reporter,
          );
        }
      }
    });
  }
}
