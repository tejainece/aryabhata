import 'package:equation/equation.dart';
import 'package:test/test.dart';

class _Test {
  final Eq eq;
  final String str;

  _Test(this.eq, this.str);

  static List<_Test> cases = [
    _Test(x.pow(2).pow(-1), 'x^2^-1'),
    _Test(x.pow(2).lpow(-1), '(x^2)^-1'),
  ];
}

void main() {
  group('Power.toString', () {
    test('test', () {
      for (final test in _Test.cases) {
        final str = test.eq.toString();
        expect(str, test.str);
      }
    });
  });
}
