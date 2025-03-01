import 'package:aryabhata/aryabhata.dart';
import 'package:aryabhata/variables.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../testing.dart';

class _Test {
  final Eq numerator;
  final List<Eq> denominator;
  final Eq term2;
  final Eq resNumerator;
  final Eq resDenominator;

  _Test(
    this.numerator,
    this.denominator,
    this.term2,
    this.resNumerator,
    this.resDenominator,
  );

  static List<_Test> cases = [
    _Test(c, [Eq.c(1)], Eq.c(1) / b, (c * b + 1), b),
    _Test(a, [b.pow(2)], c / b.pow(3), (a * b + c), b.pow(3)),
  ];
}

void main() {
  group('Plus.combineDenominators2Terms', () {
    test('test', () {
      for (final test in _Test.cases) {
        final (numerator, denominator) = Plus.commonDenominators2Terms(
          test.numerator,
          test.denominator,
          test.term2,
        );
        expect(numerator, EqEqualityMatcher(test.resNumerator));
        expect(Times(denominator), EqEqualityMatcher(test.resDenominator));
      }
    });
  });
}
