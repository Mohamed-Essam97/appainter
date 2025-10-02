import 'dart:convert';
import 'package:flutter/material.dart';

/// Custom theme serialization utility to replace json_theme functionality
class ThemeSerializer {
  /// Converts a ThemeData object to a JSON string
  static String encodeThemeData(ThemeData theme) {
    final Map<String, dynamic> themeMap = {
      'brightness': theme.brightness.name,
      'primaryColor': theme.primaryColor.value,
      'scaffoldBackgroundColor': theme.scaffoldBackgroundColor.value,
      'canvasColor': theme.canvasColor.value,
      'cardColor': theme.cardColor.value,
      'dividerColor': theme.dividerColor.value,
      'focusColor': theme.focusColor.value,
      'hoverColor': theme.hoverColor.value,
      'highlightColor': theme.highlightColor.value,
      'splashColor': theme.splashColor.value,
      'unselectedWidgetColor': theme.unselectedWidgetColor.value,
      'disabledColor': theme.disabledColor.value,
      'dialogBackgroundColor': theme.dialogBackgroundColor.value,
      'indicatorColor': theme.indicatorColor.value,
      'hintColor': theme.hintColor.value,
      'errorColor': theme.colorScheme.error.value,
      // Add more properties as needed
      'colorScheme': {
        'brightness': theme.colorScheme.brightness.name,
        'primary': theme.colorScheme.primary.value,
        'onPrimary': theme.colorScheme.onPrimary.value,
        'secondary': theme.colorScheme.secondary.value,
        'onSecondary': theme.colorScheme.onSecondary.value,
        'error': theme.colorScheme.error.value,
        'onError': theme.colorScheme.onError.value,
        'surface': theme.colorScheme.surface.value,
        'onSurface': theme.colorScheme.onSurface.value,
      },
    };
    
    return jsonEncode(themeMap);
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
          primary: Color(colorSchemeMap['primary'] ?? 0xFF2196F3),
          onPrimary: Color(colorSchemeMap['onPrimary'] ?? 0xFFFFFFFF),
          secondary: Color(colorSchemeMap['secondary'] ?? 0xFF03DAC6),
          onSecondary: Color(colorSchemeMap['onSecondary'] ?? 0xFF000000),
          error: Color(colorSchemeMap['error'] ?? 0xFFB00020),
          onError: Color(colorSchemeMap['onError'] ?? 0xFFFFFFFF),
          surface: Color(colorSchemeMap['surface'] ?? 0xFFFFFFFF),
          onSurface: Color(colorSchemeMap['onSurface'] ?? 0xFF000000),
        );
      }
      
      return ThemeData(
        brightness: brightness,
        primaryColor: Color(themeMap['primaryColor'] ?? 0xFF2196F3),
        scaffoldBackgroundColor: Color(themeMap['scaffoldBackgroundColor'] ?? 0xFFFFFFFF),
        canvasColor: Color(themeMap['canvasColor'] ?? 0xFFFFFFFF),
        cardColor: Color(themeMap['cardColor'] ?? 0xFFFFFFFF),
        dividerColor: Color(themeMap['dividerColor'] ?? 0x1F000000),
        focusColor: Color(themeMap['focusColor'] ?? 0x1F000000),
        hoverColor: Color(themeMap['hoverColor'] ?? 0x0A000000),
        highlightColor: Color(themeMap['highlightColor'] ?? 0x66BCBCBC),
        splashColor: Color(themeMap['splashColor'] ?? 0x66C8C8C8),
        unselectedWidgetColor: Color(themeMap['unselectedWidgetColor'] ?? 0x8A000000),
        disabledColor: Color(themeMap['disabledColor'] ?? 0x61000000),
        secondaryHeaderColor: Color(themeMap['secondaryHeaderColor'] ?? 0xFFF3F3F3),
        dialogBackgroundColor: Color(themeMap['dialogBackgroundColor'] ?? 0xFFFFFFFF),
        indicatorColor: Color(themeMap['indicatorColor'] ?? 0xFF2196F3),
        hintColor: Color(themeMap['hintColor'] ?? 0x8A000000),
        colorScheme: colorScheme,
      );
    } catch (e) {
      print('Error decoding theme: $e');
      return null;
    }
  }
}