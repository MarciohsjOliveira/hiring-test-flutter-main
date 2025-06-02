import 'package:flutter/material.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/home.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/view/widgets/crypto_list_widget.dart';

class HomeBody extends StatelessWidget {
  final HomeController controller;

  const HomeBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const LoadingWidget();
    }

    if (controller.errorMessage != null) {
      return ErrorWidget(
        controller.errorMessage!,
      );
    }

    if (controller.cryptos.isEmpty) {
      return const EmptyWidget();
    }

    return RefreshIndicator(
      onRefresh: () async => controller.refreshData(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.verticalPadding,
        ),
        itemCount: controller.cryptos.length,
        itemBuilder: (context, index) {
          final crypto = controller.cryptos[index];
          return CryptoListItemWidegt(
            crypto: crypto,
          );
        },
      ),
    );
  }
}
