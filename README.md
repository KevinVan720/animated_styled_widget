# styled_widget

Lets you use a serializable style/style map to make responsive and animatable widgets.

## Getting Started

This package is responsive as you can define a styled container that adapts to different screen sizes.
First, we define the screen size you want to cover:
```
var screen1=ScreenScope(minWidth: 100, maxWidth: 500, minHeight:0);
```
or use the predefined screenScopes:
```
var mobileScreen=typicalMobileScreenScope;
var tabletScreen=typicalTabletScreenScope;
var desktopScreen=typicalDesktopScreenScope;
```

Then you can define a style map like this:
```
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
```
Length width
Length height
Length minWidth
Length minHeight
Length maxWidth
Length maxHeight
Alignment alignment
Alignment childAlignment
DynamicEdgeInsets margin
DynamicEdgeInsets padding
```
2. Shape and Decoration
```
BoxDecorartion backgroundDecoration
Color borderColor
double borderThickness
List<Shadow> shadows
MorphableShape shape
```
3. Visibility
```
bool visible
double opacity
```
4. Transformation
```
double rotationX
double rotationY
double rotationZ
double skewX
double skewY
double translationX
double translationY
```
5. Typography
```
DynamicTextStyle textStyle
TextAlign textAlign
```

All of the properties that are of type Length or type called DynamicXXX are fully responsive in the sense  
that the actual dimensions are calculated based on the size of the widget or the size of the screen, just like CSS.

An example of a responsive style:
```
Style style=Style(
        alignment: Alignment.center,
        width: 30.toPercentLength, //30% of the parent constraint with
        height: 30.toVHLength, //30% of the screen height
        margin: DynamicEdgeInsets.symmetric(vertical: 10.toPXLength),
        backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.amber,
          Colors.red,
        ])),
        borderColor: Colors.redAccent,
        borderThickness: 10,
        shape: PolygonShape(sides: 6, cornerRadius: 20.toPercentLength),
        shadows: [
          DynamicBoxShadow(
              blurRadius: 10.toPXLength,
              color: Colors.grey,
              offset: DynamicOffset(10.toPXLength, 10.toPXLength))
        ],
        translationX: 50,
        translationY: -100,
        childAlignment: Alignment.centerLeft,
        opacity: 0.8,
        textStyle: DynamicTextStyle(
            fontSize: 3.toVWLength, //3% of the screen width
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent)
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
![style_demo1](https://i.imgur.com/iwrqDVS.png)

You can also pass in the style map:
```
var widget=StyledContainer(
            style: styles,
            child: ...
            );
```
and the StyledContainer will determine the actual style to use automatically. If some ScreenScope overlaps,  
the resolution is similar to CSS as well: the last valid style in the map is used.

## Animation
Almost every property in the Style class can be animated implicitly  
(rotation or skew are not supported by Matrix4Tween right now). See the
following GIF for a demonstration:

Just replace the StyledContainer with AnimatedStyledContainer and provide a duration and a curve. Notice the
animation can not only be triggered by providing a new style/style map, but also by window resize/screen rotation  
as long as you provide different styles for the before/after screen size.
![style_demo2](https://i.imgur.com/eWazcer.gif)

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