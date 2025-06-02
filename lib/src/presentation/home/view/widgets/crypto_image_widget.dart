import 'package:flutter/material.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';

class CryptoImageWidget extends StatelessWidget {
  final String instrumentId;

  const CryptoImageWidget({
    required this.instrumentId,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$instrumentId.png',
      width: AppDimensions.iconSize,
      height: AppDimensions.iconSize,
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.currency_bitcoin,
        size: AppDimensions.iconSize,
        color: AppColors.yellow,
      ),
    );
  }
}
