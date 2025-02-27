import 'package:equation/equation.dart';
import 'package:equation/variables.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _Test {
  final Eq input;
  final Eq res;

  _Test(this.input, this.res);

  static List<_Test> cases = [
    _Test((x.pow(y)).lpow(z), x.pow(y * z)),
    _Test(((-x).pow(y)).lpow(z), (-x).pow(y * z)),
    _Test((-x.pow(y)).lpow(z), (-one).pow(z) * x.pow(y * z)),
  ];
}

void main() {
  group('Power.dissolvePowerOfPower', () {
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.input.dissolvePowerOfPower();
        expect(res, EqEqualityMatcher(test.res));
      }
    });
  });
}
