import 'package:equatable/equatable.dart';
import 'dart:typed_data';

class AppVariations extends Equatable {
  final String feedsCardType;
  final String facilityRequestCardType;
  final String facilityRequestDetailsType;
  final String facilityServiceCardType;
  final String facilityCategoryCardType;
  final String facilityInfoRowType;
  final String accessKeySelectorType;
  final String identityBadgeQRCodeType;
  final String gatePassCardType;
  final String invitationCardType;
  final String duesCardWidgetType;
  final String duesDetailsType;
  final String communityCategoryGridItemType;
  final String communityRequestCardType;
  final String communityRequestDetailsType;
  final String profileHeaderType;
  final String profileItemType;
  final String faqsType;
  final String languageSelectionType;
  final String contactUsScreenType;
  final String communityGuidelinesType;
  final String filledTabType;
  final String borderTabType;
  final String propertySelectorType;

  const AppVariations({
    required this.feedsCardType,
    required this.facilityRequestCardType,
    required this.facilityRequestDetailsType,
    required this.facilityServiceCardType,
    required this.facilityCategoryCardType,
    required this.facilityInfoRowType,
    required this.accessKeySelectorType,
    required this.identityBadgeQRCodeType,
    required this.gatePassCardType,
    required this.invitationCardType,
    required this.duesCardWidgetType,
    required this.duesDetailsType,
    required this.communityCategoryGridItemType,
    required this.communityRequestCardType,
    required this.communityRequestDetailsType,
    required this.profileHeaderType,
    required this.profileItemType,
    required this.faqsType,
    required this.languageSelectionType,
    required this.contactUsScreenType,
    required this.communityGuidelinesType,
    required this.filledTabType,
    required this.borderTabType,
    required this.propertySelectorType,
  });

  factory AppVariations.defaultVariations() {
    return const AppVariations(
      feedsCardType: 'feedsCardType_v1',
      facilityRequestCardType: 'facilityRequestCardType_v1',
      facilityRequestDetailsType: 'facilityRequestDetailsType_v1',
      facilityServiceCardType: 'facilityServiceCardType_v1',
      facilityCategoryCardType: 'facilityCategoryCardType_v1',
      facilityInfoRowType: 'facilityInfoRowType_v1',
      accessKeySelectorType: 'accessKeySelectorType_v1',
      identityBadgeQRCodeType: 'identityBadgeQRCodeType_v1',
      gatePassCardType: 'gatePassCardType_v1',
      invitationCardType: 'invitationCardType_v1',
      duesCardWidgetType: 'duesCardWidgetType_v1',
      duesDetailsType: 'duesDetailsType_v1',
      communityCategoryGridItemType: 'communityCategoryGridItemType_v1',
      communityRequestCardType: 'communityRequestCardType_v1',
      communityRequestDetailsType: 'communityRequestDetailsType_v1',
      profileHeaderType: 'profileHeaderType_v1',
      profileItemType: 'profileItemType_v1',
      faqsType: 'faqsType_v1',
      languageSelectionType: 'languageSelectionType_v1',
      contactUsScreenType: 'contactUsScreenType_v1',
      communityGuidelinesType: 'communityGuidelinesType_v1',
      filledTabType: 'filledTabType_v1',
      borderTabType: 'borderTabType_v1',
      propertySelectorType: 'propertySelectorType_v1',
    );
  }

  @override
  List<Object> get props => [
        feedsCardType,
        facilityRequestCardType,
        facilityRequestDetailsType,
        facilityServiceCardType,
        facilityCategoryCardType,
        facilityInfoRowType,
        accessKeySelectorType,
        identityBadgeQRCodeType,
        gatePassCardType,
        invitationCardType,
        duesCardWidgetType,
        duesDetailsType,
        communityCategoryGridItemType,
        communityRequestCardType,
        communityRequestDetailsType,
        profileHeaderType,
        profileItemType,
        faqsType,
        languageSelectionType,
        contactUsScreenType,
        communityGuidelinesType,
        filledTabType,
        borderTabType,
        propertySelectorType,
      ];

