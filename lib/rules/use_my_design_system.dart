import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:my_custom_lints/rules/use_instead_type.dart';

final class UseMyDesignSystemItemConfig {
  const UseMyDesignSystemItemConfig(this.replacements);

  factory UseMyDesignSystemItemConfig.fromConfig(Map<String, Object?> json) {
    final replacements = json.entries.map(
      (entry) => MapEntry(
        entry.key,
        [
          for (final material in entry.value! as List)
            (
              name: (material as Map)['instead_of'] as String,
              packageName: material['from_package'] as String
            ),
        ],
      ),
    );

    return UseMyDesignSystemItemConfig(Map.fromEntries(replacements));
  }

  final Map<String, List<NotRecommendedItem>> replacements;
}

final class UseDesignSystemItem extends UseInsteadType {
  UseDesignSystemItem({
    required String preferredItemName,
    required Iterable<NotRecommendedItem> replacements,
  }) : super(
          lintCodeName: ruleName,
          replacements: {preferredItemName: replacements.toList()},
        );

  static const ruleName = 'use_my_design_system';

  static Iterable<UseDesignSystemItem> getRulesListFromConfig(
    CustomLintConfigs configs,
  ) {
    final config = UseMyDesignSystemItemConfig.fromConfig(
      configs.rules[ruleName]?.json ?? {},
    );

    return config.replacements.entries.map(
      (entry) => UseDesignSystemItem(
        preferredItemName: entry.key,
        replacements: entry.value,
      ),
    );
  }

  @override
  String correctionMessage(String preferredItemName) {
    return 'Use the alternative defined in My Design System: $preferredItemName instead';
  }

  @override
  String problemMessage(String itemName) {
    return '$itemName is not recommended within this Design System';
  }
}
