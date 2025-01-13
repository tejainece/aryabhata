import 'package:equation/equation.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _AddTermsTest {
  final Eq eq;
  final Eq res;

  _AddTermsTest(this.eq, this.res);

  static final cases = [
    _AddTermsTest(-h * -h, h.pow(C(2))),
    _AddTermsTest(
      -(C(2) * ((C(4) * a * x * c) / (C(2) * b.pow(C(2))))),
      -((C(8) * a * x * c) / (C(2) * (b.pow(C(2))))),
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
