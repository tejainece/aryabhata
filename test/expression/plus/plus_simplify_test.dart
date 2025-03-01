import 'package:aryabhata/aryabhata.dart';
import 'package:aryabhata/variables.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../testing.dart';

class _Test {
  final Eq eq;
  final Eq res;

  const _Test(this.eq, this.res);

  static List<_Test> cases = [
    _Test(
      Constant(-4 * 3) * x + Constant(-8) * y,
      Constant(-4) * (Constant(3) * x + Constant(2) * y),
    ),
  ];
}

void main() {
  group('Plus.Simplify', () {
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.eq.factorOutAddition();
        expect(res, EqEqualityMatcher(test.res));
      }
    });
  });
}
