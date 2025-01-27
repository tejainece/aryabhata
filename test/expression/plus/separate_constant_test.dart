import 'package:equation/equation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../testing.dart';

class _TestCase {
  final Eq eq;
  final num c;
  final Eq result;

  _TestCase(this.eq, this.c, this.result);

  static List<_TestCase> cases = [
    _TestCase(Constant(2) * x + Constant(2) * y, 2, x + y),
  ];
}

void main() {
  group('Plus.separateConstant', () {
    test('test', () {
      for (final tc in _TestCase.cases) {
        final (c, eq) = tc.eq.separateConstant();
        expect(c, closeTo(tc.c, 1e-6));
        expect(eq, EqEqualityMatcher(tc.result));
      }
    });
  });
}