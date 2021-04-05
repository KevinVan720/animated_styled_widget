import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:responsive_styled_widget/responsive_styled_widget.dart';

///A property that adapts to different screen sizes
///Get the value for the current screen by calling resolve and provide the build context.
class ResponsiveProperty<T> {
  Map<ScreenScope, T>? values;

  ResponsiveProperty(this.values);

  T? resolve(BuildContext context,
      [T? combine(T? previousValue, T? element)?]) {
    T? rst;
    values?.forEach((key, value) {
      if (key.isOfScreenScope(MediaQuery.of(context))) {
        if (combine == null) {
          rst = value;
        } else {
          rst = combine(rst, value);
        }
      }
    });
    return rst;
  }

  ResponsiveProperty.fromJson(Map<String, dynamic> map,
      {T decoder(dynamic element)?}) {
    if (decoder == null) {
      values = map.map((key, value) {
        assert(value is T);
        return MapEntry(parseScreenScope(json.decode(key)), value);
      });
    } else {
      values = map.map((key, value) {
        return MapEntry(parseScreenScope(json.decode(key)), decoder(value));
      });
    }
  }

  dynamic toJson({dynamic encoder(T? element)?}) {
    if (encoder != null) {
      return values?.map(
          (key, value) => MapEntry(json.encode(key.toJson()), encoder(value)));
    } else {
      return values
          ?.map((key, value) => MapEntry(json.encode(key.toJson()), value));
    }
  }
}
