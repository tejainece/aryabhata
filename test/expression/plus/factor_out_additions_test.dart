import 'package:equation/equation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class _Test {
  final Eq eq;
  final String res;

  const _Test(this.eq, this.res);

  static List<_Test> cases = [
    // TODO _Test(C(-4 * 3) * x + C(-8) * y, C(-4) * (C(3) * x + C(2) * y)),
    _Test(x + Constant(2) * x, 'x * (1 + 2)'),
  ];
}

void main() {
  group('Plus.factorOutAdditions', () {
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.eq.factorOutAddition();
        expect(res.toString(), test.res);
      }
    });
  });
}
