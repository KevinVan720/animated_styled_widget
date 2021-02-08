# styled_widget

Lets you use a serializable style/style map to make responsive and animated widgets.

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

All of the properties that is of type Length or a type call DynamicXXX is fully responsive in that the
actual dimension is calculated based on the size of the widget or the size of the screen, just like CSS.

A example of a responsive style:
```
Style style=Style(
        alignment: Alignment.center,
        width: 300.toPXLength,
        height: 300.toPXLength,
        margin: DynamicEdgeInsets.symmetric(vertical: 10.toPXLength),
        backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.amber,
          Colors.red,
        ])),
        borderColor: Colors.redAccent,
        borderThickness: 10,
        shape: PolygonShape(sides: 6, cornerRadius: 20.toPXLength),
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
            fontSize: 3.toVWLength,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent)
        );
```

After you have defined a style or a style map, use
```
var widget=StyledContainer(
            style: style,
            child: ...
            );
```
which will render something like this:
![style_demo1](https://i.imgur.com/00JT5jK.png)

You can also pass in the style map:
```
var widget=StyledContainer(
            style: styles,
            child: ...
            );
```
and the StyledContainer will determine the actual style to use for you. If some ScreenScope overlaps,  
the resolution is similar to CSS as well, the last valid style in the map is used.

