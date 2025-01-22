import 'package:equation/equation.dart';

void main() {
  /*var eq = Constant(2).pow(Constant(3));
  print('${eq.simplify()} => $eq');

  eq = Constant(2).pow(Constant(2)).pow(Constant(3));
  print('${eq.simplify()} => $eq');

  eq = x.pow(Constant(2)).pow(Constant(3));
  print('${eq.simplify()} => $eq');*/

  {
    Eq eq = x.pow(-Eq.c(1).pow(Eq.c(2)));
    eq = eq.simplify();
    print(eq);
  }

  {
    Eq eq = (x.pow(-Eq.c(1))).pow(Eq.c(2));
    eq = eq.simplify();
    print(eq);
  }
}
