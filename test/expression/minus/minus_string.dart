import 'package:equation/equation.dart';
import 'package:test/test.dart';

class _Test {
  final Eq eq;
  final String str;

  _Test(this.eq, this.str);

  static List<_Test> cases = [
    _Test(Minus(Eq.c(-10)), '10'),
    _Test(Minus(Eq.c(10)), '-10'),
    _Test(-Times([-10]), '-(-10)'),
    _Test(-Times([-x]), '-(-x)'),
    _Test(-Times([-x, y]), '-(-x⋅y)'),
    _Test(-Times([x, y]), '-(x⋅y)'),
    _Test(-Times([x, -y]), '-(x⋅-y)'),
  ];
}

void main() {
  group('Minus.toString', () {
    test('test', () {
      for(final test in _Test.cases) {
        final res = test.eq.toString();
        expect(res, test.str);
      }
    });
  });
}