import 'package:equation/equation.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _Test {
  final Eq input;
  final Eq res;

  _Test(this.input, this.res);

  static List<_Test> cases = [
    _Test((-x).pow(two), x.pow(two)),
    _Test((-x).pow(-two), x.pow(-two)),
    _Test((-x).pow(Eq.c(10)), x.pow(Eq.c(10))),
    _Test((-x).pow(-Eq.c(10)), x.pow(-Eq.c(10))),
    _Test((-x).pow(two * x), (-x).pow(two * x)),
  ];
}

void main() {
  group('Power.dissolveMinus', () {
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.input.dissolveMinus();
        expect(res, EqEqualityMatcher(test.res));
      }
    });
  });
}
