import 'package:equation/equation.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _Test {
  final Eq eq;
  final Eq res;

  _Test(this.eq, this.res);

  static List<_Test> cases = [
    // Check right associativity
    _Test(Constant(2).pow(Constant(2)).pow(Constant(3)), Constant(256)),
    _Test(x.pow(Constant(2)).pow(Constant(3)).pow(y), x.pow(Constant(2)).pow(Constant(3)).pow(y)),

    // Check 1 power
    _Test(Constant(1).pow(Constant(4000)), Constant(1)),
    _Test(Constant(1).pow(Constant(-1)), Constant(1)),
    _Test(Constant(1).pow(Constant(0)), Constant(1)),
    _Test(Constant(1).pow(x).pow(y), Constant(1)),
    _Test(x.pow(y).pow(Constant(1).pow(z)), x.pow(y)),
    _Test(x.pow(y).pow(Constant(1).pow(z / Constant(3))), x.pow(y)),

    // Check power 1
    _Test(Constant(2).pow(Constant(1)), Constant(2)),
    _Test(Constant(0).pow(Constant(1)), Constant(0)),
    _Test(x.pow(Constant(1)), x),
  ];
}

void main() {
  group('Power.simplify', () {
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.eq.simplify();
        expect(res, EqEqualityMatcher(test.res));
      }
    });
  });
}
