import 'package:equation/equation.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _Test {
  final Eq eq;
  final Eq res;

  _Test(this.eq, this.res);

  static final constants = [
    _Test(Eq.c(1) * Eq.c(2), Eq.c(2)),
  ];

  static final cases = [
    /*_Test(-h * -h, h.pow(Constant(2))),
    _Test(
      -(Constant(2) * ((Constant(4) * a * x * c) / (Constant(2) * b.pow(Constant(2))))),
      -((Constant(8) * a * x * c) / (Constant(2) * (b.pow(Constant(2))))),
    ),*/
    // TODO _Test(x.pow(two)/x.pow(two).lpow(one), one),
    _Test((-(a*x)-c)/b, Minus(-((a*x + c)/b))),
  ];
}

void main() {
  group('Times.simplify', () {
    test('constants', () {
      for (final test in _Test.constants) {
        final res = test.eq.simplify();
        expect(res, EqEqualityMatcher(test.res));
      }
    });
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.eq.simplify();
        expect(res, EqEqualityMatcher(test.res));
      }
    });
  });
}
