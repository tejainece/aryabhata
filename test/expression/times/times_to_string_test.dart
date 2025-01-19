import 'package:equation/equation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class _Test {
  final Eq eq;
  final String res;

  _Test(this.eq, this.res);

  static final List<_Test> divides = [
    _Test(x / y, 'x/y'),
    _Test(x / (Eq.c(2) * y), 'x/(2*y)'),
    _Test((x + y) / (Eq.c(2) * z), '(x+y)/(2*z)'),
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
