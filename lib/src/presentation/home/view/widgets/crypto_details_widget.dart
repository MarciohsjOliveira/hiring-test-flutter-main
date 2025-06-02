import 'package:flutter/material.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/domain/domain.dart';


class CryptoDetailsWidget extends StatelessWidget {
  final CryptoAssetEntity crypto;

  const CryptoDetailsWidget({
    required this.crypto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          crypto.mainProductName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppFontSize.sm,
          ),
        ),
        Text(
          crypto.mainProductName,
          style: const TextStyle(
            color: AppColors.gray,
            fontSize: AppFontSize.xs,
          ),
        ),
      ],
    );
  }
}
