import 'package:equatable/equatable.dart';
import 'dart:typed_data';

class ImageAsset extends Equatable {
  final String fileName;
  final Uint8List? data;

  const ImageAsset({
    required this.fileName,
    this.data,
  });

  @override
  List<Object?> get props => [fileName, data];

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'hasData': data != null,
    };
  }

  factory ImageAsset.fromJson(Map<String, dynamic> json) {
    return ImageAsset(
      fileName: json['fileName'] as String,
      // Note: data is not restored from JSON as it's for export only
    );
  }

  ImageAsset copyWith({
    String? fileName,
    Uint8List? data,
  }) {
    return ImageAsset(
      fileName: fileName ?? this.fileName,
      data: data ?? this.data,
    );
  }
}

class AppConfig extends Equatable {
  final AppLogo logo;
  final ImageAsset icon;
  final String name;
  final String version;
  final String packageName;

  const AppConfig({
    required this.logo,
    required this.icon,
    required this.name,
    required this.version,
    required this.packageName,
  });

  factory AppConfig.defaultConfig() {
    return AppConfig(
      logo: AppLogo(
        defaultLogo: ImageAsset(fileName: 'logo_light.png'),
        dark: ImageAsset(fileName: 'logo_dark.png'),
        small: ImageAsset(fileName: 'logo_small.png'),
        splashScreen: ImageAsset(fileName: 'splash.png'),
      ),
      icon: ImageAsset(fileName: 'app_icon.png'),
      name: 'Lasirena',
      version: '1.0.0',
      packageName: 'com.lasirena.app',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logo': logo.toJson(),
      'icon': icon.toJson(),
      'name': name,
      'version': version,
      'packageName': packageName,
    };
  }

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      logo: AppLogo.fromJson(json['logo'] as Map<String, dynamic>),
      icon: ImageAsset.fromJson(json['icon'] as Map<String, dynamic>),
      name: json['name'] as String,
      version: json['version'] as String,
      packageName: json['packageName'] as String,
    );
  }

  @override
  List<Object?> get props => [logo, icon, name, version, packageName];
}

class AppLogo extends Equatable {
  final ImageAsset defaultLogo;
  final ImageAsset dark;
  final ImageAsset small;
  final ImageAsset splashScreen;

  const AppLogo({
    required this.defaultLogo,
    required this.dark,
    required this.small,
    required this.splashScreen,
  });

  Map<String, dynamic> toJson() {
    return {
      'default': defaultLogo.toJson(),
      'dark': dark.toJson(),
      'small': small.toJson(),
      'splashScreen': splashScreen.toJson(),
    };
  }

  factory AppLogo.fromJson(Map<String, dynamic> json) {
    return AppLogo(
      defaultLogo: ImageAsset.fromJson(json['default'] as Map<String, dynamic>),
      dark: ImageAsset.fromJson(json['dark'] as Map<String, dynamic>),
      small: ImageAsset.fromJson(json['small'] as Map<String, dynamic>),
      splashScreen: ImageAsset.fromJson(json['splashScreen'] as Map<String, dynamic>),
    );
  }

  AppLogo copyWith({
    ImageAsset? defaultLogo,
    ImageAsset? dark,
    ImageAsset? small,
    ImageAsset? splashScreen,
  }) {
    return AppLogo(
      defaultLogo: defaultLogo ?? this.defaultLogo,
      dark: dark ?? this.dark,
      small: small ?? this.small,
      splashScreen: splashScreen ?? this.splashScreen,
    );
  }

  @override
  List<Object?> get props => [defaultLogo, dark, small, splashScreen];
}
