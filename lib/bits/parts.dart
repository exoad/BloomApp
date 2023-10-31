import 'package:blosso_mindfulness/bits/helper.dart';
import 'package:flutter/material.dart';
import 'package:blosso_mindfulness/bits/consts.dart';

class ActionableSlider extends StatefulWidget {
  final void Function(double) consumer;
  final String Function(double)? labelConsumer;
  final double min;
  final double max;
  final int? divisions;
  const ActionableSlider(
      {super.key,
      required this.consumer,
      required this.min,
      required this.max,
      this.divisions,
      this.labelConsumer});

  @override
  State<ActionableSlider> createState() => _ActionableSliderState();
}

class _ActionableSliderState extends State<ActionableSlider> {
  double _sliderVal = 0;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: clampDouble(
          value: _sliderVal, min: widget.min, max: widget.max),
      onChanged: (val) {
        widget.consumer.call(val);
        setState(() {
          _sliderVal = val;
        });
      },
      label: widget.labelConsumer?.call(_sliderVal),
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      allowedInteraction: SliderInteraction.tapAndSlide,
    );
  }
}

class Block extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  final EdgeInsets padding;
  const Block(
      {super.key,
      required this.backgroundColor,
      required this.child,
      required this.padding});

  const Block.claimed(
      {super.key,
      required this.backgroundColor,
      required this.child,
      this.padding = LaF.homeComponentPadding});

  Block.text(
      {super.key,
      required String titleText,
      this.padding = LaF.homeComponentPadding,
      required String subText,
      TextStyle titleTextStyle = LaF.blockTitleTextStyle,
      TextStyle subTextStyle = LaF.blockSubTextStyle,
      Widget? sideLabel,
      required this.backgroundColor})
      : child = sideLabel == null
            ? Text.rich(TextSpan(children: <InlineSpan>[
                TextSpan(text: titleText, style: titleTextStyle),
                TextSpan(text: subText, style: subTextStyle)
              ]))
            : Row(children: [
                sideLabel,
                Text.rich(TextSpan(children: <InlineSpan>[
                  TextSpan(text: titleText, style: titleTextStyle),
                  TextSpan(text: subText, style: subTextStyle)
                ]))
              ]);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: padding,
              child: Container(
                  decoration: ShapeDecoration(
                    color: backgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          LaF.roundedRectBorderRadius),
                    ),
                  ),
                  child: Padding(
                      padding: padding,
                      child: Center(
                        heightFactor: 1,
                        child: child,
                      ))))
        ]);
  }
}
