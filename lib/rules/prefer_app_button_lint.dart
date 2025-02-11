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
    print("⚡ Executando PreferAppButtonLint...");

    final ResolvedUnitResult unit = await resolver.getResolvedUnitResult();
    final List<InstanceCreationExpression> elevatedButtonUsages =
        _findElevatedButtonUsages(unit);

    print(
        "🔍 Encontrados ${elevatedButtonUsages.length} usos de ElevatedButton");

    for (final usage in elevatedButtonUsages) {
      final int offset = usage.offset;
      final int length = usage.constructorName.type.length;
      reporter.reportErrorForOffset(
        code,
        offset,
        length,
      );
    }
  }

  List<InstanceCreationExpression> _findElevatedButtonUsages(
      ResolvedUnitResult unit) {
    final List<InstanceCreationExpression> usages = [];
    unit.unit.accept(_Visitor(usages));
    return usages;
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final List<InstanceCreationExpression> usages;

  _Visitor(this.usages);

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (node.constructorName.type.toString() == 'ElevatedButton') {
      usages.add(node);
    }
    super.visitInstanceCreationExpression(node);
  }
}
