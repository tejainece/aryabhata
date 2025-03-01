import 'package:aryabhata/aryabhata.dart';

void main() {
  Eq eq = (Eq.c(3.5)+i*0.866).pow(-1);
  Eq res = eq.rationalizeComplexDenominator();
  print(res);
}