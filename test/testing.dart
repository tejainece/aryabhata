import 'package:equation/equation.dart';
import 'package:test/test.dart';

class EqEqualityMatcher extends Matcher {
  final Eq expected;
  final double epsilon;

  const EqEqualityMatcher(this.expected, [this.epsilon = 1e-6]);

  @override
  Description describe(Description description) {
    return description.add('equals $expected');
  }

  @override
  bool matches(other, Map<dynamic, dynamic> matchState) {
    if (other is! Eq) return false;
    bool isMatch = other.isSame(expected, epsilon);
    return isMatch;
  }
}

class EqIsNanMatcher extends Matcher {
  const EqIsNanMatcher();

  @override
  Description describe(Description description) {
    return description.add('equals nan');
  }

  @override
  bool matches(other, Map<dynamic, dynamic> matchState) {
    if (other is! Constant) return false;
    return other.value.isNaN;
  }
}
