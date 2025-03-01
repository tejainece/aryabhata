import 'package:aryabhata/aryabhata.dart';
import 'package:aryabhata/variables.dart';

void main() {
  Eq eq = ((a * x - c) / b).pow(Constant(2));
  print(eq);
  eq = eq.distributeExponent();
  print(eq);
}
