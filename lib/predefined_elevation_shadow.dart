import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';

import 'styled_widget.dart';

const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12
const Map<int, List<DynamicShapeShadow>> preDefinedDynamicShapeShadow =
    <int, List<DynamicShapeShadow>>{
  // The empty list depicts no elevation.
  0: [],

  1: [
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(2.0)),
        blurRadius: Length(1.0),
        spreadRadius: Length(-1.0),
        color: _kKeyUmbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(1.0)),
        blurRadius: Length(1.0),
        spreadRadius: Length(0.0),
        color: _kKeyPenumbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(1.0)),
        blurRadius: Length(3.0),
        spreadRadius: Length(0.0),
        color: _kAmbientShadowOpacity),
  ],

  2: [
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(3.0)),
        blurRadius: Length(1.0),
        spreadRadius: Length(-2.0),
        color: _kKeyUmbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(2.0)),
        blurRadius: Length(2.0),
        spreadRadius: Length(0.0),
        color: _kKeyPenumbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(1.0)),
        blurRadius: Length(5.0),
        spreadRadius: Length(0.0),
        color: _kAmbientShadowOpacity),
  ],

  3: [
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(3.0)),
        blurRadius: Length(3.0),
        spreadRadius: Length(-2.0),
        color: _kKeyUmbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(3.0)),
        blurRadius: Length(4.0),
        spreadRadius: Length(0.0),
        color: _kKeyPenumbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(1.0)),
        blurRadius: Length(8.0),
        spreadRadius: Length(0.0),
        color: _kAmbientShadowOpacity),
  ],

  4: [
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(2.0)),
        blurRadius: Length(4.0),
        spreadRadius: Length(-1.0),
        color: _kKeyUmbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(4.0)),
        blurRadius: Length(5.0),
        spreadRadius: Length(0.0),
        color: _kKeyPenumbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(1.0)),
        blurRadius: Length(10.0),
        spreadRadius: Length(0.0),
        color: _kAmbientShadowOpacity),
  ],

  6: [
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(3.0)),
        blurRadius: Length(5.0),
        spreadRadius: Length(-1.0),
        color: _kKeyUmbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(6.0)),
        blurRadius: Length(10.0),
        spreadRadius: Length(0.0),
        color: _kKeyPenumbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(1.0)),
        blurRadius: Length(18.0),
        spreadRadius: Length(0.0),
        color: _kAmbientShadowOpacity),
  ],

  8: [
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(5.0)),
        blurRadius: Length(5.0),
        spreadRadius: Length(-3.0),
        color: _kKeyUmbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(8.0)),
        blurRadius: Length(10.0),
        spreadRadius: Length(1.0),
        color: _kKeyPenumbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(3.0)),
        blurRadius: Length(14.0),
        spreadRadius: Length(2.0),
        color: _kAmbientShadowOpacity),
  ],

  9: [
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(5.0)),
        blurRadius: Length(6.0),
        spreadRadius: Length(-3.0),
        color: _kKeyUmbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(9.0)),
        blurRadius: Length(12.0),
        spreadRadius: Length(1.0),
        color: _kKeyPenumbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(3.0)),
        blurRadius: Length(16.0),
        spreadRadius: Length(2.0),
        color: _kAmbientShadowOpacity),
  ],

  12: [
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(7.0)),
        blurRadius: Length(8.0),
        spreadRadius: Length(-4.0),
        color: _kKeyUmbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(12.0)),
        blurRadius: Length(17.0),
        spreadRadius: Length(2.0),
        color: _kKeyPenumbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(5.0)),
        blurRadius: Length(22.0),
        spreadRadius: Length(4.0),
        color: _kAmbientShadowOpacity),
  ],

  16: [
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(8.0)),
        blurRadius: Length(10.0),
        spreadRadius: Length(-5.0),
        color: _kKeyUmbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(16.0)),
        blurRadius: Length(24.0),
        spreadRadius: Length(2.0),
        color: _kKeyPenumbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(6.0)),
        blurRadius: Length(30.0),
        spreadRadius: Length(5.0),
        color: _kAmbientShadowOpacity),
  ],

  24: [
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(11.0)),
        blurRadius: Length(15.0),
        spreadRadius: Length(-7.0),
        color: _kKeyUmbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(24.0)),
        blurRadius: Length(38.0),
        spreadRadius: Length(3.0),
        color: _kKeyPenumbraOpacity),
    DynamicShapeShadow(
        offset: DynamicOffset(Length(0.0), Length(9.0)),
        blurRadius: Length(46.0),
        spreadRadius: Length(8.0),
        color: _kAmbientShadowOpacity),
  ],
};
