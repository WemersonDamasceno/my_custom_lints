import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

typedef NotRecommendedItem = ({String name, String packageName});

abstract base class UseInsteadType extends DartLintRule {
  UseInsteadType({
    required Map<String, List<NotRecommendedItem>> replacements,
    required this.lintCodeName,
    this.errorSeverity = ErrorSeverity.ERROR,
  })  : _checkers = [
          for (final MapEntry(key: preferredItemName, value: forbiden)
              in replacements.entries)
            (
              preferredItemName,
              TypeChecker.any([
                for (final (:name, :packageName) in forbiden)
                  if (packageName.startsWith('dart:'))
                    TypeChecker.fromUrl('$packageName#$name')
                  else
                    TypeChecker.fromName(
                      name,
                      packageName: packageName,
                    ),
              ])
            ),
        ],
        super(
          code: LintCode(
            name: lintCodeName,
            problemMessage: 'This item is not recommended',
          ),
        );

  final List<(String preferredItemName, TypeChecker)> _checkers;
  final String lintCodeName;
  final ErrorSeverity errorSeverity;

  String problemMessage(String itemName);
  String correctionMessage(String preferredItemName);

  @override
  bool isEnabled(CustomLintConfigs configs) {
    return _checkers.isNotEmpty;
  }

  LintCode _createCode({
    required String itemName,
    required String preferredItemName,
  }) =>
      LintCode(
        name: lintCodeName,
        problemMessage: problemMessage(itemName),
        correctionMessage: correctionMessage(preferredItemName),
        errorSeverity: errorSeverity,
      );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addNamedType((node) {
      if (node.element case final element?) {
        _handleElement(reporter, element, node);
      }
    });
  }

  void _handleElement(
    ErrorReporter reporter,
    Element element,
    AstNode node,
  ) {
    for (final (preferredItemName, checker) in _checkers) {
      try {
        if (checker.isExactly(element)) {
          reporter.reportErrorForNode(
            _createCode(
              itemName: element.displayName,
              preferredItemName: preferredItemName,
            ),
            node,
          );
        }
      } catch (_) {}
    }
  }
}
