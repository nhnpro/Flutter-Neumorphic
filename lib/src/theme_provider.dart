/* nullable */
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

export 'theme.dart';

/// An enum that indicates to the [NeumorphicTheme] which theme to use
/// LIGHT : the light theme (default theme)
/// DARK : the dark theme
/// SYSTEM : will depend on the user's system theme
///
/// @see Brightness
/// @see window.platformBrightness
///
enum UsedTheme { LIGHT, DARK, SYSTEM }

/// A immutable contained by the NeumorhicTheme
/// That will save the current definition of the theme
/// It will be accessible to the childs widgets by an InheritedWidget
class ThemesWrapper {
  final NeumorphicThemeData theme;
  final NeumorphicThemeData darkTheme;
  final UsedTheme usedTheme;

  const ThemesWrapper({
    @required this.theme,
    this.darkTheme,
    this.usedTheme = UsedTheme.SYSTEM,
  });

  bool get useDark =>
      darkTheme != null &&
      (
          //forced to use DARK by user
          usedTheme == UsedTheme.DARK ||
              //The setting indicating the current brightness mode of the host platform. If the platform has no preference, platformBrightness defaults to Brightness.light.
              window.platformBrightness == Brightness.dark);

  NeumorphicThemeData get currentTheme {
    if (useDark) {
      return darkTheme;
    } else {
      return theme;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ThemesWrapper && runtimeType == other.runtimeType && theme == other.theme && darkTheme == other.darkTheme && usedTheme == other.usedTheme;

  @override
  int get hashCode => theme.hashCode ^ darkTheme.hashCode ^ usedTheme.hashCode;

  ThemesWrapper copyWith({
    NeumorphicThemeData theme,
    NeumorphicThemeData darkTheme,
    UsedTheme usedTheme,
  }) {
    return new ThemesWrapper(
      theme: theme ?? this.theme,
      darkTheme: darkTheme ?? this.darkTheme,
      usedTheme: usedTheme ?? this.usedTheme,
    );
  }
}

class ThemeBloc {
  ThemesWrapper _themeWrapper;
  StreamController<ThemesWrapper> _controller = StreamController.broadcast();

  Stream<ThemesWrapper> get stream => _controller.stream;

  ThemeBloc(this._themeWrapper) : assert(_themeWrapper != null);

  bool get isUsingDark => _themeWrapper.useDark;

  void update(ThemesWrapper newValue) {
    _themeWrapper = newValue;
    _controller.sink.add(newValue);
  }

  void dispose() {
    _controller.close();
  }

  ThemesWrapper get themeWrapper => _themeWrapper;

  NeumorphicThemeData get currentTheme => _themeWrapper.currentTheme;

  set currentTheme(NeumorphicThemeData updateThemeData) {
    if (_themeWrapper.useDark) {
      update(_themeWrapper.copyWith(darkTheme: updateThemeData));
    } else {
      update(_themeWrapper.copyWith(theme: updateThemeData));
    }
  }

  UsedTheme get usedTheme => _themeWrapper.usedTheme;

  set usedTheme(UsedTheme value) => update(_themeWrapper.copyWith(usedTheme: usedTheme));
}

/// The NeumorphicTheme (provider)
/// 1. Defines the used neumorphic theme used in child widgets
///
///   @see NeumorphicThemeData
///
///   NeumorphicTheme(
///     theme: NeumorphicThemeData(...),
///     darkTheme: NeumorphicThemeData(...),
///     currentTheme: CurrentTheme.LIGHT,
///     child: ...
///
/// 2. Provide by static methods the current theme
///
///   NeumorphicThemeData theme = NeumorphicTheme.getCurrentTheme(context);
///
/// 3. Provide by static methods the current theme's colors
///
///   Color baseColor = NeumorphicTheme.baseColor(context);
///   Color accent = NeumorphicTheme.accentColor(context);
///   Color variant = NeumorphicTheme.variantColor(context);
///
/// 4. Tells if the current theme is dark
///
///   bool dark = NeumorphicTheme.isUsingDark(context);
///
/// 5. Provides a way to update the current theme
///
///   NeumorphicTheme.of(context).updateCurrentTheme(
///     NeumorphicThemeData(
///       /* new values */
///     )
///   )
///
class NeumorphicTheme extends StatefulWidget {
  final NeumorphicThemeData theme;
  final NeumorphicThemeData darkTheme;
  final Widget child;
  final UsedTheme usedTheme;

  NeumorphicTheme({
    Key key,
    @required this.child,
    this.theme = neumorphicDefaultTheme,
    this.darkTheme = neumorphicDefaultDarkTheme,
    this.usedTheme,
  });

  static ThemeBloc of(BuildContext context) {
    try {
      return Provider.of<ThemeBloc>(context);
    } catch (t) {
      return null; //if no one found
    }
  }

  static bool isUsingDark(BuildContext context) {
    try {
      return of(context).themeWrapper.useDark;
    } catch (t) {
      return false;
    }
  }

  static Color accentColor(BuildContext context) {
    return getCurrentTheme(context).accentColor;
  }

  static Color baseColor(BuildContext context) {
    return getCurrentTheme(context).baseColor;
  }

  static Color variantColor(BuildContext context) {
    return getCurrentTheme(context).variantColor;
  }

  static NeumorphicThemeData getCurrentTheme(BuildContext context) {
    try {
      return NeumorphicTheme.of(context).currentTheme;
    } catch (t) {
      return neumorphicDefaultTheme;
    }
  }

  static Stream<NeumorphicThemeData> listenCurrentTheme(BuildContext context) {
    try {
      return NeumorphicTheme.of(context).stream.map((value) => value.currentTheme);
    } catch (t) {
      return Stream.value(neumorphicDefaultTheme);
    }
  }

  @override
  createState() => _NeumorphicThemeState();
}

class _NeumorphicThemeState extends State<NeumorphicTheme> {
  ThemeBloc _themeBloc;

  @override
  void initState() {
    super.initState();
    _themeBloc = ThemeBloc(ThemesWrapper(
      theme: widget.theme,
      usedTheme: widget.usedTheme,
      darkTheme: widget.darkTheme,
    ));
  }

  @override
  void dispose() {
    _themeBloc.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(NeumorphicTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    _themeBloc.update(ThemesWrapper(
      theme: widget.theme,
      usedTheme: widget.usedTheme,
      darkTheme: widget.darkTheme,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _themeBloc,
      child: widget.child,
    );
  }
}
