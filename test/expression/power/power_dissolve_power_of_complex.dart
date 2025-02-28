import 'package:equation/equation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../testing.dart';

class _Test {
  final Eq eq;
  final Eq res;
  final String str;

  _Test(this.eq, this.res, this.str);

  static List<_Test> cases = [
    /*_Test(
      (Eq.c(1) + i * 2).pow(0.5),
      Eq.c(1.4953487812212205) *
          (Eq.c(0.8506508083520399) + i * -0.5257311121191337),
      '1.4953487812212205⋅(0.8506508083520399+i⋅-0.5257311121191337)',
    ),
    _Test(
      (Eq.c(35) + i * 31.176914536239792).pow(-0.16666666666666666),
      Eq.c(0.5266403878479267) *
          (Eq.c(0.9926543566101322) + i * Eq.c(0.12098482674668143)),
      '0.5266403878479267⋅(0.9926543566101322+i⋅0.12098482674668143)',
    ),*/
    _Test(
      i.pow(1 / 3),
      Eq.c(0.8660254037844387) + i * Eq.c(0.49999999999999994),
      '0.8660254037844387+i⋅0.49999999999999994',
    ),
  ];
}

void main() {
  group('Power.dissolvePowerOfComplex', () {
    test('test', () {
      for (final test in _Test.cases) {
        print(test.eq);
        final res = test.eq.dissolvePowerOfComplex();
        expect(res, EqEqualityMatcher(test.res));
        expect(res.toString(), test.str);
      }
    });
  });
}
