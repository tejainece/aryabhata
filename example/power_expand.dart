import 'package:equation/equation.dart';
import 'package:equation/variables.dart';

void main() {
  Eq eq = ((a * x - c) / b).pow(Constant(2));
  print(eq);
  eq = eq.distributeExponent();
  print(eq);
}
