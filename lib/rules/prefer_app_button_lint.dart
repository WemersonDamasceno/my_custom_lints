import 'dart:async';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class PreferAppButtonLint extends DartLintRule {
  const PreferAppButtonLint()
      : super(
          code: const LintCode(
            name: 'prefer_app_button_lint',
            problemMessage:
                'Evite usar o ElevatedButton diretamente. Utilize o AppButtonWidget.',
            correctionMessage:
                'Tente substituir o ElevatedButton por AppButtonWidget.',
          ),
        );

  @override
  List<String> get filesToAnalyze => const <String>['**.dart'];

  @override
  Future<void> run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) async {
    final ResolvedUnitResult unit = await resolver.getResolvedUnitResult();
    final List<SimpleIdentifier> elevatedButtonUsages =
        _findElevatedButtonUsages(unit);

    for (final usage in elevatedButtonUsages) {
      final int offset = usage.offset;
      const int length = 'ElevatedButton'.length;
      reporter.reportErrorForOffset(
        code,
        offset,
        length,
      );
    }
  }

  List<SimpleIdentifier> _findElevatedButtonUsages(ResolvedUnitResult unit) {
    final List<SimpleIdentifier> usages = [];
    unit.unit.accept(_Visitor(usages));
    return usages;
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final List<SimpleIdentifier> usages;

  _Visitor(this.usages);

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (node.name == 'ElevatedButton') {
      usages.add(node); // Adiciona o nó (node) ao invés de apenas o nome
    }
    super.visitSimpleIdentifier(node);
  }
}
