import 'package:equation/equation.dart';
import 'package:equation/variables.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _AddTermsTest {
  final Eq eq1;
  final Eq eq2;
  final Eq res;

  _AddTermsTest(this.eq1, this.eq2, this.res);

  static final cases = [
    _AddTermsTest(Constant(2), Constant(3), Constant(5)),
    _AddTermsTest(
      Constant(1.2) * x.pow(Constant(2)),
      Constant(3.5) * x.pow(Constant(2)),
      Constant(4.7) * x.pow(Constant(2)),
    ),
    _AddTermsTest(
      Constant(2) * x.pow(Constant(2)) * b,
      Constant(3.14) * x.pow(Constant(2)) * b,
      Constant(5.14) * x.pow(Constant(2)) * b,
    ),
  ];
}

void main() {
  group('Times.addTerms', () {
    test('test', () {
      for (final test in _AddTermsTest.cases) {
        expect(
          Plus.tryAddTerms(test.eq1, test.eq2),
          EqEqualityMatcher(test.res),
        );
      }
    });
  });
}
