import 'dart:ui';
import 'dart:math';
import 'package:box2d_flame/box2d.dart';


/*
  Generate simple lines with a hole, size of one cell, in it.
 */
class LineGenerator {

  int _width, start, endbfgap, startafgap, end;
  bool gapbfstart = false, gapafend = false;


  LineGenerator(int width) {
    _width = width;
  }

  void generateNewLine(int width) {
    _width = width;
    int rnd = new Random().nextInt((width - 1));
    // gap is in between
    if (rnd != 0) {
      gapbfstart = false;
      gapafend = false;
      start = 0;
      endbfgap = rnd;
      startafgap = rnd + 1;
      end = _width;
    }
    // gap is at the beginning
    else if (rnd == 0) {
      gapbfstart = true;
      gapafend = false;
      start = rnd + 1;
      end = _width;
    }
    // gap is at the end
    else if (rnd == (width - 1)) {
      gapafend = true;
      gapbfstart = false;
      start = 0;
      end = rnd;
    }
  }

  List<Vector2> getStartingPoints() {
    /*
    print(start);
    print(endbfgap);
    print(startafgap);
    print(end);
    */
    List<Vector2> result = new List<Vector2>();
    // gap is in between
    if (!gapbfstart && !gapafend) {
      result.add(Vector2(start.toDouble(), endbfgap.toDouble()));
      result.add(Vector2(startafgap.toDouble(), end.toDouble()));
    }
    // gap is at the beginning
    else if (!gapafend && gapbfstart) {
      result.add(Vector2(start.toDouble(), end.toDouble()));
    }
    // gap is at the end
    else if (gapafend && !gapbfstart){
      result.add(Vector2(start.toDouble(), end.toDouble()));
    }
    return result;
  }

}