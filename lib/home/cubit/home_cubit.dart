import 'package:appainter/advanced_theme/advanced_theme.dart';
import 'package:appainter/analytics/analytics.dart';
import 'package:appainter/home/home.dart';
import 'package:appainter/app_config/app_config.dart';
import 'package:appainter/community_mobile_integration/community_mobile_export_service.dart';
import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'home_cubit.g.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepo;
  final AnalyticsRepository analyticsRepo;
  final AdvancedThemeCubit advancedThemeCubit;
  final CommunityMobileExportService _communityMobileExportService;

  HomeCubit({
    required this.homeRepo,
    required this.advancedThemeCubit,
    required this.analyticsRepo,
    CommunityMobileExportService? communityMobileExportService,
  }) : _communityMobileExportService = communityMobileExportService ?? CommunityMobileExportService(),
       super(HomeState(appConfig: AppConfig.defaultConfig()));

  void editModeChanged(EditMode mode) {
    if (mode != state.editMode) {
      emit(state.copyWith(editMode: mode));
      analyticsRepo.logChangeEditMode(mode);
    }
  }

  Future<void> themeUsageFetched() async {
    final thtmeUsage = await homeRepo.fetchThemeUsage();
    emit(state.copyWith(themeUsage: thtmeUsage));
  }

  void sdkShowed() => emit(state.copyWith(isSdkShowed: true));

  Future<void> themeImported() async {
    emit(state.copyWith(isImportingTheme: true));
    analyticsRepo.logImportTheme(AnalyticsAction.start);

    final theme = await homeRepo.importTheme();
    emit(state.copyWith(isImportingTheme: false));

    if (theme != null) {
      advancedThemeCubit.themeChanged(theme);
      emit(state.copyWith(editMode: EditMode.advanced));
      analyticsRepo.logImportTheme(AnalyticsAction.complete);
    } else {
      analyticsRepo.logImportTheme(AnalyticsAction.incomplete);
    }
  }

  void themeExported(ThemeData theme) {
    homeRepo.exportThemeWithConfig(theme, state.appConfig);
  }

  Future<void> themeModeFetched() async {
    late final ThemeMode mode;
    final isDark = await homeRepo.getIsDarkTheme();
    if (isDark != null) {
      mode = getThemeMode(isDark);
    } else {
      mode = ThemeMode.system;
    }

    emit(state.copyWith(status: HomeStatus.success, themeMode: mode));
  }

  Future<void> themeModeChanged(bool isDark) async {
    await homeRepo.setIsDarkTheme(isDark);
    emit(state.copyWith(themeMode: getThemeMode(isDark)));
  }

  @visibleForTesting
  ThemeMode getThemeMode(bool isDark) {
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void updateAppConfig(AppConfig newConfig) {
    emit(state.copyWith(appConfig: newConfig));
  }

  void updateDrawerConfig(DrawerConfig drawerConfig) {
    final updatedAppConfig = state.appConfig.copyWith(drawer: drawerConfig);
    emit(state.copyWith(appConfig: updatedAppConfig));
  }

  void updateAppName(String name) {
    final updatedConfig = state.appConfig.copyWith(name: name);
    emit(state.copyWith(appConfig: updatedConfig));
  }

  void updateAppVersion(String version) {
    final updatedConfig = state.appConfig.copyWith(version: version);
    emit(state.copyWith(appConfig: updatedConfig));
  }

  void updatePackageName(String packageName) {
    final updatedConfig = state.appConfig.copyWith(packageName: packageName);
    emit(state.copyWith(appConfig: updatedConfig));
  }

  void updateAppUrl(String url) {
    final updatedConfig = state.appConfig.copyWith(url: url);
    emit(state.copyWith(appConfig: updatedConfig));
  }

  void updateAppProduction(bool isProduction) {
    final updatedConfig = state.appConfig.copyWith(isProduction: isProduction);
    emit(state.copyWith(appConfig: updatedConfig));
  }

  void updateAppIcon(ImageAsset icon) {
    final updatedConfig = state.appConfig.copyWith(icon: icon);
    emit(state.copyWith(appConfig: updatedConfig));
  }

  void updateAppLogo(AppLogo logo) {
    final updatedConfig = state.appConfig.copyWith(logo: logo);
    emit(state.copyWith(appConfig: updatedConfig));
  }

  void updateAppVariations(AppVariations variations) {
    final updatedConfig = state.appConfig.copyWith(variations: variations);
    emit(state.copyWith(appConfig: updatedConfig));
  }

  void updateAppSettings(AppSettings settings) {
    final updatedConfig = state.appConfig.copyWith(settings: settings);
    emit(state.copyWith(appConfig: updatedConfig));
  }

  void updateModulesConfig(ModulesConfig modules) {
    final updatedConfig = state.appConfig.copyWith(modules: modules);
    emit(state.copyWith(appConfig: updatedConfig));
  }

  /// Export theme and configuration for community mobile app
  Future<bool> exportForCommunityMobile({
    required ThemeData lightTheme,
    required ThemeData darkTheme,
    String? customBaseUrl,
  }) async {
    return await _communityMobileExportService.exportForCommunityMobile(
      lightTheme: lightTheme,
      darkTheme: darkTheme,
      appConfig: state.appConfig,
      customBaseUrl: customBaseUrl,
    );
  }

  /// Build APK with the selected theme configuration
  Future<bool> buildApkWithTheme({
    required ThemeData lightTheme,
    required ThemeData darkTheme,
    String? customBaseUrl,
    required String communityMobileProjectPath,
  }) async {
    return await CommunityMobileExportService.buildApkWithTheme(
      lightTheme: lightTheme,
      darkTheme: darkTheme,
      appConfig: state.appConfig,
      baseUrl: customBaseUrl,
      projectPath: communityMobileProjectPath,
    );
  }
}
