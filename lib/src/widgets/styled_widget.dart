import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/widgets.dart';

/// A widget that is styled by a [Style].
abstract class StyledWidget extends StatefulWidget {
  /// The id of the style of this widget in an ancestor [NamedStyleMap]. Also
  /// used by the global animations of an [ExplicitAnimatedStyledContainer].
  final String? id;
  final Style style;
  const StyledWidget({
    super.key,
    this.id,
    required this.style,
  });
}

abstract class StyledWidgetState<T extends StyledWidget> extends State<T>
    with StyledStateMixin {
  /// Resolves the [style]: the style of the widget merged with the style of
  /// its [StyledWidget.id] in an ancestor [NamedStyleMap].
  @override
  void resolveStyle() {
    screenSize = MediaQuery.sizeOf(context);
    Style? inheritedStyle;
    if (widget.id != null) {
      final NamedStyleMap? namedStyles = NamedStyleMap.of(context);
      inheritedStyle = namedStyles?.styles[widget.id];
    }
    style = widget.style.merge(inheritedStyle);
  }
}
