import 'package:aryabhata/aryabhata.dart';
import 'package:aryabhata/variables.dart';

void main() {
  Plus eq = one + a * t.pow(-1) + b * t.pow(-2);
  Eq res = eq.simplifyEq0();
  print(res);
}