import 'package:equatable/equatable.dart';
import 'dart:typed_data';

class DrawerItem extends Equatable {
  final String id;
  final String title;
  final String icon;
  final String? screen;
  final String? action;
  final bool isEnabled;

  const DrawerItem({
    required this.id,
    required this.title,
    required this.icon,
    this.screen,
    this.action,
    this.isEnabled = true,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'title': title,
      'icon': icon,
      'isEnabled': isEnabled,
    };

    if (screen != null) json['screen'] = screen;
    if (action != null) json['action'] = action;

    return json;
  }

  factory DrawerItem.fromJson(Map<String, dynamic> json) {
    return DrawerItem(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      screen: json['screen'] as String?,
      action: json['action'] as String?,
      isEnabled: json['isEnabled'] as bool? ?? true,
    );
  }

  DrawerItem copyWith({
    String? id,
    String? title,
    String? icon,
    String? screen,
    String? action,
    bool? isEnabled,
  }) {
    return DrawerItem(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      screen: screen ?? this.screen,
      action: action ?? this.action,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  List<Object?> get props => [id, title, icon, screen, action, isEnabled];
}

class DrawerHeader extends Equatable {
  final String logo;
  final String title;

  const DrawerHeader({
    required this.logo,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      'logo': logo,
      'title': title,
    };
  }

  factory DrawerHeader.fromJson(Map<String, dynamic> json) {
    return DrawerHeader(
      logo: json['logo'] as String,
      title: json['title'] as String,
    );
  }

  DrawerHeader copyWith({
    String? logo,
    String? title,
  }) {
    return DrawerHeader(
      logo: logo ?? this.logo,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [logo, title];
}

class DrawerConfig extends Equatable {
  final String drawerType;
  final DrawerHeader header;
  final List<DrawerItem> items;

  const DrawerConfig({
    required this.drawerType,
    required this.header,
    required this.items,
  });

  factory DrawerConfig.defaultConfig() {
    return DrawerConfig(
      drawerType: 'drawer_v2',
      header: const DrawerHeader(
        logo: 'assets/app/lasirena_logo_light.png',
        title: 'Menu',
      ),
      items: const [
        DrawerItem(
          id: 'drawer2',
          title: 'drawer.gatePass',
          icon: 'assets/svg/gate_pass.svg',
          screen: 'gatePass',
        ),
        DrawerItem(
          id: 'drawer3',
          title: 'drawer.invitations',
          icon: 'assets/svg/invitations.svg',
          screen: 'invitations',
        ),
        DrawerItem(
          id: 'drawer4',
          title: 'drawer.utilities',
          icon: 'assets/svg/utilities.svg',
          screen: 'utilities',
        ),
        DrawerItem(
          id: 'drawer5',
          title: 'drawer.dues',
          icon: 'assets/svg/dues.svg',
          screen: 'dues',
        ),
        DrawerItem(
          id: 'drawer6',
          title: 'drawer.community_payments',
          icon: 'assets/svg/communityPayments.svg',
          screen: 'communityPayments',
        ),
        DrawerItem(
          id: 'drawer7',
          title: 'drawer.requests',
          icon: 'assets/svg/requests.svg',
          screen: 'communityRequests',
        ),
        DrawerItem(
          id: 'drawer8',
          title: 'drawer.documents',
          icon: 'assets/svg/documents.svg',
          screen: 'documents',
        ),
        DrawerItem(
          id: 'drawer9',
          title: 'drawer.community_guidelines',
          icon: 'assets/svg/guidelines.svg',
          screen: 'communityGuidelines',
        ),
        DrawerItem(
          id: 'drawer10',
          title: 'drawer.contact_us',
          icon: 'assets/svg/contact.svg',
          screen: 'contactUs',
        ),
        DrawerItem(
          id: 'drawer11',
          title: 'drawer.sendCommunityRequest',
          icon: 'assets/svg/contact.svg',
          screen: 'sendCommunityRequest',
        ),
        DrawerItem(
          id: 'drawer12',
          title: 'drawer.biometric',
          icon: 'assets/svg/contact.svg',
          screen: 'biometric',
        ),
        DrawerItem(
          id: 'drawer13',
          title: 'drawer.manage_saved_users',
          icon: 'assets/svg/settings.svg',
          screen: 'manageSavedUsers',
        ),
        DrawerItem(
          id: 'drawer14',
          title: 'drawer.logout',
          icon: 'assets/svg/logout.svg',
          action: 'logout',
        ),
      ],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'drawerType': drawerType,
      'header': header.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory DrawerConfig.fromJson(Map<String, dynamic> json) {
    return DrawerConfig(
      drawerType: json['drawerType'] as String? ?? 'drawer_v2',
      header: DrawerHeader.fromJson(json['header'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((item) => DrawerItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  DrawerConfig copyWith({
    String? drawerType,
    DrawerHeader? header,
    List<DrawerItem>? items,
  }) {
    return DrawerConfig(
      drawerType: drawerType ?? this.drawerType,
      header: header ?? this.header,
      items: items ?? this.items,
    );
  }

  DrawerConfig addItem(DrawerItem item) {
    return copyWith(items: [...items, item]);
  }

  DrawerConfig removeItem(String itemId) {
    return copyWith(items: items.where((item) => item.id != itemId).toList());
  }

  DrawerConfig updateItem(String itemId, DrawerItem updatedItem) {
    return copyWith(
      items: items.map((item) => item.id == itemId ? updatedItem : item).toList(),
    );
  }

  DrawerConfig toggleItemEnabled(String itemId) {
    return copyWith(
      items: items.map((item) =>
        item.id == itemId ? item.copyWith(isEnabled: !item.isEnabled) : item
      ).toList(),
    );
  }

  @override
  List<Object?> get props => [drawerType, header, items];
}

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
  final AppSettings settings;
  final AppVariations variations;
  final DrawerConfig drawer;

  const AppConfig({
    required this.logo,
    required this.icon,
    required this.name,
    required this.version,
    required this.packageName,
    required this.settings,
    required this.variations,
    required this.drawer,
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
      settings: AppSettings.defaultSettings(),
      variations: AppVariations.defaultVariations(),
      drawer: DrawerConfig.defaultConfig(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logo': logo.toJson(),
      'icon': icon.toJson(),
      'name': name,
      'version': version,
      'packageName': packageName,
      'settings': settings.toJson(),
      'variations': variations.toJson(),
      'drawer': drawer.toJson(),
    };
  }

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      logo: AppLogo.fromJson(json['logo'] as Map<String, dynamic>),
      icon: ImageAsset.fromJson(json['icon'] as Map<String, dynamic>),
      name: json['name'] as String,
      version: json['version'] as String,
      packageName: json['packageName'] as String,
      settings: AppSettings.fromJson(json['settings'] as Map<String, dynamic>? ?? const {}),
      variations: AppVariations.fromJson(json['variations'] as Map<String, dynamic>),
      drawer: DrawerConfig.fromJson(json['drawer'] as Map<String, dynamic>? ?? const {}),
    );
  }

  @override
  List<Object?> get props => [logo, icon, name, version, packageName, settings, variations, drawer];

  AppConfig copyWith({
    AppLogo? logo,
    ImageAsset? icon,
    String? name,
    String? version,
    String? packageName,
    AppSettings? settings,
    AppVariations? variations,
    DrawerConfig? drawer,
  }) {
    return AppConfig(
      logo: logo ?? this.logo,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      version: version ?? this.version,
      packageName: packageName ?? this.packageName,
      settings: settings ?? this.settings,
      variations: variations ?? this.variations,
      drawer: drawer ?? this.drawer,
    );
  }
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

class AppSettings extends Equatable {
  final bool isPrivateApp;
  final bool haveAccountSelector;
  final CommunityGuidelinesPdfs communityGuidelinesPdfs;
  final List<AppAccount> accounts;

  const AppSettings({
    required this.isPrivateApp,
    required this.haveAccountSelector,
    required this.communityGuidelinesPdfs,
    required this.accounts,
  });

  factory AppSettings.defaultSettings() {
    return AppSettings(
      isPrivateApp: true,
      haveAccountSelector: true,
      communityGuidelinesPdfs: const CommunityGuidelinesPdfs(
        servicePricesPdf: 'assets/service_prices.pdf',
        ownerPdf: 'assets/owner.pdf',
        firstTabLabel: 'Service Prices',
        secondTabLabel: 'Owner Guide',
      ),
      accounts: const [
        AppAccount(
          accountKey: 'LASIRENA_PALM',
          accountName: 'Palm Beach Sokhna',
          accountLogo: 'assets/config/lasarina_palm.png',
        ),
        AppAccount(
          accountKey: 'LASIRENA_NORTH',
          accountName: 'North Cost',
          accountLogo: 'assets/config/lasarina_north.png',
        ),
      ],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isPrivateApp': isPrivateApp,
      'haveAccountSelector': haveAccountSelector,
      'communityGuidelinesPdfs': communityGuidelinesPdfs.toJson(),
      'accounts': accounts.map((a) => a.toJson()).toList(),
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      isPrivateApp: json['isPrivateApp'] as bool? ?? true,
      haveAccountSelector: json['haveAccountSelector'] as bool? ?? true,
      communityGuidelinesPdfs: CommunityGuidelinesPdfs.fromJson(
        json['communityGuidelinesPdfs'] as Map<String, dynamic>? ?? const {},
      ),
      accounts: ((json['accounts'] as List?) ?? [])
          .map((e) => AppAccount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  AppSettings copyWith({
    bool? isPrivateApp,
    bool? haveAccountSelector,
    CommunityGuidelinesPdfs? communityGuidelinesPdfs,
    List<AppAccount>? accounts,
  }) {
    return AppSettings(
      isPrivateApp: isPrivateApp ?? this.isPrivateApp,
      haveAccountSelector: haveAccountSelector ?? this.haveAccountSelector,
      communityGuidelinesPdfs:
          communityGuidelinesPdfs ?? this.communityGuidelinesPdfs,
      accounts: accounts ?? this.accounts,
    );
  }

  @override
  List<Object?> get props => [isPrivateApp, haveAccountSelector, communityGuidelinesPdfs, accounts];
}

class CommunityGuidelinesPdfs extends Equatable {
  final String servicePricesPdf;
  final String ownerPdf;
  final String firstTabLabel;
  final String secondTabLabel;

  const CommunityGuidelinesPdfs({
    required this.servicePricesPdf,
    required this.ownerPdf,
    required this.firstTabLabel,
    required this.secondTabLabel,
  });

  Map<String, dynamic> toJson() {
    return {
      'servicePricesPdf': servicePricesPdf,
      'ownerPdf': ownerPdf,
      'firstTabLabel': firstTabLabel,
      'secondTabLabel': secondTabLabel,
    };
  }

  factory CommunityGuidelinesPdfs.fromJson(Map<String, dynamic> json) {
    return CommunityGuidelinesPdfs(
      servicePricesPdf: json['servicePricesPdf'] as String? ?? 'assets/service_prices.pdf',
      ownerPdf: json['ownerPdf'] as String? ?? 'assets/owner.pdf',
      firstTabLabel: json['firstTabLabel'] as String? ?? 'Service Prices',
      secondTabLabel: json['secondTabLabel'] as String? ?? 'Owner Guide',
    );
  }

  CommunityGuidelinesPdfs copyWith({
    String? servicePricesPdf,
    String? ownerPdf,
    String? firstTabLabel,
    String? secondTabLabel,
  }) {
    return CommunityGuidelinesPdfs(
      servicePricesPdf: servicePricesPdf ?? this.servicePricesPdf,
      ownerPdf: ownerPdf ?? this.ownerPdf,
      firstTabLabel: firstTabLabel ?? this.firstTabLabel,
      secondTabLabel: secondTabLabel ?? this.secondTabLabel,
    );
  }

  @override
  List<Object?> get props => [servicePricesPdf, ownerPdf, firstTabLabel, secondTabLabel];
}

class AppAccount extends Equatable {
  final String accountKey;
  final String accountName;
  final String accountLogo;

  const AppAccount({
    required this.accountKey,
    required this.accountName,
    required this.accountLogo,
  });

  Map<String, dynamic> toJson() {
    return {
      'accountKey': accountKey,
      'accountName': accountName,
      'accountLogo': accountLogo,
    };
  }

  factory AppAccount.fromJson(Map<String, dynamic> json) {
    return AppAccount(
      accountKey: json['accountKey'] as String,
      accountName: json['accountName'] as String,
      accountLogo: json['accountLogo'] as String,
    );
  }

  AppAccount copyWith({
    String? accountKey,
    String? accountName,
    String? accountLogo,
  }) {
    return AppAccount(
      accountKey: accountKey ?? this.accountKey,
      accountName: accountName ?? this.accountName,
      accountLogo: accountLogo ?? this.accountLogo,
    );
  }

  @override
  List<Object?> get props => [accountKey, accountName, accountLogo];
}
