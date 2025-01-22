import 'package:equation/equation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../testing.dart';

class _Test {
  final Eq eq;
  final Eq res;

  const _Test(this.eq, this.res);

  static List<_Test> cases = [
    /*_Test(
      Eq.c(-4 * 3) * x + Eq.c(-8) * y,
      Eq.c(-4) * (Eq.c(3) * x + Eq.c(2) * y),
    ),
    _Test(x + Constant(2) * x, x * (Eq.c(1) + Eq.c(2))),*/
    _Test(
      (x * y).pow(Eq.c(2)) + (x * y).pow(Eq.c(2)),
      (x * y).pow(Eq.c(2)) * (Eq.c(1) + Eq.c(2)),
    ),
  ];
}

void main() {
  group('Plus.factorOutAdditions', () {
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.eq.factorOutAddition();
        print(test.eq);
        expect(res, EqEqualityMatcher(test.res));
      }
    });
  });
}
