# responsive_styled_widget

Lets you use a serializable style/style map to make responsive and animatable widgets.

## Getting Started

This package is responsive as you can define a styled container that adapts to different screen sizes.

First, we define the screen scope you want to cover:
```dart
var screen1=ScreenScope(minWidth: 100, maxWidth: 500, minHeight:0);
```
or use the predefined screenScopes:
```dart
var mobileScreen=typicalMobileScreenScope;
var tabletScreen=typicalTabletScreenScope;
var desktopScreen=typicalDesktopScreenScope;
```

Then you can define a style map like this:
```dart
Map<ScreenScope, Style> styles={
mobileScreen: mobileStyle,
tabletScreen: tabletStyle,
desktopScreen: desktopStyle,
};
```

## What is the Style class?
The style class is a collection of responsive UI data classes.  
It currently supports the following properties:
1. Sizing and Aligning
```dart
Dimension width
Dimension height
Alignment alignment
Alignment childAlignment
DynamicEdgeInsets margin
DynamicEdgeInsets padding
```
2. Shape and Decoration
```dart
BoxDecorartion backgroundDecoration
List<ShapeShadow> shadows
List<ShapeShadow> insetShadows
MorphableShapeBorder shapeBorder
```
3. Visibility
```dart
bool visible
double opacity
```
4. Transformation
```dart
SmoothMatrix4 transform
Alignment transformAlignment
```
5. Typography
```dart
DynamicTextStyle textStyle
TextAlign textAlign
```
6. Mouse style
```dart
SystemMouseCursor mouseCursor
```

All of the properties that are of type Dimension or named DynamicXXX are fully responsive in the sense that the actual dimensions are calculated based on the size of the widget's parent constraint or the size of the screen, just like CSS.

![Layout model](https://i.imgur.com/HGyFFbc.png)

![Paint order](https://i.imgur.com/bDCjlpr.png)

An example of a responsive style:
```dart
Style style=Style(
      alignment: Alignment.center,
      width: 50.toVWLength,
      height: 50.toPercentLength,
      margin: DynamicEdgeInsets.symmetric(vertical: 10.toPXLength),
      backgroundDecoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.cyanAccent, Colors.purpleAccent])),
      shapeBorder: MorphableShapeBorder(
          shape:RoundedRectangleShape(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(15.toPXLength)),
          borders: RectangleBorders.only(
              top: DynamicBorderSide(
                  gradient: LinearGradient(colors: [
                    Colors.cyanAccent.shade100,
                    Colors.purpleAccent.shade100
                  ]),
                  width: 12),
              bottom: DynamicBorderSide(
                  gradient:
                      LinearGradient(colors: [Colors.cyan, Colors.purple]),
                  width: 28),
              left: DynamicBorderSide(
                  color: Colors.cyanAccent.shade200, width: 12),
              right: DynamicBorderSide(color: Colors.purpleAccent, width: 28)))
          )
      );
```

After you have defined a style, use the StyledContainer widget:
```dart
var widget=StyledContainer(
            style: style,
            child: ...
            );
```dart
which will render something like this:
![style_demo1](https://i.imgur.com/ytv4ToG.png)

You can also pass in a style map:
```dart
var widget=StyledContainer(
            style: styles,
            child: ...
            );
```
and the StyledContainer will determine the actual style to use automatically. If some ScreenScope overlaps, the resolution is similar to CSS: a valid style that comes later in the style map will override the properties of the previous valid style. So you can define a base style that adapts to all screen sizes and provide special styling to certain screen sizes without writing duplicate code.

## Implicit Animation
Almost every property in the Style class can be animated. See the
following GIF for a demonstration:

![style_demo2](https://i.imgur.com/sAIc6Bs.gif)

![style_demo3](https://i.imgur.com/WoNtrMm.gif)

![style_demo4](https://i.imgur.com/2HvZG4m.gif)

![style_demo5](https://i.imgur.com/y5WISxE.gif)

![style_demo6](https://i.imgur.com/lYD1SFs.gif)

![style_demo7](https://i.imgur.com/97iuDpS.gif)

Just replace the StyledContainer with AnimatedStyledContainer and provide a duration and a curve. Notice the animation can not only be triggered by providing a new style/style map, but also by window resizing/screen rotation as long as you provide the appropriate styles.

## Explicit Animation

Implicit animations are easy to use but can not achieve every effect we want. That's when the ExplicitAnimatedStyledContainer comes in:

```dart
Widget widget = ExplicitAnimatedStyledContainer(
  style: style,
  child: child,
  localAnimations: localAnimations,
  globalAnimationIds: globalAnimationIds,
  id: id,
  ...
);
```

You still provide an initial style to the widget, but then you use local/global animations to animate the widget’s style. Let’s first talk about the localAnimations:

```dart
Map<AnimationTrigger, MultiAnimationSequence> localAnimations
```

It is a map between AnimationTrigger and MultiAnimationSequence. Currently supported AnimationTrigger are the following:

```dart
enum AnimationTrigger {
  mouseEnter,
  mouseExit,
  tap,
  visible,
  scroll,
}
```

When a trigger event happens(e.g. you tapped this widget), the corresponding MultiAnimationSequence is fired. A MultiAnimationSequence contains a sequences map:

```dart
Map<AnimationProperty, AnimationSequence> sequences
```

where AnimationProperty is an enum class corresponding to every property the Style class has, and AnimationSequence is a list of generic values, durations, delays, and curves that tells us how a certain animation property is evolved. For example:

```dart
MultiAnimationSequence(sequences: {
AnimationProperty.width: AnimationSequence()
  ..add(
      delay: Duration(seconds: 1),
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
      value: 100.toPXLength)
 ..add(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
      value: 200.toPXLength)
});
```

will delay 1 second, then animate the width from its current value to 100 px in 200ms, then to 200 px in 200ms. You can animate other properties using the same syntax.

![style_demo8](https://i.imgur.com/Gcii4AZ.gif)

The above mouse hover effect is achieved by writing:

```dart
Widget widget = ExplicitAnimatedStyledContainer(
  style: style,
  child: child,
  localAnimations: {
  AnimationTrigger.mouseEnter: enterSequence,
  AnimationTrigger.mouseExit: exitSequence,
  }
);
```

You can have different durations and curves for mouse entering and exiting, and also for different style properties.

Now let's talk about other animation triggers. The AnimationTrigger.tap is easy to understand. The AnimationTrigger.visible is triggered when the widget becomes visible in the viewport (by using the visibility_detector package). The AnimationTrigger.scroll is triggered when the widget is inside a Scrollable (like a ListView). Then the widget will animate according to its position along the scroll direction:

![scroll_progress](https://i.imgur.com/ycwqF0r.png)

The animation progress by default is calculated as shown in the figure above (if scrolled horizontally). But you can also make the animation start/end earlier or later using two percentage offsets.

![style_demo9](https://i.imgur.com/ct1ott8.gif)

![style_demo10](https://i.imgur.com/pvu399i.gif)


## Serialization
The style class can be easily serialized/deserialized:
```
String styleJson=json.encode(style.toJson());
Style newStyle=Style.fromJson(json.decode(styleJson));
```

A style map, as a matter of fact, can also do:
```
String styleJson=json.encode(styles.toJson());
```
and you can call this function to parse a style or a style map:
```
dynamic? parsePossibleStyleMap(Map<String, dynamic>? style)
```
and use the result directly in the StyledContainer class.

All the features mentioned above can be explored in the example app.