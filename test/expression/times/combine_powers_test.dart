import 'package:aryabhata/aryabhata.dart';
import 'package:aryabhata/variables.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../testing.dart';

class _TestCase {
  final Eq eq;
  final Eq res;

  _TestCase(this.eq, this.res);

  static final cases = <_TestCase>[
    _TestCase(x.pow(Eq.c(2)) * y.pow(Eq.c(2)), (x * y).pow(Eq.c(2))),
  ];
}

void main() {
  group('Times.combinePowers', () {
    test('test', () {
      for (final tc in _TestCase.cases) {
        final res = tc.eq.combinePowers();
        expect(res, EqEqualityMatcher(tc.res));
      }
    });
  });
}
