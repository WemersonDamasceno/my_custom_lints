library my_custom_lints;

import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:my_custom_lints/rules/prefer_app_button_lint.dart';

PluginBase createPlugin() => _CustomLints();

class _CustomLints extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs config) {
    return <LintRule>[
      const PreferAppButtonLint(),
    ];
  }
}
