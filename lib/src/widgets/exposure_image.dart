import 'package:flutter/widgets.dart';
import 'package:image_exposure/src/widgets/raw_exposure_image.dart';

class ExposureImage extends StatelessWidget {
  final ImageProvider<Object> image;

  final ImageErrorListener? onImageError;

  final double touchRadius;
  final double particleRadius;

  const ExposureImage({
    Key? key,
    required this.image,
    this.onImageError,
    this.touchRadius = 100,
    this.particleRadius = 8,
    // ignore: unnecessary_null_comparison
  })  : assert(image != null),
        assert(
          // ignore: unnecessary_null_comparison
          touchRadius != null,
          'touchRadius must be set, to disable the touch, set it to 0 instead',
        ),
        // ignore: unnecessary_null_comparison
        assert(particleRadius != null && particleRadius > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return SizedBox.expand(
          child: RawExposureImage(
            provider: image,
            onError: onImageError!,
            configuration: createLocalImageConfiguration(context),
            size: constraints.biggest,
            touchSize: touchRadius,
            particleSize: particleRadius,
          ),
        );
      },
    );
  }
}
