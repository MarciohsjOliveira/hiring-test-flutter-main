import 'package:flutter/material.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/domain/domain.dart';

import 'package:intl/intl.dart';

class CryptoPriceInfo extends StatelessWidget {
  final CryptoAssetEntity crypto;

  const CryptoPriceInfo({
    required this.crypto,
  });

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(crypto.currentPrice) ?? 0;
    final formatter = NumberFormat.currency(
      locale: AppStrings.pt,
      symbol: AppStrings.currencyFormat,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatter.format(price),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppFontSize.sm,
          ),
        ),
      ],
    );
  }
}
