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
    /*_Case(Times([Eq.c(-2)]), Times([Eq.c(-2)]), '[-2]'),*/
    _Case(Times([Eq.c(-2) * x]), Times([Eq.c(-2) * x]), '[-2, x]')
    /*_Case(a * b, a * b, '[a, b]'),
    _Case(x * (a + a * b), x * a * (one + b), '[x, a, 1+b]'),*/
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
