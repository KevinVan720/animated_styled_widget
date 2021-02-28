# styled_widget

Lets you use a serializable style/style map to make responsive and animatable widgets.

## Getting Started

This package is responsive as you can define a styled container that adapts to different screen sizes.
First, we define the screen size you want to cover:
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
MorphableShape shape
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

All of the properties that are of type Dimension or type called DynamicXXX are fully responsive in the sense that the actual dimensions are calculated based on the size of the widget or the size of the screen, just like CSS.

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
      shape: RoundedRectangleShape(
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
              );
```

After you have defined a style, use
```
var widget=StyledContainer(
            style: style,
            child: ...
            );
```
which will render something like this:
![style_demo1](https://i.imgur.com/IVOilbI.png)

You can also pass in the style map:
```
var widget=StyledContainer(
            style: styles,
            child: ...
            );
```
and the StyledContainer will determine the actual style to use automatically. If some ScreenScope overlaps, the resolution is similar to CSS as well: the last valid style in the map is used.

## Animation
Almost every property in the Style class can be animated implicitly. See the
following GIF for a demonstration:

Just replace the StyledContainer with AnimatedStyledContainer and provide a duration and a curve. Notice the
animation can not only be triggered by providing a new style/style map, but also by window resize/screen rotation as long as you provide different styles for the before/after screen size.
![style_demo2](https://i.imgur.com/x1pYq0J.gif)

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