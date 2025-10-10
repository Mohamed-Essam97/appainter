import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:appainter/app_config/app_config.dart';
import 'package:appainter/utils/theme_serializer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:universal_html/html.dart' as html;
import 'build_automation_service.dart';

class CommunityMobileExportService {
  final FilePicker _filePicker;

  CommunityMobileExportService({FilePicker? filePicker})
      : _filePicker = filePicker ?? FilePicker.platform;

  /// Exports theme and configuration for community mobile app
  /// Creates separate light/dark theme files and app configuration
  Future<bool> exportForCommunityMobile({
    required ThemeData lightTheme,
    required ThemeData darkTheme,
    required AppConfig appConfig,
    String? customBaseUrl,
  }) async {
    try {
      // Validate inputs
      if (lightTheme == null) {
        throw ArgumentError('Light theme cannot be null');
      }
      
      if (darkTheme == null) {
        throw ArgumentError('Dark theme cannot be null');
      }
      
      if (appConfig == null) {
        throw ArgumentError('App configuration cannot be null');
      }
      
      // Validate custom base URL if provided
      if (customBaseUrl != null && customBaseUrl.isNotEmpty) {
        try {
          Uri.parse(customBaseUrl);
        } catch (e) {
          throw FormatException('Invalid custom base URL format: $customBaseUrl');
        }
      }

      // Generate the theme files and app config
      final lightThemeJson = _generateLightThemeJson(lightTheme);
      final darkThemeJson = _generateDarkThemeJson(darkTheme);
      final appConfigJson = _generateAppConfigJson(appConfig, customBaseUrl);
      
      // Validate generated JSON content
      if (lightThemeJson.isEmpty) {
        throw StateError('Failed to generate light theme JSON');
      }
      
      if (darkThemeJson.isEmpty) {
        throw StateError('Failed to generate dark theme JSON');
      }
      
      if (appConfigJson.isEmpty) {
        throw StateError('Failed to generate app configuration JSON');
      }

      if (kIsWeb) {
        return await _exportOnWeb(lightThemeJson, darkThemeJson, appConfigJson, appConfig);
      } else {
        return await _exportOnDesktop(lightThemeJson, darkThemeJson, appConfigJson, appConfig);
      }
    } on ArgumentError catch (e) {
      debugPrint('Invalid argument for community mobile export: ${e.message}');
      return false;
    } on FormatException catch (e) {
      debugPrint('Format error during community mobile export: ${e.message}');
      return false;
    } on StateError catch (e) {
      debugPrint('State error during community mobile export: ${e.message}');
      return false;
    } catch (e, stackTrace) {
      debugPrint('Unexpected error exporting for community mobile: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Build APK with the selected theme configuration
  static Future<bool> buildApkWithTheme({
    required ThemeData lightTheme,
    ThemeData? darkTheme,
    required AppConfig appConfig,
    required String projectPath,
    String? baseUrl,
  }) async {
    try {
      // Validate required inputs
      if (lightTheme == null) {
        throw ArgumentError('Light theme cannot be null');
      }
      
      if (appConfig == null) {
        throw ArgumentError('App configuration cannot be null');
      }
      
      if (projectPath.isEmpty) {
        throw ArgumentError('Project path cannot be empty');
      }
      
      // Validate project path exists
      final projectDir = io.Directory(projectPath);
      if (!await projectDir.exists()) {
        throw io.FileSystemException('Project directory does not exist', projectPath);
      }
      
      // Validate base URL if provided
      if (baseUrl != null && baseUrl.isNotEmpty) {
        try {
          Uri.parse(baseUrl);
        } catch (e) {
          throw FormatException('Invalid base URL format: $baseUrl');
        }
      }
      
      // Generate theme files content using existing methods
      final themeFiles = <String, String>{};
      
      try {
        // Generate light theme JSON
        final lightThemeJson = _generateLightThemeJsonStatic(lightTheme);
        if (lightThemeJson.isEmpty) {
          throw StateError('Failed to generate light theme JSON');
        }
        themeFiles['laserina_light.json'] = const JsonEncoder.withIndent('  ').convert(lightThemeJson);
        
        // Generate dark theme JSON (use provided or generate from light)
        final darkThemeData = darkTheme ?? _generateDarkTheme(lightTheme);
        final darkThemeJson = _generateDarkThemeJsonStatic(darkThemeData);
        if (darkThemeJson.isEmpty) {
          throw StateError('Failed to generate dark theme JSON');
        }
        themeFiles['laserina_dark.json'] = const JsonEncoder.withIndent('  ').convert(darkThemeJson);
      } catch (e) {
        throw StateError('Failed to generate theme files: $e');
      }
      
      // Validate theme files were generated
      if (themeFiles.isEmpty) {
        throw StateError('No theme files were generated');
      }
      
      // Validate app configuration can be serialized
      Map<String, dynamic> appConfigMap;
      try {
        appConfigMap = appConfig.toJson();
        if (appConfigMap.isEmpty) {
          throw StateError('App configuration serialization resulted in empty map');
        }
      } catch (e) {
        throw StateError('Failed to serialize app configuration: $e');
      }
      
      print('Starting APK build with ${themeFiles.length} theme files...');
      
      // Use BuildAutomationService to handle the actual build process
      final buildResult = await BuildAutomationService.buildApkWithTheme(
        projectPath: projectPath,
        themeFiles: themeFiles,
        appConfig: appConfigMap,
        baseUrl: baseUrl,
      );
      
      if (buildResult) {
        print('APK build completed successfully');
      } else {
        print('APK build failed');
      }
      
      return buildResult;
    } on ArgumentError catch (e) {
      print('Invalid argument for APK build: ${e.message}');
      return false;
    } on FormatException catch (e) {
      print('Format error during APK build: ${e.message}');
      return false;
    } on StateError catch (e) {
      print('State error during APK build: ${e.message}');
      return false;
    } on io.FileSystemException catch (e) {
      print('File system error during APK build: ${e.message}');
      return false;
    } catch (e, stackTrace) {
      print('Unexpected error building APK with theme: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Generate light theme JSON (static version)
  static Map<String, dynamic> _generateLightThemeJsonStatic(ThemeData theme) {
    final themeStr = ThemeSerializer.encodeThemeData(theme);
    final themeJson = jsonDecode(themeStr) as Map<String, dynamic>;
    
    // Add community mobile specific configurations
    return {
      'brightness': 'light',
      'theme': themeJson,
      'version': '1.0.0',
      'generatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Generate dark theme JSON (static version)
  static Map<String, dynamic> _generateDarkThemeJsonStatic(ThemeData theme) {
    final themeStr = ThemeSerializer.encodeThemeData(theme);
    final themeJson = jsonDecode(themeStr) as Map<String, dynamic>;
    
    // Add community mobile specific configurations
    return {
      'brightness': 'dark',
      'theme': themeJson,
      'version': '1.0.0',
      'generatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Generate a dark theme from a light theme
  static ThemeData _generateDarkTheme(ThemeData lightTheme) {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkenColor(lightTheme.scaffoldBackgroundColor),
      cardColor: _darkenColor(lightTheme.cardColor),
      canvasColor: _darkenColor(lightTheme.canvasColor),
      colorScheme: lightTheme.colorScheme.copyWith(
        brightness: Brightness.dark,
        surface: _darkenColor(lightTheme.colorScheme.surface),
        onSurface: _lightenColor(lightTheme.colorScheme.onSurface),
      ),
    );
  }

  /// Helper method to darken a color for dark theme generation
  static Color _darkenColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness * 0.2).clamp(0.0, 1.0)).toColor();
  }

  /// Helper method to lighten a color for dark theme generation
  static Color _lightenColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness * 1.8).clamp(0.0, 1.0)).toColor();
  }

  Map<String, dynamic> _generateLightThemeJson(ThemeData theme) {
    final themeStr = ThemeSerializer.encodeThemeData(theme);
    final themeJson = jsonDecode(themeStr) as Map<String, dynamic>;
    
    // Add community mobile specific configurations
    return {
      'brightness': 'light',
      'theme': themeJson,
      'version': '1.0.0',
      'generatedAt': DateTime.now().toIso8601String(),
    };
  }

  Map<String, dynamic> _generateDarkThemeJson(ThemeData theme) {
    final themeStr = ThemeSerializer.encodeThemeData(theme);
    final themeJson = jsonDecode(themeStr) as Map<String, dynamic>;
    
    // Add community mobile specific configurations
    return {
      'brightness': 'dark',
      'theme': themeJson,
      'version': '1.0.0',
      'generatedAt': DateTime.now().toIso8601String(),
    };
  }

  Map<String, dynamic> _generateAppConfigJson(AppConfig appConfig, String? customBaseUrl) {
    final configJson = appConfig.toJson();
    
    // Add the baseUrl from custom input or default
    final baseUrl = customBaseUrl ?? 'https://file-managment-system.feat.iometer.live';
    
    return {
      'app': {
        ...configJson,
        'baseUrl': baseUrl,
        'version': appConfig.version,
        'name': appConfig.name,
        'packageName': appConfig.packageName,
        'isProduction': appConfig.isProduction,
      },
      'generatedAt': DateTime.now().toIso8601String(),
      'exportedFrom': 'AppPainter',
    };
  }

  Future<bool> _exportOnWeb(
    Map<String, dynamic> lightTheme,
    Map<String, dynamic> darkTheme,
    Map<String, dynamic> appConfig,
    AppConfig config,
  ) async {
    try {
      // Export light theme
      final lightThemeBytes = Uint8List.fromList(
        const JsonEncoder.withIndent('  ').convert(lightTheme).codeUnits,
      );
      _downloadFile(lightThemeBytes, 'laserina_light.json');

      // Export dark theme
      final darkThemeBytes = Uint8List.fromList(
        const JsonEncoder.withIndent('  ').convert(darkTheme).codeUnits,
      );
      _downloadFile(darkThemeBytes, 'laserina_dark.json');

      // Export app config
      final appConfigBytes = Uint8List.fromList(
        const JsonEncoder.withIndent('  ').convert(appConfig).codeUnits,
      );
      _downloadFile(appConfigBytes, 'lasirena.json');

      // Export images
      await _exportImagesOnWeb(config);

      return true;
    } catch (e) {
      debugPrint('Error exporting on web: $e');
      return false;
    }
  }

  Future<bool> _exportOnDesktop(
    Map<String, dynamic> lightTheme,
    Map<String, dynamic> darkTheme,
    Map<String, dynamic> appConfig,
    AppConfig config,
  ) async {
    try {
      final path = await _filePicker.getDirectoryPath(
        dialogTitle: 'Select directory to export community mobile theme',
      );

      if (path == null) return false;

      final exportDir = io.Directory(path);
      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
      }

      // Create themes directory
      final themesDir = io.Directory('$path/themes');
      if (!await themesDir.exists()) {
        await themesDir.create();
      }

      // Create config directory
      final configDir = io.Directory('$path/config');
      if (!await configDir.exists()) {
        await configDir.create();
      }

      // Write light theme
      final lightThemeFile = io.File('${themesDir.path}/laserina_light.json');
      await lightThemeFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(lightTheme),
      );

      // Write dark theme
      final darkThemeFile = io.File('${themesDir.path}/laserina_dark.json');
      await darkThemeFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(darkTheme),
      );

      // Write app config
      final appConfigFile = io.File('${configDir.path}/lasirena.json');
      await appConfigFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(appConfig),
      );

      // Export images
      await _exportImagesOnDesktop(configDir.path, config);

      return true;
    } catch (e) {
      debugPrint('Error exporting on desktop: $e');
      return false;
    }
  }

  Future<bool> _copyThemeFilesToProject({
    required ThemeData lightTheme,
    required ThemeData darkTheme,
    required AppConfig appConfig,
    String? customBaseUrl,
    required String projectPath,
  }) async {
    try {
      final lightThemeJson = _generateLightThemeJson(lightTheme);
      final darkThemeJson = _generateDarkThemeJson(darkTheme);
      final appConfigJson = _generateAppConfigJson(appConfig, customBaseUrl);

      // Define target paths in community mobile project
      final themesPath = '$projectPath/app/lib/configs/themes';
      final configPath = '$projectPath/app/lib/configs/dynamic_ui';

      // Ensure directories exist
      await io.Directory(themesPath).create(recursive: true);
      await io.Directory(configPath).create(recursive: true);

      // Write theme files
      final lightThemeFile = io.File('$themesPath/laserina_light.json');
      await lightThemeFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(lightThemeJson),
      );

      final darkThemeFile = io.File('$themesPath/laserina_dark.json');
      await darkThemeFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(darkThemeJson),
      );

      // Write app config
      final appConfigFile = io.File('$configPath/lasirena.json');
      await appConfigFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(appConfigJson),
      );

      return true;
    } catch (e) {
      debugPrint('Error copying theme files to project: $e');
      return false;
    }
  }

  Future<bool> _buildApk(String projectPath) async {
    try {
      // Change to project directory and build APK
      final result = await io.Process.run(
        'flutter',
        ['build', 'apk', '--release'],
        workingDirectory: projectPath,
      );

      if (result.exitCode == 0) {
        debugPrint('APK built successfully');
        debugPrint('APK location: $projectPath/build/app/outputs/flutter-apk/app-release.apk');
        return true;
      } else {
        debugPrint('APK build failed: ${result.stderr}');
        return false;
      }
    } catch (e) {
      debugPrint('Error building APK: $e');
      return false;
    }
  }

  void _downloadFile(Uint8List bytes, String fileName) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;

    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
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
          ..download = 'assets/${imageAsset.fileName}';

        html.document.body?.children.add(anchor);
        anchor.click();
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      }
    }
  }

  Future<void> _exportImagesOnDesktop(String configPath, AppConfig appConfig) async {
    final assetsDir = io.Directory('$configPath/assets');
    if (!await assetsDir.exists()) {
      await assetsDir.create();
    }

    final images = _collectImages(appConfig);
    
    for (final entry in images.entries) {
      final imageAsset = entry.value;
      if (imageAsset.data != null) {
        final imageFile = io.File('${assetsDir.path}/${imageAsset.fileName}');
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