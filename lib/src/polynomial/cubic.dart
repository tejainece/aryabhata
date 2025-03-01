import 'dart:math';

import 'package:aryabhata/aryabhata.dart';

class Cubic implements Polynomial {
  final Eq c3; // a
  final Eq c2; // b
  final Eq c1; // c
  final Eq c0; // d

  Cubic(this.c3, this.c2, this.c1, this.c0);

  @override
  /// https://en.wikipedia.org/wiki/Cubic_equation
  /// 18*c3*c2*c1*c0-4*c2^3*c0+b^2c^2-4ac^3-27a^2d^2
  Eq get discriminant {
    final part1 = c3 * c2 * c1 * c0 * 18;
    final part2 = c2 * c2 * c2 * c0 * 4;
    final part3 = c2 * c2 * c1 * c1;
    final part4 = c3 * c1 * c1 * c1 * 4;
    final part5 = c3 * c3 * c0 * c0 * 27;

    return (part1 - part2 + part3 - part4 - part5).simplify();
  }

  @override
  List<Eq> solve() {
    final sigma = Eq.c(-0.5) + i * Eq.c(sqrt(3) / 2);

    final d0 = c2 * c2 - c3 * c1 * 3;
    final d1 = (c2.pow(3) * 2) - (c3 * c2 * c1 * 9) + (c3 * c3 * c0 * 27);
    final sqrtD = (discriminant * c3 * c3 * -27).pow(1 / 2);
    final C = ((d1 + sqrtD) / 2).pow(1/3);
    final constTerm = Eq.c(-1) / (c3 * 3);

    final solutions = <Eq>[
      constTerm * (c2 + C + (d0 / C)),
      constTerm * (c2 + (C * sigma) + (d0 / (C * sigma))),
      constTerm * (c2 + (C * sigma.pow(2)) + (d0 / (C * sigma.pow(2)))),
    ];

    for (var i = 0; i < solutions.length; i++) {
      solutions[i] = solutions[i].simplify();
    }

    return solutions;
  }

  @override
  String toString() => 'c3=$c3, c2=$c2, c1=$c1, c0=$c0';
}

extension CubicEqExt on Eq {
  Cubic asCubic(Variable x) {
    var simplified = simplify();
    if (simplified is! Plus) {
      simplified = Plus([simplified]);
    }
    final coeffs = List<List<Eq>>.generate(4, (_) => <Eq>[]);
    outer:
    for (var term in simplified.expressions) {
      for (int i = 0; i <= 4; i++) {
        Eq tmp = (term / x.pow(i)).simplify();
        if (!tmp.hasVariable(x)) {
          coeffs[i].add(tmp);
          continue outer;
        }
      }
      throw UnsupportedError('$term not a polynomial');
    }

    return Cubic(
      coeffs[3].isEmpty ? Constant(0) : Plus(coeffs[3]),
      coeffs[2].isEmpty ? Constant(0) : Plus(coeffs[2]),
      coeffs[1].isEmpty ? Constant(0) : Plus(coeffs[1]),
      coeffs[0].isEmpty ? Constant(0) : Plus(coeffs[0]),
    );
  }
}
