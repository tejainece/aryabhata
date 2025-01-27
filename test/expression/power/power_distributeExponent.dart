import 'package:equation/equation.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _Test {
  final Eq input;
  final Eq res;

  _Test(this.input, this.res);

  static List<_Test> cases = [
    _Test((x * y).pow(Eq.c(2)), x.pow(Eq.c(2)) * y.pow(Eq.c(2))),
    _Test(
      (-(x * y)).pow(Eq.c(2)),
      (-one).pow(Eq.c(2)) * x.pow(Eq.c(2)) * y.pow(Eq.c(2)),
    ),
    _Test((x.pow(y)).lpow(z), x.pow(y * z)),
    _Test((-(x.pow(y))).lpow(z), (-one).pow(z) * x.pow(y * z)),

    // TODO nest nested
  ];
}

void main() {
  group('Power.distributeExponent', () {
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.input.distributeExponent();
        expect(res, EqEqualityMatcher(test.res));
      }
    });
  });
}
