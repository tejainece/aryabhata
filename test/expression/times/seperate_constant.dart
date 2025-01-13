import 'package:equation/equation.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _AddTermsTest {
  final Eq eq1;
  final C c;
  final Eq e;

  _AddTermsTest(this.eq1, this.c, this.e);

  static final cases = [
    _AddTermsTest(-C(2) * x * -h, C(2), x * h),
    _AddTermsTest(-h.pow(C(2)), C(-1), h.pow(C(2))),
  ];
}

void main() {
  group('Times.addTerms', () {
    test('test', () {
      for (final test in _AddTermsTest.cases) {
        expect(test.eq1.separateConstant().$1, EqEqualityMatcher(test.c));
        expect(test.eq1.separateConstant().$2, EqEqualityMatcher(test.e));
      }
    });
  });
}