  Map<String, dynamic> toJson() {
    return {
      'feeds': {'cardType': feedsCardType},
      'facility': {
        'facilityRequestCardType': facilityRequestCardType,
        'facilityRequestDetailsType': facilityRequestDetailsType,
        'facilityServiceCardType': facilityServiceCardType,
        'facilityCategoryCardType': facilityCategoryCardType,
        'facilityInfoRowType': facilityInfoRowType,
      },
      'identity_badge': {
        'accessKeySelectorType': accessKeySelectorType,
        'identityBadgeQRCodeType': identityBadgeQRCodeType,
      },
      'gatePass': {'gatePassCardType': gatePassCardType},
      'invitations': {'invitationCardType': invitationCardType},
      'dues': {
        'duesCardWidgetType': duesCardWidgetType,
        'duesDetailsType': duesDetailsType,
      },
      'communityRequests': {
        'communityCategoryGridItemType': communityCategoryGridItemType,
        'communityRequestCardType': communityRequestCardType,
        'communityRequestDetailsType': communityRequestDetailsType,
      },
      'profile': {
        'profileHeaderType': profileHeaderType,
        'profileItemType': profileItemType,
      },
      'faqs': {'faqsType': faqsType},
      'language': {'languageSelectionType': languageSelectionType},
      'contactUs': {'contactUsScreenType': contactUsScreenType},
      'communityGuidelines': {'communityGuidelinesType': communityGuidelinesType},
      'filledTabType': filledTabType,
      'borderTabType': borderTabType,
      'propertySelectorType': propertySelectorType,
    };
  }

  factory AppVariations.fromJson(Map<String, dynamic> json) {
    return AppVariations(
      feedsCardType: json['feeds']?['cardType'] ?? 'feedCard_v2',
      facilityRequestCardType: json['facility']?['facilityRequestCardType'] ?? 'facilityRequestCard_v2',
      facilityRequestDetailsType: json['facility']?['facilityRequestDetailsType'] ?? 'facilityRequestDetails_v2',
      facilityServiceCardType: json['facility']?['facilityServiceCardType'] ?? 'facilityServiceCard_v2',
      facilityCategoryCardType: json['facility']?['facilityCategoryCardType'] ?? 'facilityCategoryCard_v2',
      facilityInfoRowType: json['facility']?['facilityInfoRowType'] ?? 'facilityInfoRow_v2',
      accessKeySelectorType: json['identity_badge']?['accessKeySelectorType'] ?? 'accessKeySelector_v2',
      identityBadgeQRCodeType: json['identity_badge']?['identityBadgeQRCodeType'] ?? 'identityBadgeQRCode_v2',
      gatePassCardType: json['gatePass']?['gatePassCardType'] ?? 'gatePassCard_v2',
      invitationCardType: json['invitations']?['invitationCardType'] ?? 'invitationCard_v2',
      duesCardWidgetType: json['dues']?['duesCardWidgetType'] ?? 'duesCardWidget_v2',
      duesDetailsType: json['dues']?['duesDetailsType'] ?? 'duesDetails_v2',
      communityCategoryGridItemType: json['communityRequests']?['communityCategoryGridItemType'] ?? 'communityCategoryGridItem_v2',
      communityRequestCardType: json['communityRequests']?['communityRequestCardType'] ?? 'communityRequestCard_v2',
      communityRequestDetailsType: json['communityRequests']?['communityRequestDetailsType'] ?? 'communityRequestDetails_v2',
      profileHeaderType: json['profile']?['profileHeaderType'] ?? 'profileHeader_v2',
      profileItemType: json['profile']?['profileItemType'] ?? 'profileItem_v2',
      faqsType: json['faqs']?['faqsType'] ?? 'faqs_v2',
      languageSelectionType: json['language']?['languageSelectionType'] ?? 'languageSelection_v2',
      contactUsScreenType: json['contactUs']?['contactUsScreenType'] ?? 'contactUsScreen_v2',
      communityGuidelinesType: json['communityGuidelines']?['communityGuidelinesType'] ?? 'communityGuidelines_v2',
      filledTabType: json['filledTabType'] ?? 'filledTab_v2',
      borderTabType: json['borderTabType'] ?? 'borderedTab_v2',
      propertySelectorType: json['propertySelectorType'] ?? 'propertySelector_v2',
    );
  }

