import 'package:flutter/cupertino.dart';
import 'dart:convert';

const double screenMaxDimension = 100000;

const double mobileScreenWidthTypical = 360;
const double tabletScreenWidthTypical = 600;
const double desktopScreenWidthTypical = 1024.0;

const double mobileScreenWidthLimit = 480.0;
const double tabletScreenWidthLimit = 840.0;
const double desktopScreenWidthLimit = 2000.0;

const typicalMobileScreenScope = ScreenScope(maxWidth: mobileScreenWidthLimit);
const typicalTabletScreenScope = ScreenScope(
    minWidth: mobileScreenWidthLimit, maxWidth: tabletScreenWidthLimit);
const typicalDesktopScreenScope = ScreenScope(minWidth: tabletScreenWidthLimit);

class ScreenScope {
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;

  const ScreenScope({
    this.minWidth = 0.0,
    this.maxWidth = screenMaxDimension,
    this.minHeight = 0.0,
    this.maxHeight = screenMaxDimension,
  }) : assert(minWidth >= 0 &&
            minWidth <= maxWidth &&
            maxWidth <= screenMaxDimension &&
            minHeight >= 0 &&
            minHeight <= maxHeight &&
            maxHeight <= screenMaxDimension);

  static fromJson(Map<String, dynamic> map) {
    double minWidth = map["minWidth"] ?? 0;
    double maxWidth = map["maxWidth"] ?? screenMaxDimension;
    double minHeight = map["minHeight"] ?? 0;
    double maxHeight = map["maxHeight"] ?? screenMaxDimension;
    return ScreenScope(
      maxWidth: maxWidth,
      minWidth: minWidth,
      maxHeight: maxHeight,
      minHeight: minHeight,
    );
  }

  String toJson() {
    var rst = {};
    rst["minWidth"] = minWidth;
    rst["maxWidth"] = maxWidth;
    rst["minHeight"] = minHeight;
    rst["maxHeight"] = maxHeight;

    return json.encode(rst);
  }

  bool isOfScreenScope(MediaQueryData data) {
    Size size = data.size;
    if (minWidth > size.width ||
        minHeight > size.height ||
        maxWidth < size.width ||
        maxHeight < size.height) {
      return false;
    }
    return true;
  }

  @override
  bool operator ==(Object other) {
    if (other is ScreenScope) {
      if (this.minWidth == other.minWidth &&
          this.maxWidth == other.maxWidth &&
          this.minHeight == other.minHeight &&
          this.maxHeight == other.maxHeight) {
        return true;
      }
    }
    return false;
  }

  @override
  int get hashCode => hashValues(minWidth, maxWidth, minHeight, maxHeight);
}
