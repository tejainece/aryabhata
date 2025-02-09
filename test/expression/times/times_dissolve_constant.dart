import 'package:equation/equation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../testing.dart';

class _Test {
  final Eq eq;
  final Eq res;
  final bool can;
  final String string;

  _Test(this.eq, this.res, this.string, {this.can = true});

  static final cases = [
    _Test(
      Constant(220) / Constant(120) / Constant(64) / Constant(54),
      Constant(0.0005304783950617284),
      '0.0005304783950617284',
    ),
    _Test(two * x * h, two * x * h, '2⋅x⋅h', can: false),
    _Test(x * two * h, two * x * h, '2⋅x⋅h', can: true),
    _Test(one * a * x, a * x, 'a⋅x', can: true),
    /*_Test(one * x * h, x * h, 'x⋅h', can: true),*/
  ];
}

void main() {
  group('Times.dissolveConstant', () {
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.eq.dissolveConstants();
        expect(res, EqEqualityMatcher(test.res));
        expect(test.eq.canDissolveConstants(), test.can);
        expect(res.toString(), test.string);
      }
    });
  });
}
