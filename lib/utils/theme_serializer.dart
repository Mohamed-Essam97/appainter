import 'dart:convert';
import 'package:flutter/material.dart';

/// Custom theme serialization utility to replace json_theme functionality
class ThemeSerializer {
  /// Converts a Color to hex string format (e.g., "#ff36618e")
  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  /// Converts a ThemeData object to a JSON string
  static String encodeThemeData(ThemeData theme) {
    final Map<String, dynamic> themeMap = {
      'brightness': theme.brightness.name,
      'primaryColor': _colorToHex(theme.primaryColor),
      'scaffoldBackgroundColor': _colorToHex(theme.scaffoldBackgroundColor),
      'canvasColor': _colorToHex(theme.canvasColor),
      'cardColor': _colorToHex(theme.cardColor),
      'dividerColor': _colorToHex(theme.dividerColor),
      'focusColor': _colorToHex(theme.focusColor),
      'hoverColor': _colorToHex(theme.hoverColor),
      'highlightColor': _colorToHex(theme.highlightColor),
      'splashColor': _colorToHex(theme.splashColor),
      'unselectedWidgetColor': _colorToHex(theme.unselectedWidgetColor),
      'disabledColor': _colorToHex(theme.disabledColor),
      'dialogBackgroundColor': _colorToHex(theme.dialogBackgroundColor),
      'indicatorColor': _colorToHex(theme.indicatorColor),
      'hintColor': _colorToHex(theme.hintColor),
      'errorColor': _colorToHex(theme.colorScheme.error),
      'materialTapTargetSize': theme.materialTapTargetSize.name,
      
      // ColorScheme
      'colorScheme': {
        'brightness': theme.colorScheme.brightness.name,
        'primary': _colorToHex(theme.colorScheme.primary),
        'onPrimary': _colorToHex(theme.colorScheme.onPrimary),
        'secondary': _colorToHex(theme.colorScheme.secondary),
        'onSecondary': _colorToHex(theme.colorScheme.onSecondary),
        'error': _colorToHex(theme.colorScheme.error),
        'onError': _colorToHex(theme.colorScheme.onError),
        'surface': _colorToHex(theme.colorScheme.surface),
        'onSurface': _colorToHex(theme.colorScheme.onSurface),
        'tertiary': _colorToHex(theme.colorScheme.tertiary),
        'onTertiary': _colorToHex(theme.colorScheme.onTertiary),
        'background': _colorToHex(theme.colorScheme.background),
        'onBackground': _colorToHex(theme.colorScheme.onBackground),
      },
      
      // AppBar Theme
      'appBarTheme': {
        'backgroundColor': _colorToHex(theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface),
        'foregroundColor': _colorToHex(theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface),
        'elevation': theme.appBarTheme.elevation ?? 4.0,
        'shadowColor': _colorToHex(theme.appBarTheme.shadowColor ?? theme.shadowColor),
        'surfaceTintColor': _colorToHex(theme.appBarTheme.surfaceTintColor ?? theme.colorScheme.surfaceTint),
        'centerTitle': theme.appBarTheme.centerTitle ?? false,
      },
      
      // Button Theme
       'buttonTheme': {
         'textTheme': theme.buttonTheme.textTheme.name,
         'minWidth': theme.buttonTheme.minWidth,
         'height': theme.buttonTheme.height,
         'padding': theme.buttonTheme.padding is EdgeInsets ? {
           'left': (theme.buttonTheme.padding as EdgeInsets).left,
           'top': (theme.buttonTheme.padding as EdgeInsets).top,
           'right': (theme.buttonTheme.padding as EdgeInsets).right,
           'bottom': (theme.buttonTheme.padding as EdgeInsets).bottom,
         } : null,
         'shape': theme.buttonTheme.shape?.runtimeType.toString(),
         'alignedDropdown': theme.buttonTheme.alignedDropdown,
         'layoutBehavior': theme.buttonTheme.layoutBehavior.name,
         'colorScheme': theme.buttonTheme.colorScheme != null ? {
           'primary': _colorToHex(theme.buttonTheme.colorScheme!.primary),
           'secondary': _colorToHex(theme.buttonTheme.colorScheme!.secondary),
         } : null,
       },
      
      // Elevated Button Theme
      'elevatedButtonTheme': {
        'style': {
          'backgroundColor': _colorToHex(theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}) ?? theme.colorScheme.primary),
          'foregroundColor': _colorToHex(theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}) ?? theme.colorScheme.onPrimary),
          'elevation': theme.elevatedButtonTheme.style?.elevation?.resolve({}) ?? 2.0,
        },
      },
      
      // Outlined Button Theme
      'outlinedButtonTheme': {
        'style': {
          'backgroundColor': _colorToHex(theme.outlinedButtonTheme.style?.backgroundColor?.resolve({}) ?? Colors.transparent),
          'foregroundColor': _colorToHex(theme.outlinedButtonTheme.style?.foregroundColor?.resolve({}) ?? theme.colorScheme.primary),
          'elevation': theme.outlinedButtonTheme.style?.elevation?.resolve({}) ?? 0.0,
        },
      },
      
      // Text Button Theme
      'textButtonTheme': {
        'style': {
          'backgroundColor': _colorToHex(theme.textButtonTheme.style?.backgroundColor?.resolve({}) ?? Colors.transparent),
          'foregroundColor': _colorToHex(theme.textButtonTheme.style?.foregroundColor?.resolve({}) ?? theme.colorScheme.primary),
          'elevation': theme.textButtonTheme.style?.elevation?.resolve({}) ?? 0.0,
        },
      },
      
      // Icon Button Theme
      'iconButtonTheme': {
        'style': {
          'backgroundColor': _colorToHex(theme.iconButtonTheme.style?.backgroundColor?.resolve({}) ?? Colors.transparent),
          'foregroundColor': _colorToHex(theme.iconButtonTheme.style?.foregroundColor?.resolve({}) ?? theme.colorScheme.onSurface),
          'elevation': theme.iconButtonTheme.style?.elevation?.resolve({}) ?? 0.0,
        },
      },
      
      // Floating Action Button Theme
      'floatingActionButtonTheme': {
        'backgroundColor': _colorToHex(theme.floatingActionButtonTheme.backgroundColor ?? theme.colorScheme.primary),
        'foregroundColor': _colorToHex(theme.floatingActionButtonTheme.foregroundColor ?? theme.colorScheme.onPrimary),
        'splashColor': _colorToHex(theme.floatingActionButtonTheme.splashColor ?? theme.splashColor),
        'focusColor': _colorToHex(theme.floatingActionButtonTheme.focusColor ?? theme.focusColor),
        'hoverColor': _colorToHex(theme.floatingActionButtonTheme.hoverColor ?? theme.hoverColor),
        'elevation': theme.floatingActionButtonTheme.elevation ?? 6.0,
        'focusElevation': theme.floatingActionButtonTheme.focusElevation ?? 8.0,
        'hoverElevation': theme.floatingActionButtonTheme.hoverElevation ?? 8.0,
        'disabledElevation': theme.floatingActionButtonTheme.disabledElevation ?? 0.0,
        'highlightElevation': theme.floatingActionButtonTheme.highlightElevation ?? 12.0,
      },
      
      // Card Theme
      'cardTheme': {
        'clipBehavior': theme.cardTheme.clipBehavior?.name ?? 'none',
        'color': _colorToHex(theme.cardTheme.color ?? theme.colorScheme.surface),
        'shadowColor': _colorToHex(theme.cardTheme.shadowColor ?? theme.shadowColor),
        'surfaceTintColor': _colorToHex(theme.cardTheme.surfaceTintColor ?? theme.colorScheme.surfaceTint),
        'elevation': theme.cardTheme.elevation ?? 1.0,
        'margin': theme.cardTheme.margin is EdgeInsets ? {
          'left': (theme.cardTheme.margin as EdgeInsets).left,
          'top': (theme.cardTheme.margin as EdgeInsets).top,
          'right': (theme.cardTheme.margin as EdgeInsets).right,
          'bottom': (theme.cardTheme.margin as EdgeInsets).bottom,
        } : {'left': 4.0, 'top': 4.0, 'right': 4.0, 'bottom': 4.0},
        'shape': theme.cardTheme.shape?.runtimeType.toString() ?? 'RoundedRectangleBorder',
      },
      
      // Dialog Theme
      'dialogTheme': {
        'backgroundColor': _colorToHex(theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface),
        'elevation': theme.dialogTheme.elevation ?? 24.0,
        'shadowColor': _colorToHex(theme.dialogTheme.shadowColor ?? theme.shadowColor),
        'surfaceTintColor': _colorToHex(theme.dialogTheme.surfaceTintColor ?? theme.colorScheme.surfaceTint),
      },
      
      // Divider Theme
      'dividerTheme': {
        'color': _colorToHex(theme.dividerTheme.color ?? theme.dividerColor),
        'space': theme.dividerTheme.space ?? 16.0,
        'thickness': theme.dividerTheme.thickness ?? 0.0,
        'indent': theme.dividerTheme.indent ?? 0.0,
        'endIndent': theme.dividerTheme.endIndent ?? 0.0,
      },
      
      // Bottom Navigation Bar Theme
      'bottomNavigationBarTheme': {
        'backgroundColor': _colorToHex(theme.bottomNavigationBarTheme.backgroundColor ?? theme.canvasColor),
        'elevation': theme.bottomNavigationBarTheme.elevation ?? 8.0,
        'selectedItemColor': _colorToHex(theme.bottomNavigationBarTheme.selectedItemColor ?? theme.colorScheme.primary),
        'unselectedItemColor': _colorToHex(theme.bottomNavigationBarTheme.unselectedItemColor ?? theme.unselectedWidgetColor),
        'type': theme.bottomNavigationBarTheme.type?.name ?? 'fixed',
        'landscapeLayout': theme.bottomNavigationBarTheme.landscapeLayout?.name ?? 'spread',
      },
      
      // Bottom Sheet Theme
      'bottomSheetTheme': {
        'backgroundColor': _colorToHex(theme.bottomSheetTheme.backgroundColor ?? theme.canvasColor),
        'elevation': theme.bottomSheetTheme.elevation ?? 0.0,
        'modalBackgroundColor': _colorToHex(theme.bottomSheetTheme.modalBackgroundColor ?? theme.canvasColor),
        'modalElevation': theme.bottomSheetTheme.modalElevation ?? 0.0,
        'shadowColor': _colorToHex(theme.bottomSheetTheme.shadowColor ?? theme.shadowColor),
        'surfaceTintColor': _colorToHex(theme.bottomSheetTheme.surfaceTintColor ?? theme.colorScheme.surfaceTint),
      },
      
      // Input Decoration Theme
      'inputDecorationTheme': {
        'labelStyle': {
          'color': _colorToHex(theme.inputDecorationTheme.labelStyle?.color ?? theme.colorScheme.onSurface.withOpacity(0.6)),
          'fontSize': theme.inputDecorationTheme.labelStyle?.fontSize ?? 16.0,
          'fontWeight': theme.inputDecorationTheme.labelStyle?.fontWeight?.index ?? FontWeight.normal.index,
        },
        'floatingLabelStyle': {
          'color': _colorToHex(theme.inputDecorationTheme.floatingLabelStyle?.color ?? theme.colorScheme.primary),
          'fontSize': theme.inputDecorationTheme.floatingLabelStyle?.fontSize ?? 12.0,
        },
        'helperStyle': {
          'color': _colorToHex(theme.inputDecorationTheme.helperStyle?.color ?? theme.colorScheme.onSurface.withOpacity(0.6)),
          'fontSize': theme.inputDecorationTheme.helperStyle?.fontSize ?? 12.0,
        },
        'hintStyle': {
          'color': _colorToHex(theme.inputDecorationTheme.hintStyle?.color ?? theme.colorScheme.onSurface.withOpacity(0.6)),
          'fontSize': theme.inputDecorationTheme.hintStyle?.fontSize ?? 16.0,
        },
        'errorStyle': {
          'color': _colorToHex(theme.inputDecorationTheme.errorStyle?.color ?? theme.colorScheme.error),
          'fontSize': theme.inputDecorationTheme.errorStyle?.fontSize ?? 12.0,
        },
        'fillColor': _colorToHex(theme.inputDecorationTheme.fillColor ?? theme.colorScheme.surface),
        'filled': theme.inputDecorationTheme.filled ?? false,
        'focusColor': _colorToHex(theme.inputDecorationTheme.focusColor ?? theme.focusColor),
        'hoverColor': _colorToHex(theme.inputDecorationTheme.hoverColor ?? theme.hoverColor),
      },
      
      // List Tile Theme
      'listTileTheme': {
        'dense': theme.listTileTheme.dense ?? false,
        'shape': theme.listTileTheme.shape?.runtimeType.toString() ?? 'RoundedRectangleBorder',
        'style': theme.listTileTheme.style?.name ?? 'list',
        'selectedColor': _colorToHex(theme.listTileTheme.selectedColor ?? theme.colorScheme.primary),
        'iconColor': _colorToHex(theme.listTileTheme.iconColor ?? theme.colorScheme.onSurface),
        'textColor': _colorToHex(theme.listTileTheme.textColor ?? theme.colorScheme.onSurface),
        'tileColor': _colorToHex(theme.listTileTheme.tileColor ?? Colors.transparent),
        'selectedTileColor': _colorToHex(theme.listTileTheme.selectedTileColor ?? theme.colorScheme.primary.withOpacity(0.12)),
        'horizontalTitleGap': theme.listTileTheme.horizontalTitleGap ?? 16.0,
        'minVerticalPadding': theme.listTileTheme.minVerticalPadding ?? 4.0,
        'minLeadingWidth': theme.listTileTheme.minLeadingWidth ?? 40.0,
      },
      
      // Slider Theme
      'sliderTheme': {
        'activeTrackColor': _colorToHex(theme.sliderTheme.activeTrackColor ?? theme.colorScheme.primary),
        'inactiveTrackColor': _colorToHex(theme.sliderTheme.inactiveTrackColor ?? theme.colorScheme.primary.withOpacity(0.24)),
        'disabledActiveTrackColor': _colorToHex(theme.sliderTheme.disabledActiveTrackColor ?? theme.colorScheme.onSurface.withOpacity(0.32)),
        'disabledInactiveTrackColor': _colorToHex(theme.sliderTheme.disabledInactiveTrackColor ?? theme.colorScheme.onSurface.withOpacity(0.12)),
        'activeTickMarkColor': _colorToHex(theme.sliderTheme.activeTickMarkColor ?? theme.colorScheme.onPrimary.withOpacity(0.54)),
        'inactiveTickMarkColor': _colorToHex(theme.sliderTheme.inactiveTickMarkColor ?? theme.colorScheme.primary.withOpacity(0.54)),
        'disabledActiveTickMarkColor': _colorToHex(theme.sliderTheme.disabledActiveTickMarkColor ?? theme.colorScheme.onSurface.withOpacity(0.12)),
        'disabledInactiveTickMarkColor': _colorToHex(theme.sliderTheme.disabledInactiveTickMarkColor ?? theme.colorScheme.onSurface.withOpacity(0.12)),
        'thumbColor': _colorToHex(theme.sliderTheme.thumbColor ?? theme.colorScheme.primary),
        'overlayColor': _colorToHex(theme.sliderTheme.overlayColor ?? theme.colorScheme.primary.withOpacity(0.12)),
        'valueIndicatorColor': _colorToHex(theme.sliderTheme.valueIndicatorColor ?? theme.colorScheme.inverseSurface),
        'trackHeight': theme.sliderTheme.trackHeight ?? 4.0,
      },
      
      // Snack Bar Theme
      'snackBarTheme': {
        'backgroundColor': _colorToHex(theme.snackBarTheme.backgroundColor ?? theme.colorScheme.inverseSurface),
        'actionTextColor': _colorToHex(theme.snackBarTheme.actionTextColor ?? theme.colorScheme.inversePrimary),
        'disabledActionTextColor': _colorToHex(theme.snackBarTheme.disabledActionTextColor ?? theme.colorScheme.inversePrimary.withOpacity(0.38)),
        'contentTextStyle': {
          'color': _colorToHex(theme.snackBarTheme.contentTextStyle?.color ?? theme.colorScheme.onInverseSurface),
          'fontSize': theme.snackBarTheme.contentTextStyle?.fontSize ?? 14.0,
        },
        'elevation': theme.snackBarTheme.elevation ?? 6.0,
        'behavior': theme.snackBarTheme.behavior?.name ?? 'fixed',
      },
      
      // Tab Bar Theme
      'tabBarTheme': {
        'indicator': theme.tabBarTheme.indicator?.runtimeType.toString() ?? 'UnderlineTabIndicator',
        'indicatorSize': theme.tabBarTheme.indicatorSize?.name ?? 'tab',
        'labelColor': _colorToHex(theme.tabBarTheme.labelColor ?? theme.colorScheme.primary),
        'unselectedLabelColor': _colorToHex(theme.tabBarTheme.unselectedLabelColor ?? theme.colorScheme.onSurface.withOpacity(0.6)),
        'labelStyle': {
          'color': _colorToHex(theme.tabBarTheme.labelStyle?.color ?? theme.colorScheme.primary),
          'fontSize': theme.tabBarTheme.labelStyle?.fontSize ?? 14.0,
        },
        'unselectedLabelStyle': {
          'color': _colorToHex(theme.tabBarTheme.unselectedLabelStyle?.color ?? theme.colorScheme.onSurface.withOpacity(0.6)),
          'fontSize': theme.tabBarTheme.unselectedLabelStyle?.fontSize ?? 14.0,
        },
        'overlayColor': _colorToHex(theme.tabBarTheme.overlayColor?.resolve({}) ?? theme.colorScheme.primary.withOpacity(0.12)),
      },
      
      // Text Selection Theme
      'textSelectionTheme': {
        'cursorColor': _colorToHex(theme.textSelectionTheme.cursorColor ?? theme.colorScheme.primary),
        'selectionColor': _colorToHex(theme.textSelectionTheme.selectionColor ?? theme.colorScheme.primary.withOpacity(0.4)),
        'selectionHandleColor': _colorToHex(theme.textSelectionTheme.selectionHandleColor ?? theme.colorScheme.primary),
      },
      
      // Text Theme
      'textTheme': {
        'displayLarge': theme.textTheme.displayLarge != null ? {
          'color': theme.textTheme.displayLarge!.color != null ? 
              _colorToHex(theme.textTheme.displayLarge!.color!) : null,
          'fontSize': theme.textTheme.displayLarge!.fontSize,
          'fontWeight': theme.textTheme.displayLarge!.fontWeight?.index,
          'fontFamily': theme.textTheme.displayLarge!.fontFamily,
        } : null,
        'displayMedium': theme.textTheme.displayMedium != null ? {
          'color': theme.textTheme.displayMedium!.color != null ? 
              _colorToHex(theme.textTheme.displayMedium!.color!) : null,
          'fontSize': theme.textTheme.displayMedium!.fontSize,
          'fontWeight': theme.textTheme.displayMedium!.fontWeight?.index,
          'fontFamily': theme.textTheme.displayMedium!.fontFamily,
        } : null,
        'displaySmall': theme.textTheme.displaySmall != null ? {
          'color': theme.textTheme.displaySmall!.color != null ? 
              _colorToHex(theme.textTheme.displaySmall!.color!) : null,
          'fontSize': theme.textTheme.displaySmall!.fontSize,
          'fontWeight': theme.textTheme.displaySmall!.fontWeight?.index,
          'fontFamily': theme.textTheme.displaySmall!.fontFamily,
        } : null,
        'headlineLarge': theme.textTheme.headlineLarge != null ? {
          'color': theme.textTheme.headlineLarge!.color != null ? 
              _colorToHex(theme.textTheme.headlineLarge!.color!) : null,
          'fontSize': theme.textTheme.headlineLarge!.fontSize,
          'fontWeight': theme.textTheme.headlineLarge!.fontWeight?.index,
          'fontFamily': theme.textTheme.headlineLarge!.fontFamily,
        } : null,
        'headlineMedium': theme.textTheme.headlineMedium != null ? {
          'color': theme.textTheme.headlineMedium!.color != null ? 
              _colorToHex(theme.textTheme.headlineMedium!.color!) : null,
          'fontSize': theme.textTheme.headlineMedium!.fontSize,
          'fontWeight': theme.textTheme.headlineMedium!.fontWeight?.index,
          'fontFamily': theme.textTheme.headlineMedium!.fontFamily,
        } : null,
        'headlineSmall': theme.textTheme.headlineSmall != null ? {
          'color': theme.textTheme.headlineSmall!.color != null ? 
              _colorToHex(theme.textTheme.headlineSmall!.color!) : null,
          'fontSize': theme.textTheme.headlineSmall!.fontSize,
          'fontWeight': theme.textTheme.headlineSmall!.fontWeight?.index,
          'fontFamily': theme.textTheme.headlineSmall!.fontFamily,
        } : null,
        'titleLarge': theme.textTheme.titleLarge != null ? {
          'color': theme.textTheme.titleLarge!.color != null ? 
              _colorToHex(theme.textTheme.titleLarge!.color!) : null,
          'fontSize': theme.textTheme.titleLarge!.fontSize,
          'fontWeight': theme.textTheme.titleLarge!.fontWeight?.index,
          'fontFamily': theme.textTheme.titleLarge!.fontFamily,
        } : null,
        'titleMedium': theme.textTheme.titleMedium != null ? {
          'color': theme.textTheme.titleMedium!.color != null ? 
              _colorToHex(theme.textTheme.titleMedium!.color!) : null,
          'fontSize': theme.textTheme.titleMedium!.fontSize,
          'fontWeight': theme.textTheme.titleMedium!.fontWeight?.index,
          'fontFamily': theme.textTheme.titleMedium!.fontFamily,
        } : null,
        'titleSmall': theme.textTheme.titleSmall != null ? {
          'color': theme.textTheme.titleSmall!.color != null ? 
              _colorToHex(theme.textTheme.titleSmall!.color!) : null,
          'fontSize': theme.textTheme.titleSmall!.fontSize,
          'fontWeight': theme.textTheme.titleSmall!.fontWeight?.index,
          'fontFamily': theme.textTheme.titleSmall!.fontFamily,
        } : null,
        'bodyLarge': theme.textTheme.bodyLarge != null ? {
          'color': theme.textTheme.bodyLarge!.color != null ? 
              _colorToHex(theme.textTheme.bodyLarge!.color!) : null,
          'fontSize': theme.textTheme.bodyLarge!.fontSize,
          'fontWeight': theme.textTheme.bodyLarge!.fontWeight?.index,
          'fontFamily': theme.textTheme.bodyLarge!.fontFamily,
        } : null,
        'bodyMedium': theme.textTheme.bodyMedium != null ? {
          'color': theme.textTheme.bodyMedium!.color != null ? 
              _colorToHex(theme.textTheme.bodyMedium!.color!) : null,
          'fontSize': theme.textTheme.bodyMedium!.fontSize,
          'fontWeight': theme.textTheme.bodyMedium!.fontWeight?.index,
          'fontFamily': theme.textTheme.bodyMedium!.fontFamily,
        } : null,
        'bodySmall': theme.textTheme.bodySmall != null ? {
          'color': theme.textTheme.bodySmall!.color != null ? 
              _colorToHex(theme.textTheme.bodySmall!.color!) : null,
          'fontSize': theme.textTheme.bodySmall!.fontSize,
          'fontWeight': theme.textTheme.bodySmall!.fontWeight?.index,
          'fontFamily': theme.textTheme.bodySmall!.fontFamily,
        } : null,
        'labelLarge': theme.textTheme.labelLarge != null ? {
          'color': theme.textTheme.labelLarge!.color != null ? 
              _colorToHex(theme.textTheme.labelLarge!.color!) : null,
          'fontSize': theme.textTheme.labelLarge!.fontSize,
          'fontWeight': theme.textTheme.labelLarge!.fontWeight?.index,
          'fontFamily': theme.textTheme.labelLarge!.fontFamily,
        } : null,
        'labelMedium': theme.textTheme.labelMedium != null ? {
          'color': theme.textTheme.labelMedium!.color != null ? 
              _colorToHex(theme.textTheme.labelMedium!.color!) : null,
          'fontSize': theme.textTheme.labelMedium!.fontSize,
          'fontWeight': theme.textTheme.labelMedium!.fontWeight?.index,
          'fontFamily': theme.textTheme.labelMedium!.fontFamily,
        } : null,
        'labelSmall': theme.textTheme.labelSmall != null ? {
          'color': theme.textTheme.labelSmall!.color != null ? 
              _colorToHex(theme.textTheme.labelSmall!.color!) : null,
          'fontSize': theme.textTheme.labelSmall!.fontSize,
          'fontWeight': theme.textTheme.labelSmall!.fontWeight?.index,
          'fontFamily': theme.textTheme.labelSmall!.fontFamily,
        } : null,
      },
      
      // Primary Text Theme
      'primaryTextTheme': {
        'displayLarge': theme.primaryTextTheme.displayLarge != null ? {
          'color': theme.primaryTextTheme.displayLarge!.color != null ? 
              _colorToHex(theme.primaryTextTheme.displayLarge!.color!) : null,
          'fontSize': theme.primaryTextTheme.displayLarge!.fontSize,
          'fontWeight': theme.primaryTextTheme.displayLarge!.fontWeight?.index,
          'fontFamily': theme.primaryTextTheme.displayLarge!.fontFamily,
        } : null,
        'displayMedium': theme.primaryTextTheme.displayMedium != null ? {
          'color': theme.primaryTextTheme.displayMedium!.color != null ? 
              _colorToHex(theme.primaryTextTheme.displayMedium!.color!) : null,
          'fontSize': theme.primaryTextTheme.displayMedium!.fontSize,
          'fontWeight': theme.primaryTextTheme.displayMedium!.fontWeight?.index,
          'fontFamily': theme.primaryTextTheme.displayMedium!.fontFamily,
        } : null,
        'displaySmall': theme.primaryTextTheme.displaySmall != null ? {
          'color': theme.primaryTextTheme.displaySmall!.color != null ? 
              _colorToHex(theme.primaryTextTheme.displaySmall!.color!) : null,
          'fontSize': theme.primaryTextTheme.displaySmall!.fontSize,
          'fontWeight': theme.primaryTextTheme.displaySmall!.fontWeight?.index,
          'fontFamily': theme.primaryTextTheme.displaySmall!.fontFamily,
        } : null,
        'headlineLarge': theme.primaryTextTheme.headlineLarge != null ? {
          'color': theme.primaryTextTheme.headlineLarge!.color != null ? 
              _colorToHex(theme.primaryTextTheme.headlineLarge!.color!) : null,
          'fontSize': theme.primaryTextTheme.headlineLarge!.fontSize,
          'fontWeight': theme.primaryTextTheme.headlineLarge!.fontWeight?.index,
          'fontFamily': theme.primaryTextTheme.headlineLarge!.fontFamily,
        } : null,
        'headlineMedium': theme.primaryTextTheme.headlineMedium != null ? {
          'color': theme.primaryTextTheme.headlineMedium!.color != null ? 
              _colorToHex(theme.primaryTextTheme.headlineMedium!.color!) : null,
          'fontSize': theme.primaryTextTheme.headlineMedium!.fontSize,
          'fontWeight': theme.primaryTextTheme.headlineMedium!.fontWeight?.index,
          'fontFamily': theme.primaryTextTheme.headlineMedium!.fontFamily,
        } : null,
        'headlineSmall': theme.primaryTextTheme.headlineSmall != null ? {
          'color': theme.primaryTextTheme.headlineSmall!.color != null ? 
              _colorToHex(theme.primaryTextTheme.headlineSmall!.color!) : null,
          'fontSize': theme.primaryTextTheme.headlineSmall!.fontSize,
          'fontWeight': theme.primaryTextTheme.headlineSmall!.fontWeight?.index,
          'fontFamily': theme.primaryTextTheme.headlineSmall!.fontFamily,
        } : null,
        'titleLarge': theme.primaryTextTheme.titleLarge != null ? {
          'color': theme.primaryTextTheme.titleLarge!.color != null ? 
              _colorToHex(theme.primaryTextTheme.titleLarge!.color!) : null,
          'fontSize': theme.primaryTextTheme.titleLarge!.fontSize,
          'fontWeight': theme.primaryTextTheme.titleLarge!.fontWeight?.index,
          'fontFamily': theme.primaryTextTheme.titleLarge!.fontFamily,
        } : null,
        'titleMedium': theme.primaryTextTheme.titleMedium != null ? {
          'color': theme.primaryTextTheme.titleMedium!.color != null ? 
              _colorToHex(theme.primaryTextTheme.titleMedium!.color!) : null,
          'fontSize': theme.primaryTextTheme.titleMedium!.fontSize,
          'fontWeight': theme.primaryTextTheme.titleMedium!.fontWeight?.index,
          'fontFamily': theme.primaryTextTheme.titleMedium!.fontFamily,
        } : null,
        'titleSmall': theme.primaryTextTheme.titleSmall != null ? {
          'color': theme.primaryTextTheme.titleSmall!.color != null ? 
              _colorToHex(theme.primaryTextTheme.titleSmall!.color!) : null,
          'fontSize': theme.primaryTextTheme.titleSmall!.fontSize,
          'fontWeight': theme.primaryTextTheme.titleSmall!.fontWeight?.index,
          'fontFamily': theme.primaryTextTheme.titleSmall!.fontFamily,
        } : null,
        'bodyLarge': theme.primaryTextTheme.bodyLarge != null ? {
          'color': theme.primaryTextTheme.bodyLarge!.color != null ? 
              _colorToHex(theme.primaryTextTheme.bodyLarge!.color!) : null,
          'fontSize': theme.primaryTextTheme.bodyLarge!.fontSize,
          'fontWeight': theme.primaryTextTheme.bodyLarge!.fontWeight?.index,
          'fontFamily': theme.primaryTextTheme.bodyLarge!.fontFamily,
        } : null,
        'bodyMedium': theme.primaryTextTheme.bodyMedium != null ? {
          'color': theme.primaryTextTheme.bodyMedium!.color != null ? 
              _colorToHex(theme.primaryTextTheme.bodyMedium!.color!) : null,
          'fontSize': theme.primaryTextTheme.bodyMedium!.fontSize,
          'fontWeight': theme.primaryTextTheme.bodyMedium!.fontWeight?.index,
          'fontFamily': theme.primaryTextTheme.bodyMedium!.fontFamily,
        } : null,
        'bodySmall': theme.primaryTextTheme.bodySmall != null ? {
          'color': theme.primaryTextTheme.bodySmall!.color != null ? 
              _colorToHex(theme.primaryTextTheme.bodySmall!.color!) : null,
          'fontSize': theme.primaryTextTheme.bodySmall!.fontSize,
          'fontWeight': theme.primaryTextTheme.bodySmall!.fontWeight?.index,
          'fontFamily': theme.primaryTextTheme.bodySmall!.fontFamily,
        } : null,
        'labelLarge': theme.primaryTextTheme.labelLarge != null ? {
          'color': theme.primaryTextTheme.labelLarge!.color != null ? 
              _colorToHex(theme.primaryTextTheme.labelLarge!.color!) : null,
          'fontSize': theme.primaryTextTheme.labelLarge!.fontSize,
          'fontWeight': theme.primaryTextTheme.labelLarge!.fontWeight?.index,
          'fontFamily': theme.primaryTextTheme.labelLarge!.fontFamily,
        } : null,
        'labelMedium': theme.primaryTextTheme.labelMedium != null ? {
          'color': theme.primaryTextTheme.labelMedium!.color != null ? 
              _colorToHex(theme.primaryTextTheme.labelMedium!.color!) : null,
          'fontSize': theme.primaryTextTheme.labelMedium!.fontSize,
          'fontWeight': theme.primaryTextTheme.labelMedium!.fontWeight?.index,
          'fontFamily': theme.primaryTextTheme.labelMedium!.fontFamily,
        } : null,
        'labelSmall': theme.primaryTextTheme.labelSmall != null ? {
          'color': theme.primaryTextTheme.labelSmall!.color != null ? 
              _colorToHex(theme.primaryTextTheme.labelSmall!.color!) : null,
          'fontSize': theme.primaryTextTheme.labelSmall!.fontSize,
          'fontWeight': theme.primaryTextTheme.labelSmall!.fontWeight?.index,
          'fontFamily': theme.primaryTextTheme.labelSmall!.fontFamily,
        } : null,
      },
    };
    
    return jsonEncode(themeMap);
  }

  /// Converts a hex string or integer to a Color object
  static Color _parseColor(dynamic colorValue, int defaultValue) {
    if (colorValue is String && colorValue.startsWith('#')) {
      // Handle hex format (e.g., "#ff36618e")
      final hexString = colorValue.substring(1); // Remove the '#'
      return Color(int.parse(hexString, radix: 16));
    } else if (colorValue is int) {
      // Handle integer format (e.g., 4281753998)
      return Color(colorValue);
    } else {
      // Fallback to default value
      return Color(defaultValue);
    }
  }

  /// Converts a JSON string to a ThemeData object (basic implementation)
  static ThemeData? decodeThemeData(String jsonString) {
    try {
      final Map<String, dynamic> themeMap = jsonDecode(jsonString);
      
      final brightness = themeMap['brightness'] == 'dark' 
          ? Brightness.dark 
          : Brightness.light;
      
      final colorSchemeMap = themeMap['colorScheme'] as Map<String, dynamic>?;
      
      ColorScheme? colorScheme;
      if (colorSchemeMap != null) {
        colorScheme = ColorScheme(
          brightness: colorSchemeMap['brightness'] == 'dark' 
              ? Brightness.dark 
              : Brightness.light,
          primary: _parseColor(colorSchemeMap['primary'], 0xFF2196F3),
          onPrimary: _parseColor(colorSchemeMap['onPrimary'], 0xFFFFFFFF),
          secondary: _parseColor(colorSchemeMap['secondary'], 0xFF03DAC6),
          onSecondary: _parseColor(colorSchemeMap['onSecondary'], 0xFF000000),
          error: _parseColor(colorSchemeMap['error'], 0xFFB00020),
          onError: _parseColor(colorSchemeMap['onError'], 0xFFFFFFFF),
          surface: _parseColor(colorSchemeMap['surface'], 0xFFFFFFFF),
          onSurface: _parseColor(colorSchemeMap['onSurface'], 0xFF000000),
        );
      }
      
      return ThemeData(
        brightness: brightness,
        primaryColor: _parseColor(themeMap['primaryColor'], 0xFF2196F3),
        scaffoldBackgroundColor: _parseColor(themeMap['scaffoldBackgroundColor'], 0xFFFFFFFF),
        canvasColor: _parseColor(themeMap['canvasColor'], 0xFFFFFFFF),
        cardColor: _parseColor(themeMap['cardColor'], 0xFFFFFFFF),
        dividerColor: _parseColor(themeMap['dividerColor'], 0x1F000000),
        focusColor: _parseColor(themeMap['focusColor'], 0x1F000000),
        hoverColor: _parseColor(themeMap['hoverColor'], 0x0A000000),
        highlightColor: _parseColor(themeMap['highlightColor'], 0x66BCBCBC),
        splashColor: _parseColor(themeMap['splashColor'], 0x66C8C8C8),
        unselectedWidgetColor: _parseColor(themeMap['unselectedWidgetColor'], 0x8A000000),
        disabledColor: _parseColor(themeMap['disabledColor'], 0x61000000),
        secondaryHeaderColor: _parseColor(themeMap['secondaryHeaderColor'], 0xFFF3F3F3),
        dialogBackgroundColor: _parseColor(themeMap['dialogBackgroundColor'], 0xFFFFFFFF),
        indicatorColor: _parseColor(themeMap['indicatorColor'], 0xFF2196F3),
        hintColor: _parseColor(themeMap['hintColor'], 0x8A000000),
        colorScheme: colorScheme,
      );
    } catch (e) {
      print('Error decoding theme: $e');
      return null;
    }
  }
}