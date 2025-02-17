import 'package:equation/equation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../testing.dart';

class _Test {
  final Eq eq;
  final Eq res;
  final String string;
  final bool can;

  _Test(this.eq, this.res, this.string, {this.can = true});

  static List<_Test> cases = [
    _Test(
      Eq.c(2) / (Eq.c(2) + Eq.c(4) * x),
      Eq.c(1) / (Eq.c(1) + x * 2),
      '(1+2⋅x)^-1',
    ),
    _Test(
      Eq.c(6) / (Eq.c(2) + Eq.c(4) * x),
      Eq.c(3) / (Eq.c(1) + x * 2),
      '3/(1+2⋅x)',
    ),
  ];
}

void main() {
  group('Times.reduceDivision', () {
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.eq.reduceDivisions();
        expect(res, EqEqualityMatcher(test.res));
        expect(test.eq.canReduceDivisions(), test.can);
        expect(res.toString(), test.string);
      }
    });
  });
}
