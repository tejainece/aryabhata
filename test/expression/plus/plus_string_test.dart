import 'package:equation/equation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class _Test {
  final Eq eq;
  final String res;

  _Test(this.eq, this.res);

  static final List<_Test> minus = [
    _Test(Plus([-Times([-10]), x]), '-(-10)+x'),
  ];

  static final List<_Test> divides = [
    /*_Test((x * y).pow(Eq.c(2)) + (x * y).pow(Eq.c(2)), '(x⋅y)^2+(x⋅y)^2'),
    _Test(x.pow(Eq.c(2)) * (Eq.c(1) + Eq.c(2)), 'x^2⋅(1+2)'),*/
    _Test(x - (y + z), 'x-(y+z)'),
  ];
}

void main() {
  group('Plus.toString', () {
    test('minus', () {
      for(final test in _Test.minus) {
        final res = test.eq.toString();
        expect(res, test.res);
      }
    });

    test('divide', () {
      for (final test in _Test.divides) {
        final res = test.eq.toString();
        expect(res, test.res);
      }
    });
  });
}
