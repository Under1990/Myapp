import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tempapp/appManager/view_manager.dart';

///animation loading ต่างๆ
class ButtonLoading extends StatelessWidget {
  const ButtonLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      alignment: Alignment.center,
      child: LoadingAnimationWidget.hexagonDots(
          color: ColorManager().primaryColor,
          size: 35),
    );
  }
}
