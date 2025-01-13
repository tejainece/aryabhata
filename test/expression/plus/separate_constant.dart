import 'package:equation/equation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../testing.dart';

class _TestCase {
  final Eq eq;
  final C c;
  final Eq result;

  _TestCase(this.eq, this.c, this.result);

  static List<_TestCase> cases = [
    _TestCase(C(2) * x + C(2) * y, C(2), x + y),
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