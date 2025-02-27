import 'package:equation/equation.dart';
import 'package:equation/src/polynomial/cubic.dart';
import 'package:equation/variables.dart';

void main() {
  Eq eq = (t - 1) * (t - 2) * (t - 3);
  eq = eq.simplify();
  print(eq);

  final cubic = eq.asCubic(t);
  print(cubic);
  print(cubic.discriminant);

  final sols = cubic.solve();
  print('-----------------------------------------------------');
  for (final sol in sols) {
    print(sol.toString(spec: EquationPrintSpec(maxPrecision: 3)));
  }
}
