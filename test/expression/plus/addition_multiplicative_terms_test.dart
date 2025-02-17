import 'package:equation/equation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../testing.dart';

class _Case {
  final Eq eq;
  final Times res;
  final String strings;

  _Case(this.eq, this.res, this.strings);

  static final simple = [
    _Case(a + a.pow(Eq.c(2)), a * (one + a), '[a, 1+a^(2-1)]'),
    _Case(a.pow(Eq.c(2)) + a, a * (a + one), '[a, a^(2-1)+1]'),
    _Case(a + a * b, a * (one + b), '[a, 1+b]'),
    _Case(a * b + a, a * (b + one), '[a, b+1]'),
    _Case((a + b) * b + (a + b) * x, (a + b) * (b + x), '[a+b, b+x]'),
    _Case(
      (a + b) * a + (a + b) * a * b * x,
      (a + b) * a * (one + b * x),
      '[a+b, a, 1+b⋅x]',
    ),
    _Case(
      Eq.c(1) / b.pow(2) + 1,
      b.pow(-2) * (Eq.c(1) + b.pow(2)),
      '[(b^2)^-1, 1+b^2]',
    ),
    _Case(
      a.pow(2) / b.pow(2) + 1,
      b.pow(-2) * (a.pow(2) + b.pow(2)),
      '[(b^2)^-1, a^2+b^2]',
    ),
    _Case(
      a.pow(2) / b.pow(2) + a / b + a,
      b.pow(-2) * a * (a + b + b.pow(2)),
      '[a, b^-1, (b^(2-1))^-1, a^(2-1)+b^(2-1)+b⋅b^(2-1)]',
    ),
  ];
}

void main() {
  group('Plus.multiplicativeTerms', () {
    test('test', () {
      for (final test in _Case.simple) {
        final res = test.eq.multiplicativeTerms();
        expect(res, EqEqualityMatcher(test.res));
        expect(res.expressions.toString(), test.strings);
      }
    });
  });
}
