import 'dart:convert';

import 'package:appainter/app_config/app_config.dart';
import 'package:appainter/home/home.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/theme_serializer.dart';
import 'package:pretty_json/pretty_json.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_io/io.dart' as io;

class HomeRepository {
  final Dio _dio;
  final FilePicker _filePicker;

  HomeRepository({Dio? dio, FilePicker? filePicker})
      : _dio = dio ?? Dio(),
        _filePicker = filePicker ?? FilePicker.platform;

  static const _usageFileUrl =
      'https://raw.githubusercontent.com/zeshuaro/appainter/main/USAGE.md';
  static const _exportFileName = 'appainter_theme.json';
  static const _isDarkThemeKey = 'isDarkTheme';

  Future<ThemeUsage> fetchThemeUsage() async {
    try {
      final response = await _dio.get(_usageFileUrl);
      return ThemeUsage(response.data);
    } catch (e, st) {
      Sentry.captureException(e, stackTrace: st);
      return const ThemeUsage();
    }
  }

  Future<ThemeData?> importTheme() async {
    ThemeData? theme;
    final result = await _filePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      final platformFile = result.files.single;
      late final String themeStr;

      if (platformFile.bytes != null) {
        themeStr = String.fromCharCodes(platformFile.bytes!);
      } else {
        final file = io.File(platformFile.path!);
        themeStr = await file.readAsString();
      }

      theme = ThemeSerializer.decodeThemeData(themeStr);
    }

    return theme;
  }

  Future<bool> exportTheme(ThemeData theme) async {
    final themeStr = ThemeSerializer.encodeThemeData(theme);
    final themeBytes = Uint8List.fromList(themeStr.codeUnits);

    if (kIsWeb) {
      _exportThemeOnWeb(themeBytes);
      return true;
    } else {
      return await _exportThemeOnDesktop(themeBytes);
    }
  }

  Future<bool> exportThemeWithConfig(ThemeData theme, AppConfig appConfig) async {
    final themeStr = ThemeSerializer.encodeThemeData(theme);
    final themeJson = jsonDecode(themeStr) as Map<String, dynamic>;
    
    // Merge theme data with app config to create a single JSON structure
    final exportData = <String, dynamic>{
      ...themeJson,
      'appConfig': appConfig.toJson(),
    };
    final exportStr = jsonEncode(exportData);
    final exportBytes = Uint8List.fromList(exportStr.codeUnits);

    if (kIsWeb) {
      await _exportThemeWithConfigOnWeb(exportBytes, appConfig);
      return true;
    } else {
      return _exportThemeWithConfigOnDesktop(exportBytes, appConfig);
    }
  }

  Future<bool?> getIsDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkThemeKey);
  }

  Future<void> setIsDarkTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkThemeKey, isDark);
  }

  void _exportThemeOnWeb(Uint8List bytes) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = _exportFileName;

    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  Future<bool> _exportThemeOnDesktop(Uint8List bytes) async {
    final path = await _filePicker.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: _exportFileName,
    );

    if (path != null) {
      final file = io.File(path);
      await file.writeAsBytes(bytes);
      return true;
    }

    return false;
  }

  Future<void> _exportThemeWithConfigOnWeb(Uint8List bytes, AppConfig appConfig) async {
    // For web, we'll create a zip file containing the JSON and images
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'theme_with_config.json';

    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);

    // Export images separately for web
    await _exportImagesOnWeb(appConfig);
  }

  Future<bool> _exportThemeWithConfigOnDesktop(Uint8List bytes, AppConfig appConfig) async {
    final path = await _filePicker.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'theme_with_config.json',
    );

    if (path != null) {
      final file = io.File(path);
      await file.writeAsBytes(bytes);
      
      // Create config folder and save images
      await _exportImagesOnDesktop(path, appConfig);
      return true;
    }

    return false;
  }

  Future<void> _exportImagesOnWeb(AppConfig appConfig) async {
    final images = _collectImages(appConfig);
    
    for (final entry in images.entries) {
      final imageAsset = entry.value;
      if (imageAsset.data != null) {
        final blob = html.Blob([imageAsset.data!]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = 'config/${imageAsset.fileName}';

        html.document.body?.children.add(anchor);
        anchor.click();
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      }
    }
  }

  Future<void> _exportImagesOnDesktop(String jsonPath, AppConfig appConfig) async {
    final jsonFile = io.File(jsonPath);
    final parentDir = jsonFile.parent;
    final configDir = io.Directory('${parentDir.path}/config');
    
    if (!await configDir.exists()) {
      await configDir.create();
    }

    final images = _collectImages(appConfig);
    
    for (final entry in images.entries) {
      final imageAsset = entry.value;
      if (imageAsset.data != null) {
        final imageFile = io.File('${configDir.path}/${imageAsset.fileName}');
        await imageFile.writeAsBytes(imageAsset.data!);
      }
    }
  }

  Map<String, ImageAsset> _collectImages(AppConfig appConfig) {
    final images = <String, ImageAsset>{};
    
    if (appConfig.icon.data != null) {
      images['icon'] = appConfig.icon;
    }
    
    if (appConfig.logo.defaultLogo.data != null) {
      images['logo_default'] = appConfig.logo.defaultLogo;
    }
    
    if (appConfig.logo.dark.data != null) {
      images['logo_dark'] = appConfig.logo.dark;
    }
    
    if (appConfig.logo.small.data != null) {
      images['logo_small'] = appConfig.logo.small;
    }
    
    if (appConfig.logo.splashScreen.data != null) {
      images['logo_splash'] = appConfig.logo.splashScreen;
    }
    
    return images;
  }
}
