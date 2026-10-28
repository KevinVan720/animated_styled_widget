## [0.0.1] - 02/08/2021

Initial release.

## [0.0.2] - 02/27/2021

Gradient shadows, dimension, morphable shapes...

## [0.0.3] - 02/27/2021

Update README

## [0.0.4] - 02/28/2021

Supports inner shadow

## [0.0.5] - 02/28/2021

Update README

## [0.0.6] - 03/04/2021

Put mouse enter/exit callbacks at container widget level

## [0.0.7] - 03/06/2021

Font size is now based on DefaultTextStyle font size

## [0.0.8] - 03/06/2021

Use shape border instead of shape in style

## [0.0.9] - 03/08/2021

Add predefined material shadows

## [0.1.0] - 03/09/2021

Fix missing two commas

## [0.1.1] - 03/09/2021

Fix inherit text style

## [0.1.2] - 03/09/2021

Update dependence

## [0.1.3] - 03/09/2021

Fix double to int problem

## [0.1.4] - 03/11/2021

Merge explicit animated styled container code

## [0.1.5] - 03/17/2021

Update README

## [0.1.6] - 03/18/2021

Explicit animation parsing

## [0.1.7] - 03/19/2021

ImageFiltered and BackdropFilter support in Style

## [0.1.8] - 03/19/2021

Update README

## [0.1.9] - 03/30/2021

Styled Components!

## [0.2.0] - 04/03/2021

Update morphable shape dependence

## [0.2.1] - 04/05/2021

Rename to animated_styled_container

## [0.2.2] - 04/06/2021

Remove responsive features to a separate package

## [0.2.3] - 04/06/2021

Add StyledNavigationBar

## [0.2.4] - 04/08/2021

Refactor the constructors of styled components

## [0.2.5] - 04/17/2021

Code restructure

## [0.2.6] - 04/19/2021

Use a mixin instead of a single class

## [0.2.7] - 04/21/2021

Move the DimensionSizedBox to the dimension package

## [0.2.8] - 04/22/2021

Update dependence

## [0.2.9] - 05/09/2021

Update license

## [0.3.0] - 10/18/2021

Update dependence and remove some redundant code.
animated_styled_container
## [0.3.1] - 02/18/2022

Update dependencies.

## [0.3.2] - 02/22/2022

Update dependencies.

## [0.3.3] - 02/22/2022

Update dependencies.

## [0.3.4] - 02/22/2022

Remove a redundant print statement;

## [0.3.5] - 03/11/2022

Let the styled slider able to contain the thumb within itself;

## [0.3.6] - 03/11/2022

Update dependencies.

## [0.3.7] - 03/16/2022

Update dependencies.

## [0.3.8] - 03/16/2022

Update dependencies.

## [0.3.9] - 03/16/2022

Update dependencies.

## [0.4.0] - 03/16/2022

Update dependencies.

## [0.4.1] - 03/18/2022

Decoration can be not just BoxDecoration.

## [0.4.2] - 03/21/2022

Update dependencies.

## [0.4.3] - 03/22/2022

Update dependencies.

## [0.4.4] - 03/22/2022

Update dependencies.

## [0.4.5] - 03/22/2022

Update dependencies.

## [0.4.6] - 03/22/2022

Update dependencies.

## [0.4.7] - 05/12/2023

Update dependencies.

## [0.5.0] - 12/21/2024

Update dependencies.

## [0.5.1] - 10/28/2026

Support the latest Flutter stable (requires Flutter 3.27 / Dart 3.6 or newer): fixes the compile error on Flutter 3.27 and newer (`hashList` was removed, #5) and replaces deprecated Flutter APIs.
The package only uses the Flutter widgets library, except for StyledPopupMenuButton, which is built on the material popup menu.
Update dependencies (morphable_shape 2.0.1, dimension 0.2.1, flutter_class_parser 0.2.6). The JSON format is unchanged.

Fixes:
- The steps of an AnimationSequence play one after another again (since 0.4.7 they all started at the same time), so multi-step explicit animations and the Flash, Pulse, Swing, Wobble and Rainbow animations work as documented.
- Width, height and foregroundDecoration animations of ExplicitAnimatedStyledContainer take effect.
- Entrance animations (e.g. FadeIn, SlideIn) no longer show the widget without the animation for one frame.
- Playing an explicit animation no longer modifies its MultiAnimationSequence, so it uses the current values when played again and its JSON does not change.
- MultiAnimationSequence.extend no longer modifies the other animation and accepts empty sequences, addDelay and rescaleTime no longer throw for empty sequences or animations without duration.
- Animating a text style no longer throws "Failed to interpolate TextStyles with different inherit values" when the surrounding text style does not inherit (e.g. inside a Scaffold).
- Scroll animations no longer leak scroll listeners when the widget is removed.
- The onMouseEnter callback of ExplicitAnimatedStyledContainer is no longer called twice when a mouse enter animation starts.
- Style, DynamicTextStyle and SmoothMatrix4 have value equality (styles with equal shadows, transforms or text styles were not equal).
- The styles of a NamedStyleMap are applied to the widgets with their id.
- JSON parsing tolerates missing keys and whole numbers written as ints (e.g. by Flutter web), Style.fromJson accepts the output of toJson without encoding it, text styles keep their font weight (w100 to w900) and no longer get a normal font weight and style when none is given, and animations of shadows are serialized (they were written as null).
- SmoothMatrix4 operations without values no longer throw.
- presetEntranceAnimations no longer contains the exit and attention seeker animations after presetAllAnimations is used.
- The styled components use their key (it was ignored).
- StyledSwitch uses the size of the hovered and disabled (and in vertical direction the selected) track styles, and no longer modifies the thumb styles.
- StyledSlider shows the disabled thumb style from the start, follows value changes of its parent, no longer modifies the thumb style, removes its tooltip when it is removed and no longer prints debug output.
- StyledPopupMenuButton calls onSelected (instead of onCanceled) when the initially selected item is selected again, and disabled items can not be selected and use their disabled style.
- ContinuousAnimationProgressNotifier notifies its listeners once per change.

Add tests.
