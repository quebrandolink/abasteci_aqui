import 'package:flutter/material.dart';
import 'package:fuel_manager/app/shared/helpers/theme/values/values.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({Key? key, this.height = 20, this.width = 20})
      : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Theme.of(context).highlightColor,
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(Sizes.DIVISIONS / 2),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius:
                const BorderRadius.all(Radius.circular(Sizes.DIVISIONS))),
      ),
    );
// Container(
//       height: height,
//       width: width,
//       padding: const EdgeInsets.all(Sizes.DIVISIONS / 2),
//       decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.04),
//           borderRadius:
//               const BorderRadius.all(Radius.circular(Sizes.DIVISIONS))),
//     );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 24}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}
