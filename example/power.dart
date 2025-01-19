import 'package:equation/equation.dart';

void main() {
  var eq = Constant(2).pow(Constant(3));
  print('${eq.simplify()} => $eq');

  eq = Constant(2).pow(Constant(2)).pow(Constant(3));
  print('${eq.simplify()} => $eq');

  eq = x.pow(Constant(2)).pow(Constant(3));
  print('${eq.simplify()} => $eq');
}