import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:gentopia/gentopia.dart';

class HashBenchmark extends BenchmarkBase {
  Hash h = new Hash('Ole Martin');
  HashBenchmark() : super("Hash");

  // The benchmark code.
  void run() {
    h.hash('321x132l5');
  }
}

class ColorGenBenchmark extends BenchmarkBase {
  var obj = new ColorGen();
  var rand = new Random();
  double value = 0.0;
  ColorGenBenchmark() : super("ColorGen");

  void setup(){
    value = rand.nextDouble();
  }
  // The benchmark code.
  void run() {
    obj.getColor(value);
  }
}

class WorldBenchmark extends BenchmarkBase {
  World w = new World();
  WorldBenchmark() : super("World");

  // The benchmark code.
  void run() {
    w.makeTexture(0, 0, 1, 1);
  }
}

main() {
  new HashBenchmark().report();
  new ColorGenBenchmark().report();
  new WorldBenchmark().report();
}

