import 'package:aryabhata/aryabhata.dart';
import 'package:collection/collection.dart';

extension Eq0Simplify on Plus {
  Plus simplifyEq0() {
    final ret = expressions.toList();
    while (true) {
      final factor =
          ret
              .firstWhereOrNull((e) => e.separateDivision().$2.isNotEmpty)
              ?.separateDivision()
              .$2
              .first;
      if (factor == null) break;
      for (int i = 0; i < ret.length; i++) {
        ret[i] = Times([factor, ret[i]]).simplify();
      }
    }
    return Plus(ret);
  }
}
