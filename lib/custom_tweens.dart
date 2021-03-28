import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class GradientTween extends Tween<Gradient?> {
  /// Provide a begin and end Gradient. To fade between.
  GradientTween({
    Gradient? begin,
    Gradient? end,
  }) : super(begin: begin, end: end);

  @override
  Gradient? lerp(double t) => Gradient.lerp(begin, end, t);
}

class BoxDecorationTween extends Tween<BoxDecoration?> {
  BoxDecorationTween({
    BoxDecoration? begin,
    BoxDecoration? end,
  }) : super(begin: begin, end: end);

  @override
  BoxDecoration? lerp(double t) {
    if (begin == null && end == null) return null;
    if (begin == null) return end!.scale(t);
    if (end == null) return begin!.scale(1.0 - t);
    if (t == 0.0) return begin;
    if (t == 1.0) return end;
    return BoxDecoration(
      color: Color.lerp(begin!.color, end!.color, t),
      gradient: lerpGradientWithColor(
          begin!.gradient, end!.gradient, begin!.color, end!.color, t),
      image: t < 0.5
          ? begin!.image
          : end!.image, // TODO(ianh): cross-fade the image
      border: BoxBorder.lerp(begin!.border, end!.border, t),
      borderRadius:
          BorderRadiusGeometry.lerp(begin!.borderRadius, end!.borderRadius, t),
      boxShadow: BoxShadow.lerpList(begin!.boxShadow, end!.boxShadow, t),

      shape: t < 0.5 ? begin!.shape : end!.shape,
    );
  }
}

Gradient? lerpGradientWithColor(Gradient? beginGradient, Gradient? endGradient,
    Color? beginColor, Color? endColor, double t) {
  if (beginGradient == null) {
    if (endGradient == null) {
      return null;
    } else {
      if (beginColor != null) {
        if (endGradient is LinearGradient) {
          return Gradient.lerp(
              LinearGradient(colors: [beginColor, beginColor]), endGradient, t);
        }
        if (endGradient is RadialGradient) {
          return Gradient.lerp(
              RadialGradient(colors: [beginColor, beginColor]), endGradient, t);
        }
        if (endGradient is SweepGradient) {
          return Gradient.lerp(
              SweepGradient(colors: [beginColor, beginColor]), endGradient, t);
        }
      } else {
        return Gradient.lerp(null, endGradient, t);
      }
    }
  } else {
    if (endGradient == null) {
      if (endColor != null) {
        if (beginGradient is LinearGradient) {
          return Gradient.lerp(
              beginGradient, LinearGradient(colors: [endColor, endColor]), t);
        }
        if (beginGradient is RadialGradient) {
          return Gradient.lerp(
              beginGradient, RadialGradient(colors: [endColor, endColor]), t);
        }
        if (beginGradient is SweepGradient) {
          return Gradient.lerp(
              beginGradient, SweepGradient(colors: [endColor, endColor]), t);
        }
      } else {
        return Gradient.lerp(beginGradient, null, t);
      }
    } else {
      return Gradient.lerp(beginGradient, endGradient, t);
    }
  }
}
