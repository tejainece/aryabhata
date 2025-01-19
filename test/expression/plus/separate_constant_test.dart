import 'package:equation/equation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../testing.dart';

class _TestCase {
  final Eq eq;
  final Constant c;
  final Eq result;

  _TestCase(this.eq, this.c, this.result);

  static List<_TestCase> cases = [
    _TestCase(Constant(2) * x + Constant(2) * y, Constant(2), x + y),
  ];
}

void main() {
  group('Plus.separateConstant', () {
    test('test', () {
      for (final tc in _TestCase.cases) {
        final (c, eq) = tc.eq.separateConstant();
        expect(c, EqEqualityMatcher(tc.c));
        expect(eq, EqEqualityMatcher(tc.result));
      }
    });
  });
}