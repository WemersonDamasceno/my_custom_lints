library my_custom_lints;

import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:my_custom_lints/rules/use_my_design_system.dart';

PluginBase createPlugin() => _CustomLintsPlugin();

class _CustomLintsPlugin extends PluginBase {
  @override
  List<DartLintRule> getLintRules(CustomLintConfigs config) {
    return <DartLintRule>[
      ...UseDesignSystemItem.getRulesListFromConfig(config),
    ];
  }
}
