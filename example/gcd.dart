import 'package:number_factorization/number_factorization.dart';

void main() {
  double a = 3.75 * 2 * 3;
  double b = 2 * 3;
  print('$a $b');
  final g = gcd(a, b);
  print(g);
  print('${a/g} ${b/g}');
}
