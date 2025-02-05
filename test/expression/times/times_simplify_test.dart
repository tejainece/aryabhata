import 'package:equation/equation.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _Test {
  final Eq eq;
  final Eq res;
  final String string;

  _Test(this.eq, this.res, this.string);

  static final constants = [_Test(Eq.c(1) * Eq.c(2), Eq.c(2), '2')];

  static final cases = [
    _Test(-h * -h, h.pow(Constant(2)), 'h^2'),
    _Test(
      -(Constant(2) *
          ((Constant(4) * a * x * c) / (Constant(2) * b.pow(Constant(2))))),
      -(Constant(4) * a * x * c / (b.pow(Constant(2)))),
      '-(4⋅a⋅x⋅c/b^2)',
    ),
    _Test(x.pow(two) / x.pow(two).lpow(one), one, '1'),
    _Test((-(a * x) - c) / b, -(a * x / b + c / b), '-(a⋅x/b+c/b)'),
  ];
}

void main() {
  group('Times.simplify', () {
    test('constants', () {
      for (final test in _Test.constants) {
        final res = test.eq.simplify();
        expect(res, EqEqualityMatcher(test.res));
        expect(res.toString(), test.string);
      }
    });
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.eq.simplify();
        expect(res, EqEqualityMatcher(test.res));
        expect(res.toString(), test.string);
      }
    });
  });
}
