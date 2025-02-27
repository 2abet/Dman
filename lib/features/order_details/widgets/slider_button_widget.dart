
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:vibration/vibration.dart';

class SliderButtonWidget extends StatefulWidget {
  final Widget? child;
  final double radius;
  final double height;
  final double width;
  final double buttonSize;
  final Color backgroundColor;
  final Color baseColor;
  final Color highlightedColor;
  final Color buttonColor;
  final Text label;
  final Alignment alignLabel;
  final BoxShadow boxShadow;
  final Widget icon;
  final Function action;
  final bool shimmer;
  final bool dismissible;
  final bool vibrationFlag;
  final bool isRtl;
  final double dismissThresholds;

  final bool disable;
  const SliderButtonWidget({Key? key,
    required this.action,
    this.radius = 100,
    this.boxShadow = const BoxShadow(
      color: Colors.black,
      blurRadius: 4,
    ),
    this.child,
    this.vibrationFlag = true,
    this.shimmer = true,
    this.height = 50,
    this.buttonSize = 50,
    this.width = 1200,
    this.alignLabel = const Alignment(0.2, 0),
    this.backgroundColor = const Color(0xffe0e0e0),
    this.baseColor = Colors.black87,
    this.buttonColor = Colors.white,
    this.highlightedColor = Colors.white,
    this.label = const Text(
      "Slide to cancel !",
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
    ),
    this.icon = const Icon(
      Icons.power_settings_new,
      color: Colors.red,
      size: 30.0,
      semanticLabel: 'Text to announce in accessibility modes',
    ),
    this.dismissible = true,
    this.dismissThresholds = 1.0,
    this.disable = false, this.isRtl = false,
  }) : assert(buttonSize <= height), super(key: key);

  @override
  _SliderButtonWidgetState createState() => _SliderButtonWidgetState();
}

class _SliderButtonWidgetState extends State<SliderButtonWidget> {
  bool? flag;

  @override
  void initState() {
    super.initState();
    flag = true;
  }

  @override
  Widget build(BuildContext context) {
    return flag == true ?
    _control() :
    widget.dismissible == true ?
    Container() : Container(child: _control(),);
  }

  Widget _control() => Container(
    height: widget.height,
    width: widget.width,
    decoration: BoxDecoration(color:
        widget.disable ?
        Colors.grey.shade700 : widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.radius)),
    alignment: Alignment.centerLeft,


    child: Stack(
      alignment: widget.isRtl ? Alignment.centerRight : Alignment.centerLeft,
      children: <Widget>[
        Container(alignment: widget.alignLabel,
          child: widget.shimmer && !widget.disable ?
          Shimmer.fromColors(baseColor: widget.disable ?
            Colors.grey : widget.baseColor,
            highlightColor: widget.highlightedColor,
            child: widget.label) :
          widget.label),

        widget.disable ? Tooltip(verticalOffset: 50,
          message: 'Button is disabled',


          child: Container(width: widget.width - (widget.height),
            height: widget.height,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: (widget.height - widget.buttonSize) / 2+ 140,),
            child: widget.child ?? Container(height: widget.buttonSize,
              width: widget.buttonSize,
              decoration: BoxDecoration(boxShadow: [widget.boxShadow,],
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(widget.radius)),
                  child: Center(child: widget.icon)))) :

        Dismissible(key: const Key("cancel"),
          direction:
          // widget.isRtl ?  DismissDirection.endToStart :
          DismissDirection.startToEnd,
          dismissThresholds: {
           // widget.isRtl ?  DismissDirection.endToStart :
            DismissDirection.startToEnd : widget.dismissThresholds
          },

          ///gives direction of swipping in argument.
          onDismissed: (dir) async {
            setState(() {
              if (widget.dismissible) {
                flag = false;
              } else {
                flag = !flag!;
              }
            });

            widget.action();
            if (widget.vibrationFlag) {
              try {
                Vibration.vibrate(duration: 200);
              } catch (e) {
                // ignore: avoid_print
                print(e);
              }
            }
          },


          child: Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Container(width: widget.width - (widget.height),
              height: widget.height,
              alignment: widget.isRtl ? Alignment.centerRight : Alignment.centerLeft,
               padding: EdgeInsets.only(left: (widget.height - widget.buttonSize) / 2),
              child: widget.child ??
                  Container(height: widget.buttonSize,
                    width: widget.buttonSize,
                    decoration: BoxDecoration(
                        boxShadow: [widget.boxShadow,],
                        color: widget.buttonColor,
                        borderRadius: BorderRadius.circular(widget.radius)),
                    child: Center(child: widget.icon))))),


        const SizedBox.expand(),
      ],
    ),
  );
}