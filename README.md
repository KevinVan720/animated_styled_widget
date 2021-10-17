# animated_styled_widget

Powerful styling, serialization, animation, and custom components all in one place. 

Current features of this package:

1. Let you use a serializable style to design highly customizable StyledContainer widget.
2. Implicit animations with the AnimatedStyledContainer widget.
3. Explicit animations (local/global, timed/scroll based) with the ExplicitAnimatedStyledContainer widget.  
4. Styled Components: StyledButton, StyledToggleButtons, StyledSwitch, StyledRadio, StyledCheckbox, StyledSlider. Your app don't need to look like Material.

Many features of this package is inspired by CSS or follows CSS specifications. If you are familiar with CSS, this package should be even easier to use. 

## What is the Style class?
The style class is a collection of UI data classes.  
It currently supports the following properties:

1. Sizing and Aligning
```dart
Dimension width
Dimension height
Alignment alignment
Alignment childAlignment
EdgeInsets margin
EdgeInsets padding
```
2. Shape and Decoration
```dart
BoxDecorartion backgroundDecoration
BoxDecorartion foregroundDecoration
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
6. Mouse cursor style
```dart
SystemMouseCursor mouseCursor
```

7. Shader and ImageFilter
```dart
Gradient shaderGradient
ImageFilter imageFilter
ImageFilter backdropFilter
```

The Dimension type is from the [dimension](https://pub.dev/packages/dimension) package. It supports both absolute and relative units. You can also combine/nest min/max/clamp functions on Dimension. You can think of this as a supercharged combination of SizedBox and FractionallySizedBox. 

ShapeShadow and MorphableShapeBorder are from the [morphable_shape](https://pub.dev/packages/morphable_shape) package. ShapeShadow supports inset shadows and gradient filling, in addition to what BoxShadow supports. MorpableShapeBorder supports many commonly used shapes, shape morphing, and many more. Check out [fluttershape.com](https://fluttershape.com/) for an interactive demo. 

DynamicTextStyle lets you define font size, letter spacing etc using absolute/relative values. 300% font size means 3 times the default font size. 

SmoothMatrix4 is similar to Matrix4 but ensures that all the transformations can be smoothly animated. It also allows you to use Dimension as translation distances to adapt to different screen sizes. 

The layout model and paint order is shown below:

![Layout model](https://i.imgur.com/HGyFFbc.png)

![Paint order](https://i.imgur.com/TVD00hr.png)

An example of a responsive style:
```dart
Style style=Style(
      alignment: Alignment.center,
      width: 50.toVWLength,
      height: 50.toPercentLength,
      margin: EdgeInsets.symmetric(vertical: 10),
      backgroundDecoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.cyanAccent, Colors.purpleAccent])),
      shapeBorder: RoundedRectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(15.toPXLength))
      );
```

After you have defined a style, use the StyledContainer widget:
```dart
var widget=StyledContainer(
            style: style,
            child: ...
            );
```

## Implicit Animation
Almost every property in the Style class can be animated. See the
following GIF for a demonstration:

![style_demo2](https://i.imgur.com/sAIc6Bs.gif)

![style_demo3](https://i.imgur.com/WoNtrMm.gif)

![style_demo4](https://i.imgur.com/2HvZG4m.gif)

![style_demo5](https://i.imgur.com/y5WISxE.gif)

![style_demo6](https://i.imgur.com/lYD1SFs.gif)

![style_demo7](https://i.imgur.com/97iuDpS.gif)

![style_demo8](https://i.imgur.com/k7BEHOL.gif)

Just replace the StyledContainer with AnimatedStyledContainer and provide a duration and a curve. Notice the animation can not only be triggered by providing a new style/style map, but also by window resizing/screen rotation as long as you provide the appropriate styles.

## Styled Components

Styled components is a selection of UI components with simple logic like button, radio button, toggle button, switch, etc. The Material implementation of those components is great, but the customization ability is quited limited. There are many other packages out there for even more customization, but the customizability is typically limited to color, border radius, sizing, etc. This package gives you much more. 

The Material components animates according to its internal MaterialState like hovered, pressed, selected, etc. So does the styled components. Lets look at the StyleButton's constructor as an example:

```dart
  StyledButton(
      {Key? key,
      this.onPressed,
      required this.style,
      this.hoveredStyle,
      this.pressedStyle,
      this.disabledStyle,
      this.curve = Curves.linear,
      this.duration = const Duration(milliseconds: 100),
      Widget? child});

  StyledButton.builder(
      {Key? key,
      this.onPressed,
      required this.style,
      this.hoveredStyle,
      this.pressedStyle,
      this.disabledStyle,
      this.curve = Curves.linear,
      this.duration = const Duration(milliseconds: 100),
      required this.builder});
