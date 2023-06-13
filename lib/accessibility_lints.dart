import 'package:accessibility_lints/rules/require_scalable_text.dart';
import 'package:accessibility_lints/rules/require_semantic_label.dart';
import 'package:accessibility_lints/rules/require_semantics_label.dart';
import 'package:accessibility_lints/rules/require_semantics_widget.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';


PluginBase createPlugin() => _MyLintsPlugin();

class _MyLintsPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs _) => [
        RequireScalableText(),
        RequireSemanticLabel(),
        RequireSemanticsLabel(),
        RequireSemanticsWidget(),
      ];
}
