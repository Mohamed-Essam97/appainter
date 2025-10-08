import 'package:appainter/advanced_theme/advanced_theme.dart';
import 'package:appainter/app_config/app_config.dart';
import 'package:appainter/basic_theme/basic_theme.dart';
import 'package:appainter/common/common.dart';
import 'package:appainter/home/home.dart';
import 'package:appainter/modules/view/modules_editor.dart';
import 'package:appainter/theme_preview/theme_preview.dart';
import 'package:appainter/variations/view/variations_editor.dart';
import 'package:appainter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const _sdkVersion = '3.32.0+';
  static final _backgroundColorDark = Colors.grey[900]!;
  static final _backgroundColorLight = Colors.grey[200]!;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().themeUsageFetched();
  }

  bool _showFloatingPreview = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? _backgroundColorDark : _backgroundColorLight,
      appBar: _buildAppBar(isDark),
      body: BlocListener<HomeCubit, HomeState>(
        listener: _listener,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              _ScaffoldBody(
                showFloatingPreview: _showFloatingPreview,
                onToggleFloatingPreview: () {
                  setState(() {
                    _showFloatingPreview = !_showFloatingPreview;
                  });
                },
              ),
              if (_showFloatingPreview)
                ScalableDraggablePreview(
                  initialSize: const Size(300, 500),
                  minSize: const Size(200, 300),
                  maxSize: const Size(800, 1200),
                  onClose: () {
                    setState(() {
                      _showFloatingPreview = false;
                    });
                  },
                  child: const ThemePreview(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(bool isDark) {
    final color = isDark ? Colors.white : Colors.grey;
    return AppBar(
      backgroundColor: isDark ? Colors.black : Colors.white,
      actionsIconTheme: IconThemeData(color: color),
      title: Row(
        children: [
          const Image(
            image: AssetImage('assets/icon.png'),
            height: 48,
          ),
          const HorizontalPadding(
            size: PaddingSize.medium,
          ),
          Text(
            'ioMeter Theme Builder',
            style: TextStyle(
              color: color,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        ImportButton(
          key: const Key('homePage_importButton'),
          color: color,
        ),
        const HorizontalPadding(size: PaddingSize.medium),
        ExportButton(
          key: const Key('homePage_exportButton'),
          color: color,
        ),
        const HorizontalPadding(size: PaddingSize.medium),
        const AppThemeModeButton(),
        const HorizontalPadding(size: PaddingSize.medium),
        const UsageButton(key: Key('homePage_usageButton')),
        const HorizontalPadding(size: PaddingSize.medium),
        const GithubButton(key: Key('homePage_githubButton')),
        const HorizontalPadding(),
      ],
    );
  }

  void _listener(BuildContext context, HomeState state) {
    if (!state.isSdkShowed) {
      ScaffoldMessenger.of(context).showSnackBar(_buildSdkSnackBar());
      context.read<HomeCubit>().sdkShowed();
    }
  }

  SnackBar _buildSdkSnackBar() {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? _backgroundColorDark
          : _backgroundColorLight,
      duration: const Duration(seconds: 7),
      margin: EdgeInsets.only(
        left: kMargin,
        bottom: kMargin,
        right: MediaQuery.of(context).size.width * 0.7,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Supported Flutter SDK',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const VerticalPadding(),
          Text(
            'Appainter currently supports Flutter SDK: $_sdkVersion',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

class _ScaffoldBody extends StatelessWidget {
  const _ScaffoldBody({
    required this.showFloatingPreview,
    required this.onToggleFloatingPreview,
  });

  final bool showFloatingPreview;
  final VoidCallback onToggleFloatingPreview;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Vertical Sidebar Navigation
        Container(
          width: 280,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]!.withOpacity(0.8)
                : Colors.grey[100]!.withOpacity(0.8),
            border: Border(
              right: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[700]!
                    : Colors.grey[300]!,
                width: 1,
              ),
            ),
            // Glassmorphism effect
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: _VerticalSidebar(),
        ),
        // Main Content Area
        Expanded(
          child: Row(
            children: [
              // Editor Panel
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[850]!.withOpacity(0.9)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    // Glassmorphism effect
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _EditorContent(),
                  ),
                ),
              ),
              // Device Preview Panel
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[850]!.withOpacity(0.9)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    // Glassmorphism effect
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        // Preview Header with Size Toggle
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[800]
                                    : Colors.grey[50],
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[700]!
                                    : Colors.grey[200]!,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Device Preview',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Row(
                                children: [
                                  _DeviceSizeButton(
                                    Icons.phone_android,
                                    'Phone',
                                  ),
                                  const SizedBox(width: 8),
                                  _DeviceSizeButton(Icons.tablet_mac, 'Tablet'),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: onToggleFloatingPreview,
                                    icon: Icon(
                                      showFloatingPreview
                                          ? Icons.picture_in_picture
                                          : Icons.open_in_new,
                                    ),
                                    tooltip: showFloatingPreview
                                        ? 'Dock Preview'
                                        : 'Float Preview',
                                    iconSize: 18,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Preview Content
                        Expanded(
                          child: showFloatingPreview
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey[800]!.withOpacity(0.3)
                                        : Colors.grey[100]!.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.open_in_new,
                                          size: 48,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.grey[600]
                                              : Colors.grey[400],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Preview is floating',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.grey[600]
                                                    : Colors.grey[400],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const ThemePreview(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeviceSizeButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DeviceSizeButton(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () {
          // TODO: Implement device size toggle
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[700]!.withOpacity(0.5)
                : Colors.grey[200]!.withOpacity(0.5),
          ),
          child: Icon(
            icon,
            size: 18,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[300]
                : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}

class _VerticalSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            // Sidebar Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[700]!
                        : Colors.grey[300]!,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.palette,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.blue[300]
                        : Colors.blue[600],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Theme Builder',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.grey[800],
                        ),
                  ),
                ],
              ),
            ),
            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _SidebarItem(
                    icon: Icons.color_lens,
                    label: 'Basic',
                    isSelected: state.editMode == EditMode.basic,
                    onTap: () => context
                        .read<HomeCubit>()
                        .editModeChanged(EditMode.basic),
                  ),
                  _SidebarItem(
                    icon: Icons.tune,
                    label: 'Advanced',
                    isSelected: state.editMode == EditMode.advanced,
                    onTap: () => context
                        .read<HomeCubit>()
                        .editModeChanged(EditMode.advanced),
                  ),
                  _SidebarItem(
                    icon: Icons.settings,
                    label: 'App Config',
                    isSelected: state.editMode == EditMode.appConfig,
                    onTap: () => context
                        .read<HomeCubit>()
                        .editModeChanged(EditMode.appConfig),
                  ),
                  _SidebarItem(
                    icon: Icons.view_module,
                    label: 'Variations',
                    isSelected: state.editMode == EditMode.variations,
                    onTap: () => context
                        .read<HomeCubit>()
                        .editModeChanged(EditMode.variations),
                  ),
                  _SidebarItem(
                    icon: Icons.extension,
                    label: 'Modules',
                    isSelected: state.editMode == EditMode.modules,
                    onTap: () => context
                        .read<HomeCubit>()
                        .editModeChanged(EditMode.modules),
                  ),
                ],
              ),
            ),
            // Theme Configuration Panel
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]!.withOpacity(0.8)
                    : Colors.grey[50]!.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[200]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configuration',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  const Material3Switch(),
                  const SizedBox(height: 8),
                  const ThemeBrightnessSwitch(),
                ],
              ),
            ),
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[700]!
                        : Colors.grey[300]!,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(child: RandomThemeButton()),
                  const SizedBox(width: 8),
                  Expanded(child: ResetThemeButton()),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected
                  ? (isDark
                      ? Colors.blue[600]!.withOpacity(0.2)
                      : Colors.blue[50])
                  : Colors.transparent,
              border: isSelected
                  ? Border.all(
                      color: isDark ? Colors.blue[400]! : Colors.blue[300]!,
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? (isDark ? Colors.blue[300] : Colors.blue[600])
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Inter',
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? (isDark ? Colors.blue[300] : Colors.blue[600])
                            : (isDark ? Colors.grey[300] : Colors.grey[700]),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditorContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        Widget editor;
        switch (state.editMode) {
          case EditMode.basic:
            editor = const BasicThemeEditor();
            break;
          case EditMode.advanced:
            editor = const AdvancedEditor();
            break;
          case EditMode.appConfig:
            editor = const AppConfigEditor();
            break;
          case EditMode.variations:
            editor = const VariationsEditor();
            break;
          case EditMode.modules:
            editor = const ModulesEditor();
            break;
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: editor,
        );
      },
    );
  }
}

// Old tab-based components removed - now using vertical sidebar layout
