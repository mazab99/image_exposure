import 'dart:typed_data';

import 'package:flutter/material.dart';

class Pixels {
  const Pixels({
    required this.byteData,
    required this.width,
    required this.height,
  });

  final ByteData byteData;
  final int width;
  final int height;

  Color getColorAt(int x, int y) {
    final offset = 4 * (x + y * width);
    final rgba = byteData.getUint32(offset);
    final a = rgba & 0xFF;
    final rgb = rgba >> 8;
    final argb = (a << 24) + rgb;
    return Color(argb);
  }
}
