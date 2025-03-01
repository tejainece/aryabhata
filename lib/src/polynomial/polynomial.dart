import 'package:aryabhata/aryabhata.dart';

export 'quadratic.dart';
export 'quartic.dart';

abstract class Polynomial {
  Eq get discriminant;

  List<Eq> solve();
}