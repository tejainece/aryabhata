import 'package:equation/equation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class _Test {
  final Eq eq;
  final String res;

  _Test(this.eq, this.res);

  static final List<_Test> divides = [
    _Test((x * y).pow(Eq.c(2)) + (x * y).pow(Eq.c(2)), '(x⋅y)^2+(x⋅y)^2'),
    _Test((x * y).pow(Eq.c(2)) + (x * y).pow(Eq.c(2)), '(x⋅y)^2+(x⋅y)^2'),
  ];
}

void main() {
  group('Plus.toString', () {
    test('test', () {
      for (final test in _Test.divides) {
        expect(test.eq.toString(), test.res);
      }
    });
  });
}
