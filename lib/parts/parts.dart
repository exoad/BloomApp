import 'package:blosso_mindfulness/bits/bits.dart';
import 'package:flutter/material.dart';

export "profiles.dart";
export "input_carousel.dart";
export 'tracker_carousel.dart';
export "setup_carousel.dart";
export "home.dart";

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
