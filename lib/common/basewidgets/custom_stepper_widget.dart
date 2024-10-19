
import 'package:flutter/material.dart';

class CustomStepperWidget extends StatelessWidget {
  final bool isActive;
  final bool hasLeftBar;
  final bool hasRightBar;
  final String title;
  final bool rightActive;
  final String? icon;
  const CustomStepperWidget({Key? key, required this.title, required this.isActive, required this.hasLeftBar, required this.hasRightBar,
    required this.rightActive, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _color = isActive ? Theme.of(context).primaryColor : Theme.of(context).disabledColor;
    Color _right = rightActive ? Theme.of(context).primaryColor : Theme.of(context).disabledColor;

    return Expanded(
      child: Column(children: [

        Row(children: [
          Expanded(child: hasLeftBar ? Divider(color: _color, thickness: 2) : const SizedBox()),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isActive ? 0 : 5),
            child: SizedBox(width: 20,child: Image.asset(icon!, color: _color)),
          ),
          Expanded(child: hasRightBar ? Divider(color: _right, thickness: 2) : const SizedBox()),
        ]),


      ]),
    );
  }
}