  AppVariations copyWith({
    String? feedsCardType,
    String? facilityRequestCardType,
    String? facilityRequestDetailsType,
    String? facilityServiceCardType,
    String? facilityCategoryCardType,
    String? facilityInfoRowType,
    String? accessKeySelectorType,
    String? identityBadgeQRCodeType,
    String? gatePassCardType,
    String? invitationCardType,
    String? duesCardWidgetType,
    String? duesDetailsType,
    String? communityCategoryGridItemType,
    String? communityRequestCardType,
    String? communityRequestDetailsType,
    String? profileHeaderType,
    String? profileItemType,
    String? faqsType,
    String? languageSelectionType,
    String? contactUsScreenType,
    String? communityGuidelinesType,
    String? filledTabType,
    String? borderTabType,
    String? propertySelectorType,
  }) {
    return AppVariations(
      feedsCardType: feedsCardType ?? this.feedsCardType,
      facilityRequestCardType: facilityRequestCardType ?? this.facilityRequestCardType,
      facilityRequestDetailsType: facilityRequestDetailsType ?? this.facilityRequestDetailsType,
      facilityServiceCardType: facilityServiceCardType ?? this.facilityServiceCardType,
      facilityCategoryCardType: facilityCategoryCardType ?? this.facilityCategoryCardType,
      facilityInfoRowType: facilityInfoRowType ?? this.facilityInfoRowType,
      accessKeySelectorType: accessKeySelectorType ?? this.accessKeySelectorType,
      identityBadgeQRCodeType: identityBadgeQRCodeType ?? this.identityBadgeQRCodeType,
      gatePassCardType: gatePassCardType ?? this.gatePassCardType,
      invitationCardType: invitationCardType ?? this.invitationCardType,
      duesCardWidgetType: duesCardWidgetType ?? this.duesCardWidgetType,
      duesDetailsType: duesDetailsType ?? this.duesDetailsType,
      communityCategoryGridItemType: communityCategoryGridItemType ?? this.communityCategoryGridItemType,
      communityRequestCardType: communityRequestCardType ?? this.communityRequestCardType,
      communityRequestDetailsType: communityRequestDetailsType ?? this.communityRequestDetailsType,
      profileHeaderType: profileHeaderType ?? this.profileHeaderType,
      profileItemType: profileItemType ?? this.profileItemType,
      faqsType: faqsType ?? this.faqsType,
      languageSelectionType: languageSelectionType ?? this.languageSelectionType,
      contactUsScreenType: contactUsScreenType ?? this.contactUsScreenType,
      communityGuidelinesType: communityGuidelinesType ?? this.communityGuidelinesType,
      filledTabType: filledTabType ?? this.filledTabType,
      borderTabType: borderTabType ?? this.borderTabType,
      propertySelectorType: propertySelectorType ?? this.propertySelectorType,
    );
  }
}

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
  final AppVariations variations;

  const AppConfig({
    required this.logo,
    required this.icon,
    required this.name,
    required this.version,
    required this.packageName,
    required this.variations,
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
      variations: AppVariations.defaultVariations(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logo': logo.toJson(),
      'icon': icon.toJson(),
      'name': name,
      'version': version,
      'packageName': packageName,
      'variations': variations.toJson(),
    };
  }

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      logo: AppLogo.fromJson(json['logo'] as Map<String, dynamic>),
      icon: ImageAsset.fromJson(json['icon'] as Map<String, dynamic>),
      name: json['name'] as String,
      version: json['version'] as String,
      packageName: json['packageName'] as String,
      variations: AppVariations.fromJson(json['variations'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [logo, icon, name, version, packageName, variations];
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
