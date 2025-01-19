import 'package:equation/equation.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _Test {
  final Eq eq;
  final Eq res;

  _Test(this.eq, this.res);

  static List<_Test> cases = [
    _Test(Constant(220) / Constant(120) / Constant(64) / Constant(54), Constant(0.00053047839)),
    _Test(x / y / z, x / (y * z)),
    _Test(x / Constant(1), x),
  ];

  static List<_Test> nans = [_Test(x / Constant(0), Constant(double.nan))];
}

void main() {
  group('Divide.simplify', () {
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.eq.simplify();
        expect(res, EqEqualityMatcher(test.res));
      }
    });
    test('nan', () {
      for (final test in _Test.nans) {
        final res = test.eq.simplify();
        expect(res, EqIsNanMatcher());
      }
    });
  });
}
