import 'package:equation/equation.dart';

void main() {
  var eq = C(2).pow(C(3));
  print('${eq.simplify()} => $eq');

  eq = C(2).pow(C(2)).pow(C(3));
  print('${eq.simplify()} => $eq');

  eq = x.pow(C(2)).pow(C(3));
  print('${eq.simplify()} => $eq');
}