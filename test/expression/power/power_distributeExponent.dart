import 'package:equation/equation.dart';
import 'package:test/test.dart';

class _Test {
  final Eq input;
  final Eq res;
  final bool can;

  _Test(this.input, this.res, {this.can = true});

  static List<_Test> cases = [
    /*
    _Test((x * y).pow(Eq.c(2)), x.pow(Eq.c(2)) * y.pow(Eq.c(2))),
    _Test(
      (-(x * y)).pow(Eq.c(2)),
      (-one).pow(Eq.c(2)) * x.pow(Eq.c(2)) * y.pow(Eq.c(2)),
    ),
    _Test((x.pow(y)).lpow(z), x.pow(y * z)),
    _Test((-(x.pow(y))).lpow(z), (-one).pow(z) * x.pow(y * z)),*/
    _Test(
      ((-(a * x) - c) / b).pow(Eq.c(2)),
      (-(a * x) - c).pow(Eq.c(2)) / b.pow(Eq.c(2)),
    ),
    // TODO nest nested
  ];
}

void main() {
  group('Power.distributeExponent', () {
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.input.distributeExponent();
        print(res);
        print(test.res);
        // TODO expect(res, EqEqualityMatcher(test.res));
      }
    });
  });
  group('Power.canDistributeExponent', () {
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.input.canDistributeExponent();
        print(res);
        // TODO expect(res, EqEqualityMatcher(test.res));
      }
    });
  });
}
