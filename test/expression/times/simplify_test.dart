import 'package:equation/equation.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _AddTermsTest {
  final Eq eq;
  final Eq res;

  _AddTermsTest(this.eq, this.res);

  static final cases = [
    _AddTermsTest(-h * -h, h.pow(Constant(2))),
    _AddTermsTest(
      -(Constant(2) * ((Constant(4) * a * x * c) / (Constant(2) * b.pow(Constant(2))))),
      -((Constant(8) * a * x * c) / (Constant(2) * (b.pow(Constant(2))))),
    ),
  ];
}

void main() {
  group('Times.simplify', () {
    test('test', () {
      for (final test in _AddTermsTest.cases) {
        final res = test.eq.simplify();
        expect(res, EqEqualityMatcher(test.res));
      }
    });
  });
}
