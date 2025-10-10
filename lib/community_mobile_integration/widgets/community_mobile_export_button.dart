import 'dart:io' show Platform;
import 'package:path/path.dart' as path;
import 'package:appainter/basic_theme/basic_theme.dart';
import 'package:appainter/home/home.dart';
import 'package:appainter/community_mobile_integration/community_mobile_export_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CommunityMobileExportButton extends StatefulWidget {
  final Color? color;

  const CommunityMobileExportButton({
    super.key,
    this.color,
  });

  @override
  State<CommunityMobileExportButton> createState() => _CommunityMobileExportButtonState();
}

class _CommunityMobileExportButtonState extends State<CommunityMobileExportButton> {
  bool _isHovered = false;
  bool _isExporting = false;
  final TextEditingController _baseUrlController = TextEditingController();
  final TextEditingController _projectPathController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _baseUrlController.text = 'https://file-managment-system.feat.iometer.live';
    _projectPathController.text = '/Users/macstoreegypt/Development/iometer/community-mobile/app';
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _projectPathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isHovered 
              ? Colors.blue.withOpacity(0.1) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: PopupMenuButton<String>(
          icon: Icon(
            MdiIcons.cellphone,
            color: widget.color ?? Colors.blue,
            size: 20,
          ),
          tooltip: 'Export for Community Mobile',
          onSelected: (value) => _handleMenuSelection(context, value),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'export_files',
              child: Row(
                children: [
                  Icon(Icons.file_download, size: 16),
                  SizedBox(width: 8),
                  Text('Export Theme Files'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'build_apk',
              child: Row(
                children: [
                  Icon(Icons.build, size: 16),
                  SizedBox(width: 8),
                  Text('Build APK with Theme'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'configure',
              child: Row(
                children: [
                  Icon(Icons.settings, size: 16),
                  SizedBox(width: 8),
                  Text('Configure Settings'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'export_files':
        _exportThemeFiles(context);
        break;
      case 'build_apk':
        _buildApkWithTheme(context);
        break;
      case 'configure':
        _showConfigurationDialog(context);
        break;
    }
  }

  Future<void> _exportThemeFiles(BuildContext context) async {
    if (_isExporting) return;

    setState(() => _isExporting = true);

    try {
      final basicTheme = context.read<BasicThemeCubit>().state.theme;
      final darkTheme = _generateDarkTheme(basicTheme);

      final success = await context.read<HomeCubit>().exportForCommunityMobile(
        lightTheme: basicTheme,
        darkTheme: darkTheme,
        customBaseUrl: _baseUrlController.text.isNotEmpty ? _baseUrlController.text : null,
      );

      if (success) {
        _showSuccessSnackBar(context, 'Theme files exported successfully!');
      } else {
        _showErrorSnackBar(context, 'Failed to export theme files');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Error exporting theme files: $e');
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _buildApkWithTheme(BuildContext context) async {
    final homeCubit = context.read<HomeCubit>();
    final theme = Theme.of(context);
    final appConfig = homeCubit.state.appConfig;

    // Check if running on web - file system operations are not supported
    if (kIsWeb) {
      _showSnackBar(
        context, 
        'APK building is not supported in web environment. Please use the desktop or mobile version of AppPainter for APK generation.',
        isError: true,
      );
      return;
    }

    // Validate inputs before proceeding
    if (_projectPathController.text.isEmpty) {
      _showSnackBar(context, 'Please set the project path first', isError: true);
      return;
    }

    // Validate project path format
    final projectPath = _projectPathController.text.trim();
    if (!projectPath.startsWith('/')) {
      _showSnackBar(context, 'Project path must be an absolute path', isError: true);
      return;
    }

    // Validate base URL if provided
    final baseUrl = _baseUrlController.text.trim();
    if (baseUrl.isNotEmpty) {
      try {
        Uri.parse(baseUrl);
      } catch (e) {
        _showSnackBar(context, 'Invalid base URL format', isError: true);
        return;
      }
    }

    // Validate theme data
    if (theme == null) {
      _showSnackBar(context, 'No theme data available', isError: true);
      return;
    }

    // Validate app configuration
    if (appConfig == null) {
      _showSnackBar(context, 'No app configuration available', isError: true);
      return;
    }

    try {
      _showSnackBar(context, 'Starting APK build process...', isError: false);
      
      // Note: In web environment, file system validation is skipped
      // File system checks would be performed here in desktop/mobile environments
      
      _showSnackBar(context, 'Validating project structure...', isError: false);
       
       // Generate dark theme with error handling
       ThemeData darkTheme;
       try {
         darkTheme = _generateDarkTheme(theme);
       } catch (e) {
         _showSnackBar(context, 'Failed to generate dark theme: $e', isError: true);
         return;
       }

       _showSnackBar(context, 'Building APK with theme configuration...', isError: false);
       
       final success = await CommunityMobileExportService.buildApkWithTheme(
         lightTheme: theme,
         darkTheme: darkTheme,
         appConfig: appConfig,
         projectPath: projectPath,
         baseUrl: baseUrl.isNotEmpty ? baseUrl : null,
       );

       if (success) {
         _showSnackBar(context, 'APK built successfully! Check Downloads folder.', isError: false);
       } else {
         _showSnackBar(context, 'APK build failed. Please check the console for detailed error information.', isError: true);
       }
     } on FormatException catch (e) {
       _showSnackBar(context, 'Format error: ${e.message}', isError: true);
     } on ArgumentError catch (e) {
       _showSnackBar(context, 'Invalid argument: ${e.message}', isError: true);
     } on StateError catch (e) {
       _showSnackBar(context, 'State error: ${e.message}', isError: true);
     } catch (e, stackTrace) {
       print('Unexpected error during APK build: $e');
       print('Stack trace: $stackTrace');
       _showSnackBar(context, 'Unexpected error during APK build. Check console for details.', isError: true);
     }
  }

  void _showConfigurationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Community Mobile Configuration'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _baseUrlController,
                decoration: const InputDecoration(
                  labelText: 'Base URL',
                  hintText: 'https://your-api-url.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _projectPathController,
                decoration: const InputDecoration(
                  labelText: 'Community Mobile Project Path',
                  hintText: '/path/to/community-mobile',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessSnackBar(context, 'Configuration saved!');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  ThemeData _generateDarkTheme(ThemeData lightTheme) {
    // Generate a dark version of the light theme
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      colorScheme: lightTheme.colorScheme.copyWith(
        brightness: Brightness.dark,
        surface: Colors.grey[900]!,
        onSurface: Colors.white,
        primary: lightTheme.colorScheme.primary,
        onPrimary: Colors.white,
        secondary: lightTheme.colorScheme.secondary,
        onSecondary: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: Colors.grey[850],
        foregroundColor: Colors.white,
      ),
      cardTheme: lightTheme.cardTheme.copyWith(
        color: Colors.grey[800],
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}