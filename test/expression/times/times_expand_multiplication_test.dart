import 'package:aryabhata/aryabhata.dart';
import 'package:aryabhata/variables.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../testing.dart';

class _Test {
  final Eq eq;
  final Eq res;
  final bool can;
  final String string;

  _Test(this.eq, this.res, this.string, {this.can = true});

  static final List<_Test> divisions = [
    _Test((a + b) / d, a / d + b / d, 'a/d+b/d'),
    _Test(
      ((a + b) * (x + y)) / d,
      a * x / d + a * y / d + b * x / d + b * y / d,
      'a⋅x/d+a⋅y/d+b⋅x/d+b⋅y/d',
    ),
  ];
}

void main() {
  group('Times.expandMultiplication', () {
    test('division', () {
      for (var test in _Test.divisions) {
        final res = test.eq.expandMultiplications();
        expect(res, EqEqualityMatcher(test.res));
        // TODO expect(test.eq.canExpandMultiplications(), test.can);
        expect(res.toString(), test.string);
      }
    });
  });
}
