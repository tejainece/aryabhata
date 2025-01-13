import 'package:equation/equation.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _AddTermsTest {
  final Eq eq1;
  final Eq eq2;
  final Eq res;

  _AddTermsTest(this.eq1, this.eq2, this.res);

  static final cases = [
    _AddTermsTest(C(2), C(3), C(5)),
    _AddTermsTest(
      C(1.2) * x.pow(C(2)),
      C(3.5) * x.pow(C(2)),
      C(4.7) * x.pow(C(2)),
    ),
    _AddTermsTest(
      C(2) * x.pow(C(2)) * b,
      C(3.14) * x.pow(C(2)) * b,
      C(5.14) * x.pow(C(2)) * b,
    ),
  ];
}

void main() {
  group('Times.addTerms', () {
    test('test', () {
      for (final test in _AddTermsTest.cases) {
        expect(Eq.addTerms(test.eq1, test.eq2), EqEqualityMatcher(test.res));
      }
    });
  });
}
