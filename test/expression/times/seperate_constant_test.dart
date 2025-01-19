import 'package:equation/equation.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _AddTermsTest {
  final Eq eq1;
  final Constant c;
  final Eq e;

  _AddTermsTest(this.eq1, this.c, this.e);

  static final cases = [
    _AddTermsTest(-Constant(2) * x * -h, Constant(2), x * h),
    _AddTermsTest(-h.pow(Constant(2)), Constant(-1), h.pow(Constant(2))),
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
