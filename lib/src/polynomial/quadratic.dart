import 'package:aryabhata/aryabhata.dart';

class Quadratic implements Polynomial {
  final Eq c2;
  final Eq c1;
  final Eq c0;

  Quadratic(this.c2, this.c1, this.c0);

  bool get hasSolution {
    throw UnimplementedError();
  }

  @override
  Eq get discriminant => (c1.pow(two) - Eq.c(4) * c2 * c0).simplify(debug: true);

  @override
  List<Eq> solve() {
    final ret = <Eq>[];
    ret.addAll([
      ((-c1 + discriminant.pow(0.5)) / (Eq.c(2) * c2)),
      ((-c1 - discriminant.pow(0.5)) / (Eq.c(2) * c2)),
    ]);
    for (var i = 0; i < ret.length; i++) {
      ret[i] = ret[i].simplify(debug: true);
    }
    return ret;
  }

  @override
  String toString() => 'c2=$c2, c1=$c1, c0=$c0';
}

extension QuadraticEqExt on Eq {
  Quadratic asQuadratic(Variable x) {
    var simplified = simplify();
    if (simplified is! Plus) {
      simplified = Plus([simplified]);
    }
    final c2 = <Eq>[];
    final c1 = <Eq>[];
    final c0 = <Eq>[];
    for (var term in simplified.expressions) {
      if (!term.hasVariable(x)) {
        c0.add(term);
        continue;
      }
      Eq tmp = (term / x.pow(Constant(2))).simplify();
      if (!tmp.hasVariable(x)) {
        c2.add(tmp);
        continue;
      }
      tmp = (term / x).simplify();
      if (!tmp.hasVariable(x)) {
        c1.add(tmp);
        continue;
      }
      throw UnsupportedError('$term not a polynomial');
    }

    return Quadratic(
      c2.isEmpty ? Constant(0) : Plus(c2),
      c1.isEmpty ? Constant(0) : Plus(c1),
      c0.isEmpty ? Constant(0) : Plus(c0),
    );
  }
}
