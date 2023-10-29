import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../shared.dart';
import 'particle_painter.dart';
import '../widgets/touch_detector.dart';

class ParticulesPainter extends CustomPainter {
  const ParticulesPainter(
    this.animation,
    this.allParticles,
    this.touchPointer,
    this.particleSize,
  ) : super(repaint: animation);

  final Animation<double> animation;
  final List<Particle> allParticles;
  final TouchPointer touchPointer;
  final double particleSize;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    for (var i = allParticles.length - 1; i >= 0; i--) {
      final particle = allParticles[i];
      particle.move(touchPointer);

      final color = particle.currentColor;
      particle.currentColor = Color.lerp(
          particle.currentColor, particle.endColor, particle.colorBlendRate)!;
      double targetSize = 2;
      if (!particle.isKilled) {
        targetSize = map(
          min(particle.distToTarget, closeEnoughTarget),
          closeEnoughTarget,
          0,
          0,
          particleSize,
        );
      }

      particle.currentSize =
          ui.lerpDouble(particle.currentSize, targetSize, 0.1)!;

      final center = Offset(particle.pos.x, particle.pos.y);
      canvas.drawCircle(center, particle.currentSize, Paint()..color = color);

      if (particle.isKilled) {
        if (particle.pos.x < 0 ||
            particle.pos.x > width ||
            particle.pos.y < 0 ||
            particle.pos.y > height) {
          allParticles.removeAt(i);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
