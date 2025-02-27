import 'package:equation/equation.dart';
import 'package:equation/variables.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _Test {
  final Eq eq;
  final Eq res;

  _Test(this.eq, this.res);

  static List<_Test> right = [
    _Test(Constant(2).pow(Constant(2)).pow(Constant(3)), Constant(256)),
  ];

  static List<_Test> left = [
    _Test((Constant(2).pow(Constant(3))).lpow(Constant(2)), Constant(64)),
  ];

  static List<_Test> noop = [
    _Test(
      x.pow(Constant(2)).pow(Constant(3)).pow(y),
      x.pow(Constant(2)).pow(Constant(3)).pow(y),
    ),
    _Test((-1).pow(z), (-1).pow(z)),
  ];

  static List<_Test> power0 = [
    _Test(x.pow(zero), one),
    _Test(x.pow(y).pow(zero), x),
    _Test(x.pow(y).pow(zero).pow(a), x),
    _Test(x.pow(y).pow(zero).pow(a).pow(b), x),
    _Test(x.pow(y).pow(z).pow(zero).pow(a).pow(b), x.pow(y)),

    // ... ^ 0 ^ 0 ^ ...
    _Test(x.pow(zero).pow(zero), nan),
  ];

  static List<_Test> power1 = [
    _Test(Constant(0).pow(Constant(1)), Constant(0)),
    _Test(Constant(2).pow(Constant(1)), Constant(2)),
    _Test(x.pow(Constant(1)), x),
    _Test(x.pow(y).pow(Constant(1).pow(z)), x.pow(y)),
    _Test(x.pow(y).pow(Constant(1).pow(z / Constant(3))), x.pow(y)),
  ];

  static List<_Test> cases = [
    // Check 1 power
    /*_Test(Constant(1).pow(Constant(4000)), Constant(1)),
    _Test(Constant(1).pow(Constant(-1)), Constant(1)),
    _Test(Constant(1).pow(Constant(0)), Constant(1)),
    _Test(Constant(1).pow(x).pow(y), Constant(1)),*/

    _Test(x.pow(Eq.c(2)).lpow(Eq.c(-1)), x.pow(-Eq.c(2))),
  ];
}

void main() {
  group('Power.simplify', () {
    test('right', () {
      for (final test in _Test.right) {
        final res = test.eq.simplify();
        expect(res, EqEqualityMatcher(test.res));
      }
    });
    test('left', () {
      for (final test in _Test.left) {
        final res = test.eq.simplify();
        expect(res, EqEqualityMatcher(test.res));
      }
    });
    test('noop', () {
      for (final test in _Test.noop) {
        final res = test.eq.simplify();
        expect(res, EqEqualityMatcher(test.res));
      }
    });
    test('power0', () {
      for (final test in _Test.power0) {
        final res = test.eq.simplify();
        expect(res, EqEqualityMatcher(test.res));
      }
    });
    test('power1', () {
      for (final test in _Test.power1) {
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
