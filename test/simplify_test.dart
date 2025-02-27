import 'package:equation/equation.dart';
import 'package:equation/variables.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'testing.dart';

class _Test {
  final Eq eq;
  final Eq res;
  final String string;

  _Test(this.eq, this.res, this.string);

  static final List<_Test> cases = [
    /*_Test(
      Power(-(a + b), two),
      a.pow(two) + a * 2 * b + b.pow(2),
      'a^2+2⋅a⋅b+b^2',
    ),
    _Test(
      Power(-(a + b), three),
      -a.pow(3) - a.pow(2) * 3 * b - a * 3 * b.pow(2) - b.pow(3),
      '-a^3-3⋅a^2⋅b-3⋅a⋅b^2-b^3',
    ),*/
  ];

  static final List<_Test> noop = [
    _Test(
      (one - a.pow(2) / b.pow(2)).pow(-1),
      (one - a.pow(2) / b.pow(2)).pow(-1),
      '(1-a^2/b^2)^-1',
    ),
  ];
}

void main() {
  group('simplify', () {
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.eq.simplify();
        expect(res, EqEqualityMatcher(test.res));
        expect(res.toString(), test.string);
      }
    });
    test('noop', () {
      for (final test in _Test.noop) {
        final res = test.eq.simplify();
        expect(res, EqEqualityMatcher(test.res));
        expect(res.toString(), test.string);
      }
    });
  });
}
