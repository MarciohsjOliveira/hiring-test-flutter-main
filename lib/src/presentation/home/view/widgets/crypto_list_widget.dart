import 'package:flutter/material.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/domain/domain.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/home.dart';

class CryptoListItemWidegt extends StatelessWidget {
  final CryptoAssetEntity crypto;

  const CryptoListItemWidegt({
    super.key,
    required this.crypto,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = crypto.priceVariation24h >= 0;
    final variationColor = isUp ? AppColors.green : AppColors.red;

    return Card(
      elevation: AppDimensions.cardElevation,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding,
        vertical: AppDimensions.verticalPadding,
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          AppDimensions.horizontalPadding,
        ),
        child: Row(
          children: [
            CryptoImageWidget(
              instrumentId: crypto.instrumentId.toString(),
            ),
            const SizedBox(
              width: AppDimensions.horizontalPadding,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: CryptoDetailsWidget(crypto: crypto),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isUp ? Icons.add : Icons.remove,
                    color: variationColor,
                    size: AppFontSize.xs,
                  ),
                  const SizedBox(width: AppDimensions.space4),
                  Text(
                    crypto.priceVariation24h.abs().toStringAsFixed(2),
                    style: TextStyle(
                      color: variationColor,
                      fontSize: AppFontSize.xs,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: AppDimensions.horizontalPadding,
            ),
            Expanded(
              child: CryptoPriceInfo(
                crypto: crypto,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
