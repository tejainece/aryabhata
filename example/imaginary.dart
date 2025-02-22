import 'package:equation/equation.dart';

void main() {
  for(int c = 0; c < 10; c++) {
    Eq eq = one;
    for(int j = 0; j < c; j++) {
      eq = eq * i;
    }
    final res = eq.simplify();
    print('$c => $res');
  }
  for(int c = 0; c < 10; c++) {
    Eq eq = i.pow(c);
    final res = eq.simplify();
    print('$c => $res');
  }
  print(Power(-1, 0.5).simplify());
  print(Power(-2, 1/3).simplify());
}