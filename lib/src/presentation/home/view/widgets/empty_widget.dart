import 'package:flutter/material.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
       AppStrings.noCoinsAvailableMessage,
        style: TextStyle(
          fontSize: AppFontSize.sm,
          color: AppColors.gray,
        ),
      ),
    );
  }
}
