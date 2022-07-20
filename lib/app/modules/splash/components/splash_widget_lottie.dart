import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashWidgetLottie extends StatelessWidget {
  const SplashWidgetLottie(
      {Key? key,
      this.lottieFile = "assets/lotties/gas-station.json",
      this.isNetwork = false,
      this.size = 200,
      this.message})
      : super(key: key);

  final String lottieFile;
  final bool isNetwork;
  final String? message;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: size,
            child: isNetwork
                ? Lottie.network(lottieFile)
                : Lottie.asset(lottieFile),
          ),
          message == null
              ? const SizedBox()
              : Text(
                  message!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
        ],
      ),
    );
  }
}
