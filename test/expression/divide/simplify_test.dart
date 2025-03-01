import 'package:aryabhata/aryabhata.dart';
import 'package:test/test.dart';

import '../../testing.dart';

class _Test {
  final Eq eq;
  final Eq res;
  final String string;

  _Test(this.eq, this.res, this.string);

  static List<_Test> cases = [
  ];
}

void main() {
  group('simplify', () {
    test('test', () {
      for (final test in _Test.cases) {
        final res = test.eq.simplify();
        expect(res, EqEqualityMatcher(test.res));
        expect(res.toString(), test.string);
      }
    });
  });
}