```

A button can be in one of the four states: idle, hovered, pressed, disabled. You need to provide the four corresponding styles. Notice only the idle(default) style is required, and the other three will be set to this style if not provided. You can also specify the duration and animation curve for transitioning between different states. The child parameter is the child widget of this button. But you can also provide a builder which can access the internal state of the button:
```dart
builder: (context, state) {
      Widget child;
      switch (state) {
         case StyledState.pressed:
            child = Text("TAPPED", key: UniqueKey());
            break;
                
         default:
            child = Text("TAP ME", key: UniqueKey());
            break;
       }
       return AnimatedSwitcher(
         duration: Duration(milliseconds: 200),
         child: child,
       );
}
```

![style_button](https://i.imgur.com/tOZG9eR.gif)

Above are six different styled buttons that works great with/without a cursor. 

StyledCheckbox is very similar to StyledButton except for that the pressedStyle parameter is replaced by selectedStyle, as checkbox (and other toggleable components) cares about whether itself is selected (not pressed). 

![style_checkbox](https://i.imgur.com/WaIrGH3.gif)

And then there's the StyledRadio:

![style_radio](https://i.imgur.com/widITKe.gif)

And StyledToggleButtons:

![style_toggle_buttons](https://i.imgur.com/HxNYklh.gif)

Notice all those components follow the exact parameter naming schemes as the built-in ones except for the styling part. 

The StyledSwitch and StyledSlider are a little tricker, as now the styling involves two components. For StyledSwitch, you need to provide styling for both the track and the thumb. And the thumb will be aligned to either the left ot right side of the track (if the switch is horizontal). 

![style_switch](https://i.imgur.com/8CANMuZ.gif)

The StyledSlider need styling for the track and thumb as well, but you can also provide styling for the active track and tooltip.

![style_slider](https://i.imgur.com/TsaQqck.gif)

The interface for the slider is not final, I may add more styling paramters in the future.

I have also implemented the StyledNavigationBar and StylePopupMenuButton. You can find demos of all those components in the example app.

The next step may be adding themeing capabilities to the styled components so that people.

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

It is a map between AnimationTrigger and MultiAnimationSequence. Currently supported AnimationTriggers are the following:

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

where AnimationProperty is an enum class corresponding to every animatable property the Style class supports, and AnimationSequence is a list of generic values, durations, delays, and curves that tells us how a certain animation property is evolved. For example:

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
      value: 50.toVWLength)
});
```

will delay 1 second, then animate the width from its current value to 100 px in 200ms, then to 50% screen width in 200ms. You can animate other properties using the same syntax.

