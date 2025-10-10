import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart' as path;

/// Service to handle build automation for community mobile app
/// Manages APK generation with selected theme configuration
class BuildAutomationService {
  static const String _defaultProjectPath = '/Users/macstoreegypt/Development/iometer/community-mobile/app';
  static const String _themesPath = 'lib/configs/themes';
  static const String _assetsPath = 'assets/configs';

  /// Copy theme files to community mobile app and build APK
  static Future<bool> buildApkWithTheme({
    required String projectPath,
    required Map<String, String> themeFiles, // Map of filename -> content
    required Map<String, dynamic> appConfig,
    String? baseUrl,
  }) async {
    try {
      print('Starting APK build process...');
      
      // Validate inputs
      if (projectPath.isEmpty) {
        throw ArgumentError('Project path cannot be empty');
      }
      
      if (themeFiles.isEmpty) {
        throw ArgumentError('Theme files cannot be empty');
      }
      
      if (appConfig.isEmpty) {
        throw ArgumentError('App configuration cannot be empty');
      }
      
      // Validate project structure
      final isValidProject = await validateProjectStructure(projectPath);
      if (!isValidProject) {
        throw StateError('Invalid project structure at: $projectPath');
      }
      
      // Step 1: Copy theme files to the project
      await _copyThemeFiles(projectPath, themeFiles);
      
      // Step 2: Update app configuration
      await _updateAppConfiguration(projectPath, appConfig, baseUrl);
      
      // Step 3: Clean and get dependencies
      await _prepareBuildEnvironment(projectPath);
      
      // Step 4: Build APK
      final success = await _buildApk(projectPath);
      
      if (success) {
        print('APK build completed successfully!');
        await _copyApkToDownloads(projectPath);
      } else {
        throw StateError('APK build process failed');
      }
      
      return success;
    } on ArgumentError catch (e) {
      print('Invalid argument: ${e.message}');
      return false;
    } on StateError catch (e) {
      print('Build state error: ${e.message}');
      return false;
    } on FileSystemException catch (e) {
      print('File system error: ${e.message}');
      return false;
    } catch (e, stackTrace) {
      print('Unexpected error during APK build process: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Copy theme files to the community mobile app themes directory
  static Future<void> _copyThemeFiles(String projectPath, Map<String, String> themeFiles) async {
    try {
      final themesDir = Directory(path.join(projectPath, _themesPath));
      
      // Ensure themes directory exists
      if (!await themesDir.exists()) {
        await themesDir.create(recursive: true);
        print('Created themes directory: ${themesDir.path}');
      }
      
      // Validate theme files content
      for (final entry in themeFiles.entries) {
        final fileName = entry.key;
        final content = entry.value;
        
        if (fileName.isEmpty) {
          throw ArgumentError('Theme file name cannot be empty');
        }
        
        if (content.isEmpty) {
          throw ArgumentError('Theme file content cannot be empty for: $fileName');
        }
        
        // Validate JSON content
        try {
          jsonDecode(content);
        } catch (e) {
          throw FormatException('Invalid JSON content in theme file: $fileName');
        }
      }
      
      // Copy each theme file
      for (final entry in themeFiles.entries) {
        final fileName = entry.key;
        final content = entry.value;
        final filePath = path.join(themesDir.path, fileName);
        
        final file = File(filePath);
        
        // If file exists, delete it first to avoid permission issues
        if (await file.exists()) {
          await file.delete();
          print('Deleted existing theme file: $fileName');
        }
        
        await file.writeAsString(content);
        print('Copied theme file: $fileName');
      }
    } catch (e) {
      print('Error copying theme files: $e');
      rethrow;
    }
  }

  /// Update app configuration with new settings
  static Future<void> _updateAppConfiguration(
    String projectPath, 
    Map<String, dynamic> appConfig,
    String? baseUrl,
  ) async {
    try {
      // Validate app configuration
      if (appConfig.isEmpty) {
        throw ArgumentError('App configuration cannot be empty');
      }
      
      final configDir = Directory(path.join(projectPath, _assetsPath));
      
      // Ensure config directory exists
      if (!await configDir.exists()) {
        await configDir.create(recursive: true);
        print('Created config directory: ${configDir.path}');
      }
      
      // Update baseUrl if provided
      if (baseUrl != null && baseUrl.isNotEmpty) {
        // Validate baseUrl format
        try {
          Uri.parse(baseUrl);
        } catch (e) {
          throw FormatException('Invalid base URL format: $baseUrl');
        }
        
        if (appConfig['app'] == null) {
          appConfig['app'] = {};
        }
        appConfig['app']['baseUrl'] = baseUrl;
        print('Updated base URL to: $baseUrl');
      }
      
      // Write updated configuration to the dynamic_ui directory instead
      final dynamicConfigDir = Directory(path.join(projectPath, 'lib/configs/dynamic_ui'));
      if (!await dynamicConfigDir.exists()) {
        await dynamicConfigDir.create(recursive: true);
        print('Created dynamic config directory: ${dynamicConfigDir.path}');
      }
      
      final configFile = File(path.join(dynamicConfigDir.path, 'lasirena.json'));
      await configFile.writeAsString(_formatJson(appConfig));
      print('Updated app configuration at: ${configFile.path}');
    } catch (e) {
      print('Error updating app configuration: $e');
      rethrow;
    }
  }

  /// Prepare build environment by cleaning and getting dependencies
  static Future<void> _prepareBuildEnvironment(String projectPath) async {
    try {
      print('Preparing build environment...');
      
      // Change to parent directory for Flutter commands
      final parentProjectPath = path.dirname(projectPath);
      
      // Validate parent directory exists
      final parentDir = Directory(parentProjectPath);
      if (!await parentDir.exists()) {
        throw StateError('Parent project directory does not exist: $parentProjectPath');
      }
      
      // Check if pubspec.yaml exists in parent directory
      final pubspecFile = File(path.join(parentProjectPath, 'pubspec.yaml'));
      if (!await pubspecFile.exists()) {
        throw StateError('pubspec.yaml not found in parent directory: $parentProjectPath');
      }
      
      // Flutter clean
      print('Running flutter clean...');
      final cleanResult = await _runCommand('flutter', ['clean'], parentProjectPath);
      if (cleanResult.exitCode != 0) {
        throw StateError('Flutter clean failed with exit code: ${cleanResult.exitCode}');
      }
      
      // Flutter pub get
      print('Running flutter pub get...');
      final pubGetResult = await _runCommand('flutter', ['pub', 'get'], parentProjectPath);
      if (pubGetResult.exitCode != 0) {
        throw StateError('Flutter pub get failed with exit code: ${pubGetResult.exitCode}');
      }
      
      print('Build environment prepared successfully');
    } catch (e) {
      print('Error preparing build environment: $e');
      rethrow;
    }
  }

  /// Build the APK
  static Future<bool> _buildApk(String projectPath) async {
    try {
      print('Building APK...');
      
      // Change to parent directory for Flutter build command
      final parentProjectPath = path.dirname(projectPath);
      
      // Validate parent directory
      final parentDir = Directory(parentProjectPath);
      if (!await parentDir.exists()) {
        throw StateError('Parent project directory does not exist: $parentProjectPath');
      }
      
      final result = await _runCommand(
        'flutter', 
        ['build', 'apk', '--release'], 
        parentProjectPath,
        timeout: Duration(minutes: 15), // Increased timeout
      );
      
      if (result.exitCode == 0) {
        print('APK build completed successfully');
        return true;
      } else {
        print('APK build failed with exit code: ${result.exitCode}');
        print('Build output: ${result.stdout}');
        print('Build errors: ${result.stderr}');
        return false;
      }
    } catch (e) {
      print('Error during APK build: $e');
      return false;
    }
  }

  /// Copy built APK to Downloads folder
  static Future<void> _copyApkToDownloads(String projectPath) async {
    try {
      // The APK is built in the parent directory (community-mobile) not in app/
      final parentProjectPath = path.dirname(projectPath);
      final apkPath = path.join(parentProjectPath, 'build', 'app', 'outputs', 'flutter-apk', 'app-release.apk');
      final apkFile = File(apkPath);
      
      if (!await apkFile.exists()) {
        // Try alternative APK locations
        final alternativeApkPath = path.join(parentProjectPath, 'build', 'app', 'outputs', 'apk', 'release', 'app-release.apk');
        final alternativeApkFile = File(alternativeApkPath);
        
        if (await alternativeApkFile.exists()) {
          await _performApkCopy(alternativeApkFile);
        } else {
          throw FileSystemException('APK file not found at expected locations', apkPath);
        }
      } else {
        await _performApkCopy(apkFile);
      }
    } catch (e) {
      print('Failed to copy APK to Downloads: $e');
      rethrow;
    }
  }
  
  /// Perform the actual APK copy operation
  static Future<void> _performApkCopy(File apkFile) async {
    try {
      final homeDir = Platform.environment['HOME'];
      if (homeDir == null || homeDir.isEmpty) {
        throw StateError('HOME environment variable not found');
      }
      
      final downloadsPath = path.join(homeDir, 'Downloads');
      final downloadsDir = Directory(downloadsPath);
      
      if (!await downloadsDir.exists()) {
        throw StateError('Downloads directory does not exist: $downloadsPath');
      }
      
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newApkPath = path.join(downloadsPath, 'community-mobile-$timestamp.apk');
      
      await apkFile.copy(newApkPath);
      print('APK copied successfully to: $newApkPath');
      
      // Verify the copied file exists and has content
      final copiedFile = File(newApkPath);
      final fileSize = await copiedFile.length();
      print('Copied APK size: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB');
    } catch (e) {
      print('Error during APK copy operation: $e');
      rethrow;
    }
  }

  /// Run a command in the specified directory
  static Future<ProcessResult> _runCommand(
    String command, 
    List<String> arguments, 
    String workingDirectory, {
    Duration? timeout,
  }) async {
    print('Running: $command ${arguments.join(' ')} in $workingDirectory');
    
    final process = await Process.start(
      command,
      arguments,
      workingDirectory: workingDirectory,
    );
    
    // Handle timeout if specified
    if (timeout != null) {
      Timer(timeout, () {
        process.kill();
      });
    }
    
    final result = await process.exitCode;
    final stdout = await process.stdout.transform(utf8.decoder).join();
    final stderr = await process.stderr.transform(utf8.decoder).join();
    
    if (result != 0) {
      print('Command failed with exit code $result');
      print('STDOUT: $stdout');
      print('STDERR: $stderr');
    }
    
    return ProcessResult(process.pid, result, stdout, stderr);
  }

  /// Format JSON with proper indentation
  static String _formatJson(Map<String, dynamic> json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  /// Validate project structure
  static Future<bool> validateProjectStructure(String projectPath) async {
    try {
      final pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
      final themesDir = Directory(path.join(projectPath, _themesPath));
      
      return await pubspecFile.exists() && await themesDir.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get default project path
  static String get defaultProjectPath => _defaultProjectPath;
}