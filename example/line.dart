import 'package:aryabhata/aryabhata.dart';
import 'package:aryabhata/variables.dart';

void main() {
  var line = a * x + b * y + c;
  print(line);
  var res = line.equationOf(y);
  print(res);
}