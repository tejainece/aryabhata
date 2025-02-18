import 'package:equation/equation.dart';

class Quadratic {
  final Eq a;
  final Eq b;
  final Eq c;

  Quadratic(this.a, this.b, this.c);

  bool get hasSolution {
    throw UnimplementedError();
  }

  Eq get discriminant => (b.pow(two) - Eq.c(4) * a * c).simplify();

  List<Eq> solve() {
    final ret = <Eq>[];
    ret.addAll([
      ((-b + discriminant.pow(0.5)) / (Eq.c(2) * a)).simplify(),
      ((-b - discriminant.pow(0.5)) / (Eq.c(2) * a)).simplify(),
    ]);
    return ret;
  }

  @override
  String toString() => 'a= $a, b= $b, c= $c';
}