![style_demo9](https://i.imgur.com/Gcii4AZ.gif)

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

![style_demo10](https://i.imgur.com/D0qM8tH.gif)

![style_demo10](https://i.imgur.com/12TmQ55.gif)

![style_demo11](https://i.imgur.com/JA0MvRD.gif)

![style_demo12](https://i.imgur.com/NcIPyrf.gif)

### Preset Animation

Now those MultiAnimationSequence stuff looks powerful, but also complicated to code. I’ve prepared some predefined animations for general usages. They are categorized into entrance, attention seeker, and exit. For example, one common entrance animation called SlideInAnimation is defined as:

```dart
class SlideInAnimation extends PresetAnimation {
  final AxisDirection direction;
  final Dimension distance;
  const SlideInAnimation(
      {this.distance = const Length(100, unit: LengthUnit.vmax),
      this.direction = AxisDirection.up,
      Duration duration = const Duration(seconds: 1),
      Duration delay = Duration.zero,
      Curve curve = Curves.linear,
      CustomAnimationControl control = CustomAnimationControl.play})
      : super(duration: duration, delay: delay, curve: curve, control: control);
  ...
}
```

You can configure the slide distance and direction, as well as duration, delay, curve, and control (whether the animation should play once or infinitely). Other predefined animations are:

```dart
FadeInAnimation
ZoomInAnimation
FadeOutAnimation
SlideOutAnimation
ZoomOutAnimation
FlipAnimation
FlashAnimation
PulseAnimation
SwingAnimation
WobbleAnimation
RainbowAnimation
ElevateAnimation
...
```

You can use them like this:

```
Widget widget = ExplicitAnimatedStyledContainer(
  style: style,
  child: child,
  localAnimations: {
  AnimationTrigger.visible: FadeInAnimation().getAnimationSequences()
  }
);
```

Then every time the widget moves into the screen it will fade in (opacity from 0 to 1). Another feature of MultiAnimationSequence is the ability to merge or extend other MultiAnimationSequence. So you can do something like this:

```dart
Widget widget = ExplicitAnimatedStyledContainer(
  style: style,
  child: child,
  localAnimations: {
  AnimationTrigger.visible: FadeInAnimation().getAnimationSequences()..merge(
SlideInAnimation().getAnimationSequences())
  }
);
```

Then the widget will both fade and slide in once it shows up in the viewport. If you use extend, the animation will play one after another. Preset animations make animations much easier to use while still offer you great flexibility.

![style_demo13](https://i.imgur.com/1GXSxxq.gif)

### Global Explicit Animations

If we want to stagger animations across different widgets, we can do that by providing global animations. A global animation contains a map between String and MultiAnimationSequence where the String is the identifier of a widget. You provide all the global animations you want to use in an animation pool. Then you can trigger a global animation like this:

```dart
var animationPool = {
"animation1": GlobalAnimation(sequences: {
"container1" : sequence1,
"container2": sequence2,
...})
}
...
ChangeNotifierProvider<GlobalAnimationNotifier>(
    create: (_) =>
        GlobalAnimationNotifier(animationPool: animationPool), child: child
)
...
Widget widget = ExplicitAnimatedStyledContainer(
  id: "container1",
  style: style,
  child: child,
  globalAnimationIds: {
  AnimationTrigger.visible: "animation1"
  }
);
```

The id does not need to be unique. You can have multiple widgets with the same id so they will all animate under the same global animation. Notice if a widget does not use global animations at all, there is no need for an id.

![style_demo14](https://i.imgur.com/YzSsevQ.gif)

### Other things to notice

The explicit animations uses the [provider](https://pub.dev/packages/provider) and [simple_animation](https://pub.dev/packages/simple_animations) package.

You can programmatically change the state of the animation by calling something like the following inside the child of a ExplicitAnimatedStyledContainer:

```dart
Provider.of<LocalAnimationNotifier>(context, listen: false)
 .updateAnimationStatus(animationSequence, status);
Provider.of<GlobalAnimationNotifier>(context, listen: false)
 .updateAnimationStatus(animationId, status);
```
which will update the animation and its status (like PLAY, STOP, LOOP, etc).

You can also provide callbacks to the AnimationTrigger events along with animations:

```dart
Widget widget = ExplicitAnimatedStyledContainer(
  style: style,
  child: child,
  localAnimations: {
  AnimationTrigger.visible: animationSequence
  },
  onVisible: onVisible,
);
```

## Serialization
The style class can be easily serialized/deserialized:
```
String styleJson=json.encode(style.toJson());
Style newStyle=Style.fromJson(json.decode(styleJson));
```

Classes involved in explicit animations also support serialization. You can basically create and store complex animated components in plain text and load them everywhere.

