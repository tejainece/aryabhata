import 'package:aryabhata/aryabhata.dart';
import 'package:aryabhata/variables.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class _Test {
  final Eq eq;
  final String res;

  _Test(this.eq, this.res);

  static final List<_Test> divides = [
    _Test(x / y, 'x/y'),
    _Test(x / (Eq.c(2) * y), 'x/(2⋅y)'),
    _Test((x + y) / (Eq.c(2) * z), '(x+y)/(2⋅z)'),
    _Test((x * y).pow(Eq.c(2)) * (Eq.c(1) + Eq.c(2)), '(x⋅y)^2⋅(1+2)'),
  ];
}

void main() {
  group('Times.toString', () {
    test('test', () {
      for (final test in _Test.divides) {
        expect(test.eq.toString(), test.res);
      }
    });
  });
}
