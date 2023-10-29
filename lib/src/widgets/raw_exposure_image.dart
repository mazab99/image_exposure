import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:image_exposure/src/painters/pixels_painter.dart';

import '../shared.dart';
import '../painters/particle_painter.dart';
import '../painters/particules_painter.dart';
import 'touch_detector.dart';

class RawExposureImage extends StatefulWidget {
  const RawExposureImage({
    Key? key,
    required this.provider,
    required this.onError,
    required this.configuration,
    required this.size,
    required this.touchSize,
    required this.particleSize,
  }) : super(key: key);

  final ImageProvider<Object> provider;
  final ImageErrorListener onError;
  final ImageConfiguration configuration;
  final Size size;
  final double touchSize;
  final double particleSize;

  @override
  _RawExposureImageState createState() => _RawExposureImageState();
}

class _RawExposureImageState extends State<RawExposureImage>
    with SingleTickerProviderStateMixin {
  final List<Particle> particles = <Particle>[];
  final TouchPointer touchPointer = TouchPointer();
  ui.Image? image;
  Pixels? pixels;
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    touchPointer.touchSize = widget.touchSize;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    loadPixels();
  }

  @override
  void didUpdateWidget(covariant RawExposureImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    touchPointer.touchSize = widget.touchSize;
    if (oldWidget.provider != widget.provider) {
      image?.dispose();
      loadPixels();
    }
  }

  @override
  void dispose() {
    controller!.dispose();
    image?.dispose();
    super.dispose();
  }

  Future<void> loadPixels() async {
    final imageStream = widget.provider.resolve(widget.configuration);
    final completer = Completer<ui.Image>();
    ImageStreamListener? imageStreamListener;
    imageStreamListener = ImageStreamListener(
      (frame, _) {
        completer.complete(frame.image);
        imageStream.removeListener(imageStreamListener!);
      },
      onError: widget.onError,
    );
    imageStream.addListener(imageStreamListener);
    final image = await completer.future;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final pixels = Pixels(
      byteData: byteData!,
      width: image.width,
      height: image.height,
    );
    showParticles(pixels);
  }

  void showParticles(Pixels pixels) {
    final particleIndices = List<int>.generate(particles.length, (i) => i);
    final width = widget.size.width;
    final height = widget.size.height;
    final halfWidth = width / 2;
    final halfHeight = height / 2;
    final halfImageWidth = pixels.width / 2;
    final halfImageHeight = pixels.height / 2;
    final tx = halfWidth - halfImageWidth;
    final ty = halfHeight - halfImageHeight;

    for (var y = 0; y < pixels.height; y++) {
      for (var x = 0; x < pixels.width; x++) {
        // Give it small odds that we'll assign a particle to this pixel.
        if (randNextD(1) > loadPercentage * countMultiplier) {
          continue;
        }

        final pixelColor = pixels.getColorAt(x, y);
        Particle newParticle;
        if (particleIndices.isNotEmpty) {
          final index = particleIndices.length == 1
              ? particleIndices.removeAt(0)
              : particleIndices.removeAt(randI(0, particleIndices.length - 1));
          newParticle = particles[index];
        } else {
          // Create a new particle.
          newParticle = Particle(halfWidth, halfHeight);
          particles.add(newParticle);
        }

        newParticle.target.x = x + tx;
        newParticle.target.y = y + ty;
        newParticle.endColor = pixelColor;
      }
    }

    if (particleIndices.isNotEmpty) {
      for (var i = 0; i < particleIndices.length; i++) {
        particles[particleIndices[i]].kill(width, height);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TouchDetector(
      touchPointer: touchPointer,
      child: CustomPaint(
        painter: ParticulesPainter(
          controller!,
          particles,
          touchPointer,
          widget.particleSize,
        ),
      ),
    );
  }
}
