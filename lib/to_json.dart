import 'screen_scope.dart';
import 'style.dart';

extension StyleMapToJson on Map<ScreenScope, Style> {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst =
        this.map((key, value) => MapEntry(key.toJson(), value));
    return rst;
  }
}
