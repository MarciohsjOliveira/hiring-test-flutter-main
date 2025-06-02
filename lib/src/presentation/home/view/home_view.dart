import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/src/core/core.dart';
import 'package:foxbit_hiring_test_template/src/presentation/home/home.dart';

class HomePage extends CleanView {
  const HomePage();

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends CleanViewState<HomePage, HomeController> {
  HomePageState() : super(HomeController());

  @override
  Widget get view {
    return ControlledWidgetBuilder<HomeController>(
      builder: (context, controller) {
        return Scaffold( 
          appBar: AppBar(
            elevation: AppDimensions.elevateOne,
            title: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.appTitleHome,
                style: TextStyle(
                  color: AppColors.black,
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          body: HomeBody(
            controller: controller,
          ),
        );
      },
    );
  }
}
