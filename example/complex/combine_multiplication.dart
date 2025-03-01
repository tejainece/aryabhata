import 'package:aryabhata/aryabhata.dart';

void main() {
  {
    Power eq = (Eq.c(1) + i * 2).pow(2);
    Eq simplified = eq.combinePowers();
    print(simplified);
    simplified = simplified.simplify();
    print(simplified);
  }
  {
    Power eq = (Eq.c(1) + i * 2).pow(3);
    Eq simplified = eq.combinePowers();
    print(simplified);
    simplified = simplified.simplify();
    print(simplified);
  }
  {
    Power eq = (Eq.c(1) + i * 2).pow(-2);
    Eq simplified = eq.combinePowers();
    print(simplified);
    simplified = simplified.simplify();
    print(simplified);
  }
}
