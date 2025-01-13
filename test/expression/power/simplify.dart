import 'package:equation/equation.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _Test {
  final Eq eq;
  final Eq res;

  _Test(this.eq, this.res);

  static List<_Test> cases = [
    // Check right associativity
    _Test(C(2).pow(C(2)).pow(C(3)), C(256)),
    _Test(x.pow(C(2)).pow(C(3)).pow(y), x.pow(C(2)).pow(C(3)).pow(y)),

    // Check 1 power
    _Test(C(1).pow(C(4000)), C(1)),
    _Test(C(1).pow(C(-1)), C(1)),
    _Test(C(1).pow(C(0)), C(1)),
    _Test(C(1).pow(x).pow(y), C(1)),
    _Test(x.pow(y).pow(C(1).pow(z)), x.pow(y)),
    _Test(x.pow(y).pow(C(1).pow(z / C(3))), x.pow(y)),

    // Check power 1
    _Test(C(2).pow(C(1)), C(2)),
    _Test(C(0).pow(C(1)), C(0)),
    _Test(x.pow(C(1)), x),
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
