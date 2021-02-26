import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'styled_widget.dart';
import 'screen_scope.dart';
import 'style.dart';

extension SmoothMatrix4OperationTypesToJson on SmoothMatrix4OperationType {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension StyleMapToJson on Map<ScreenScope, Style> {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst =
        this.map((key, value) => MapEntry(key.toJson(), value));
    return rst;
  }
}
