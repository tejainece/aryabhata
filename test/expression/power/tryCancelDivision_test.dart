import 'package:equation/equation.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _Test {
  final Eq numerator;
  final Eq denominator;

  final Eq res;

  _Test(this.numerator, this.denominator, this.res);

  static List<_Test> cases = [
    _Test(x.pow(Eq.c(2)), x.pow(Eq.c(2)), one),
    _Test(x.pow(Eq.c(2)), x, x),
    _Test((x * y).pow(Eq.c(2)), x, x * y.pow(Eq.c(2))),
  ];
}

void main() {
  group('Power.simplify', () {
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.numerator.tryCancelDivision(test.denominator);
        expect(res, EqEqualityMatcher(test.res));
      }
    });
  });
}
