import 'package:equation/equation.dart';

class Quadratic {
  final Eq a;
  final Eq b;
  final Eq c;

  Quadratic(this.a, this.b, this.c);

  bool get hasSolution {
    throw UnimplementedError();
  }

  List<Eq> solve() {
    final ret = <Eq>[];
    ret.add(
      ((b.pow(two) - Eq.c(4) * a * c).pow(Constant(0.5)) - b) / (Eq.c(2) * a),
    );
    ret.add(
      ((b.pow(two) - Eq.c(4) * a * c).pow(Constant(0.5)) + b) / (Eq.c(2) * a),
    );
    return ret;
  }

  @override
  String toString() => 'a= $a, b= $b, c= $c';
}
