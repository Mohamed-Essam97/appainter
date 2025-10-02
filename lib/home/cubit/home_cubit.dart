import 'package:appainter/advanced_theme/advanced_theme.dart';
import 'package:appainter/analytics/analytics.dart';
import 'package:appainter/home/home.dart';
import 'package:appainter/app_config/app_config.dart';
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

  HomeCubit({
    required this.homeRepo,
    required this.advancedThemeCubit,
    required this.analyticsRepo,
  }) : super(HomeState(appConfig: AppConfig.defaultConfig()));

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

  Future<void> themeExported(ThemeData theme) async {
    final mode = state.editMode;
    analyticsRepo.logExportTheme(AnalyticsAction.start, mode);

    final result = await homeRepo.exportThemeWithConfig(theme, state.appConfig);
    final action =
        result ? AnalyticsAction.complete : AnalyticsAction.incomplete;
    analyticsRepo.logExportTheme(action, mode);
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

  void updateAppName(String name) {
    final updatedConfig = AppConfig(
      logo: state.appConfig.logo,
      icon: state.appConfig.icon,
      name: name,
      version: state.appConfig.version,
      packageName: state.appConfig.packageName,
    );
    emit(state.copyWith(appConfig: updatedConfig));
  }

  void updateAppVersion(String version) {
    final updatedConfig = AppConfig(
      logo: state.appConfig.logo,
      icon: state.appConfig.icon,
      name: state.appConfig.name,
      version: version,
      packageName: state.appConfig.packageName,
    );
    emit(state.copyWith(appConfig: updatedConfig));
  }

  void updatePackageName(String packageName) {
    final updatedConfig = AppConfig(
      logo: state.appConfig.logo,
      icon: state.appConfig.icon,
      name: state.appConfig.name,
      version: state.appConfig.version,
      packageName: packageName,
    );
    emit(state.copyWith(appConfig: updatedConfig));
  }

  void updateAppIcon(ImageAsset icon) {
    final updatedConfig = AppConfig(
      logo: state.appConfig.logo,
      icon: icon,
      name: state.appConfig.name,
      version: state.appConfig.version,
      packageName: state.appConfig.packageName,
    );
    emit(state.copyWith(appConfig: updatedConfig));
  }

  void updateAppLogo(AppLogo logo) {
    final updatedConfig = AppConfig(
      logo: logo,
      icon: state.appConfig.icon,
      name: state.appConfig.name,
      version: state.appConfig.version,
      packageName: state.appConfig.packageName,
    );
    emit(state.copyWith(appConfig: updatedConfig));
  }
}
