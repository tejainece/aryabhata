import 'package:equation/equation.dart';
import 'package:test/test.dart';

class _Test {
  final Eq eq;
  final Eq res;
  final String str;
  final bool can;

  _Test(this.eq, this.res, this.str, [this.can = true]);

  static List<_Test> cases = [
    _Test(x + 1 + y, Eq.c(1) + x + y, '1+x+y', true),
    _Test(Eq.c(1) + x + y, Eq.c(1) + x + y, '1+x+y', false),
  ];
}

void main() {
  group('Plus.dissolveConstants', () {
    test('test', () {
      for (final test in _Test.cases) {
        print(test.eq);
        final res = test.eq.dissolveConstants();
        expect(res, test.res);
        expect(res.toString(), test.str);
        expect(test.eq.canDissolveConstants(), test.can);
      }
    });
  });
}
