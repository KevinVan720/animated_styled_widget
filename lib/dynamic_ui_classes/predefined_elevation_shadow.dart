import 'package:flutter/material.dart';
import 'package:morphable_shape/morphable_shape.dart';

const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12
const Map<int, List<ShapeShadow>> preDefinedShapeShadow =
    <int, List<ShapeShadow>>{
  // The empty list depicts no elevation.
  0: [],

  1: [
    ShapeShadow(
        offset: Offset(0.0, 2.0),
        blurRadius: 1.0,
        spreadRadius: -1.0,
        color: _kKeyUmbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 1.0),
        blurRadius: 1.0,
        spreadRadius: 0.0,
        color: _kKeyPenumbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 1.0),
        blurRadius: 3.0,
        spreadRadius: 0.0,
        color: _kAmbientShadowOpacity),
  ],

  2: [
    ShapeShadow(
        offset: Offset(0.0, 3.0),
        blurRadius: 1.0,
        spreadRadius: -2.0,
        color: _kKeyUmbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 2.0),
        blurRadius: 2.0,
        spreadRadius: 0.0,
        color: _kKeyPenumbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 1.0),
        blurRadius: 5.0,
        spreadRadius: 0.0,
        color: _kAmbientShadowOpacity),
  ],

  3: [
    ShapeShadow(
        offset: Offset(0.0, 3.0),
        blurRadius: 3.0,
        spreadRadius: -2.0,
        color: _kKeyUmbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 3.0),
        blurRadius: 4.0,
        spreadRadius: 0.0,
        color: _kKeyPenumbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 1.0),
        blurRadius: 8.0,
        spreadRadius: 0.0,
        color: _kAmbientShadowOpacity),
  ],

  4: [
    ShapeShadow(
        offset: Offset(0.0, 2.0),
        blurRadius: 4.0,
        spreadRadius: -1.0,
        color: _kKeyUmbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 4.0),
        blurRadius: 5.0,
        spreadRadius: 0.0,
        color: _kKeyPenumbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 1.0),
        blurRadius: 10.0,
        spreadRadius: 0.0,
        color: _kAmbientShadowOpacity),
  ],

  6: [
    ShapeShadow(
        offset: Offset(0.0, 3.0),
        blurRadius: 5.0,
        spreadRadius: -1.0,
        color: _kKeyUmbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 6.0),
        blurRadius: 10.0,
        spreadRadius: 0.0,
        color: _kKeyPenumbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 1.0),
        blurRadius: 18.0,
        spreadRadius: 0.0,
        color: _kAmbientShadowOpacity),
  ],

  8: [
    ShapeShadow(
        offset: Offset(0.0, 5.0),
        blurRadius: 5.0,
        spreadRadius: -3.0,
        color: _kKeyUmbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 8.0),
        blurRadius: 10.0,
        spreadRadius: 1.0,
        color: _kKeyPenumbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 3.0),
        blurRadius: 14.0,
        spreadRadius: 2.0,
        color: _kAmbientShadowOpacity),
  ],

  9: [
    ShapeShadow(
        offset: Offset(0.0, 5.0),
        blurRadius: 6.0,
        spreadRadius: -3.0,
        color: _kKeyUmbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 9.0),
        blurRadius: 12.0,
        spreadRadius: 1.0,
        color: _kKeyPenumbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 3.0),
        blurRadius: 16.0,
        spreadRadius: 2.0,
        color: _kAmbientShadowOpacity),
  ],

  12: [
    ShapeShadow(
        offset: Offset(0.0, 7.0),
        blurRadius: 8.0,
        spreadRadius: -4.0,
        color: _kKeyUmbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 12.0),
        blurRadius: 17.0,
        spreadRadius: 2.0,
        color: _kKeyPenumbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 5.0),
        blurRadius: 22.0,
        spreadRadius: 4.0,
        color: _kAmbientShadowOpacity),
  ],

  16: [
    ShapeShadow(
        offset: Offset(0.0, 8.0),
        blurRadius: 10.0,
        spreadRadius: -5.0,
        color: _kKeyUmbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 16.0),
        blurRadius: 24.0,
        spreadRadius: 2.0,
        color: _kKeyPenumbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 6.0),
        blurRadius: 30.0,
        spreadRadius: 5.0,
        color: _kAmbientShadowOpacity),
  ],

  24: [
    ShapeShadow(
        offset: Offset(0.0, 11.0),
        blurRadius: 15.0,
        spreadRadius: -7.0,
        color: _kKeyUmbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 24.0),
        blurRadius: 38.0,
        spreadRadius: 3.0,
        color: _kKeyPenumbraOpacity),
    ShapeShadow(
        offset: Offset(0.0, 9.0),
        blurRadius: 46.0,
        spreadRadius: 8.0,
        color: _kAmbientShadowOpacity),
  ],
};
