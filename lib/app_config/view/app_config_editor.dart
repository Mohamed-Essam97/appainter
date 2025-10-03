import 'package:appainter/app_config/app_config.dart';
import 'package:appainter/common/common.dart';
import 'package:appainter/home/home.dart';
import 'package:appainter/widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppConfigEditor extends StatelessWidget {
  const AppConfigEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return MyExpansionPanelList(
      items: [
        _AppInfoSection(),
        _AppLogoSection(),
        _AppVariationsSection(),
      ],
    );
  }
}

class _AppInfoSection extends ExpansionPanelItem {
  const _AppInfoSection({super.key});

  @override
  String get header => 'App Information';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SideBySideList(
          padding: kPaddingAll,
          children: [
            _TextFieldRow(
              label: 'App Name',
              value: state.appConfig.name,
              onChanged: (value) =>
                  context.read<HomeCubit>().updateAppName(value),
            ),
            _TextFieldRow(
              label: 'Version',
              value: state.appConfig.version,
              onChanged: (value) =>
                  context.read<HomeCubit>().updateAppVersion(value),
            ),
            _TextFieldRow(
              label: 'Package Name',
              value: state.appConfig.packageName,
              onChanged: (value) =>
                  context.read<HomeCubit>().updatePackageName(value),
            ),
            _ImagePickerRow(
              label: 'App Icon',
              imageAsset: state.appConfig.icon,
              onChanged: (imageAsset) {
                if (imageAsset != null) {
                  context.read<HomeCubit>().updateAppIcon(imageAsset);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _AppLogoSection extends ExpansionPanelItem {
  const _AppLogoSection({super.key});

  @override
  String get header => 'App Logos';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SideBySideList(
          padding: kPaddingAll,
          children: [
            _ImagePickerRow(
              label: 'Default Logo',
              imageAsset: state.appConfig.logo.defaultLogo,
              onChanged: (imageAsset) => _updateLogo(context, state.appConfig,
                  defaultLogo: imageAsset),
            ),
            _ImagePickerRow(
              label: 'Dark Logo',
              imageAsset: state.appConfig.logo.dark,
              onChanged: (imageAsset) =>
                  _updateLogo(context, state.appConfig, dark: imageAsset),
            ),
            _ImagePickerRow(
              label: 'Small Logo',
              imageAsset: state.appConfig.logo.small,
              onChanged: (imageAsset) =>
                  _updateLogo(context, state.appConfig, small: imageAsset),
            ),
            _ImagePickerRow(
              label: 'Splash Screen Logo',
              imageAsset: state.appConfig.logo.splashScreen,
              onChanged: (imageAsset) => _updateLogo(context, state.appConfig,
                  splashScreen: imageAsset),
            ),
          ],
        );
      },
    );
  }

  void _updateLogo(
    BuildContext context,
    AppConfig config, {
    ImageAsset? defaultLogo,
    ImageAsset? dark,
    ImageAsset? small,
    ImageAsset? splashScreen,
  }) {
    final updatedLogo = config.logo.copyWith(
      defaultLogo: defaultLogo,
      dark: dark,
      small: small,
      splashScreen: splashScreen,
    );
    context.read<HomeCubit>().updateAppLogo(updatedLogo);
  }
}

class _TextFieldRow extends StatelessWidget {
  const _TextFieldRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            initialValue: value,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImagePickerRow extends StatelessWidget {
  const _ImagePickerRow({
    required this.label,
    required this.imageAsset,
    required this.onChanged,
  });

  final String label;
  final ImageAsset? imageAsset;
  final ValueChanged<ImageAsset?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageAsset != null) ...[
                _buildImagePreview(imageAsset!),
                const SizedBox(height: 8),
              ],
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(),
                    child: Text(
                        imageAsset == null ? 'Select Image' : 'Change Image'),
                  ),
                  if (imageAsset != null)
                    TextButton(
                      onPressed: () => onChanged(null),
                      child: const Text('Remove'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(ImageAsset imageAsset) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageAsset.data != null
            ? Image.memory(
                imageAsset.data!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              )
            : Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          final imageAsset = ImageAsset(
            fileName: file.name,
            data: file.bytes!,
          );
          onChanged(imageAsset);
        }
      }
    } catch (e) {
      // Handle error - could show a snackbar or dialog
      debugPrint('Error picking image: $e');
    }
  }
}

class _AppVariationsSection extends ExpansionPanelItem {
  const _AppVariationsSection({super.key});

  @override
  String get header => 'UI Component Variations';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SideBySideList(
          padding: kPaddingAll,
          children: [
            _VariationDropdownRow(
              label: 'Feeds Card',
              value: state.appConfig.variations.feedsCardType,
              options: const ['feedCard_v1', 'feedCard_v2', 'feedCard_v3'],
              onChanged: (value) => _updateVariations(context, state.appConfig,
                  feedsCardType: value),
            ),
            _VariationDropdownRow(
              label: 'Facility Request Card',
              value: state.appConfig.variations.facilityRequestCardType,
              options: const [
                'facilityRequestCard_v1',
                'facilityRequestCard_v2'
              ],
              onChanged: (value) => _updateVariations(context, state.appConfig,
                  facilityRequestCardType: value),
            ),
            _VariationDropdownRow(
              label: 'Identity Badge QR Code',
              value: state.appConfig.variations.identityBadgeQRCodeType,
              options: const [
                'identityBadgeQRCode_v1',
                'identityBadgeQRCode_v2'
              ],
              onChanged: (value) => _updateVariations(context, state.appConfig,
                  identityBadgeQRCodeType: value),
            ),
            _VariationDropdownRow(
              label: 'Gate Pass Card',
              value: state.appConfig.variations.gatePassCardType,
              options: const ['gatePassCard_v1', 'gatePassCard_v2'],
              onChanged: (value) => _updateVariations(context, state.appConfig,
                  gatePassCardType: value),
            ),
            _VariationDropdownRow(
              label: 'Invitation Card',
              value: state.appConfig.variations.invitationCardType,
              options: const ['invitationCard_v1', 'invitationCard_v2'],
              onChanged: (value) => _updateVariations(context, state.appConfig,
                  invitationCardType: value),
            ),
            _VariationDropdownRow(
              label: 'Dues Card Widget',
              value: state.appConfig.variations.duesCardWidgetType,
              options: const ['duesCardWidget_v1', 'duesCardWidget_v2'],
              onChanged: (value) => _updateVariations(context, state.appConfig,
                  duesCardWidgetType: value),
            ),
            _VariationDropdownRow(
              label: 'Community Request Card',
              value: state.appConfig.variations.communityRequestCardType,
              options: const [
                'communityRequestCard_v1',
                'communityRequestCard_v2'
              ],
              onChanged: (value) => _updateVariations(context, state.appConfig,
                  communityRequestCardType: value),
            ),
            _VariationDropdownRow(
              label: 'Profile Header',
              value: state.appConfig.variations.profileHeaderType,
              options: const ['profileHeader_v1', 'profileHeader_v2'],
              onChanged: (value) => _updateVariations(context, state.appConfig,
                  profileHeaderType: value),
            ),
            _VariationDropdownRow(
              label: 'FAQs',
              value: state.appConfig.variations.faqsType,
              options: const ['faqs_v1', 'faqs_v2'],
              onChanged: (value) =>
                  _updateVariations(context, state.appConfig, faqsType: value),
            ),
            _VariationDropdownRow(
              label: 'Language Selection',
              value: state.appConfig.variations.languageSelectionType,
              options: const ['languageSelection_v1', 'languageSelection_v2'],
              onChanged: (value) => _updateVariations(context, state.appConfig,
                  languageSelectionType: value),
            ),
            _VariationDropdownRow(
              label: 'Contact Us Screen',
              value: state.appConfig.variations.contactUsScreenType,
              options: const ['contactUsScreen_v1', 'contactUsScreen_v2'],
              onChanged: (value) => _updateVariations(context, state.appConfig,
                  contactUsScreenType: value),
            ),
            _VariationDropdownRow(
              label: 'Community Guidelines',
              value: state.appConfig.variations.communityGuidelinesType,
              options: const [
                'communityGuidelines_v1',
                'communityGuidelines_v2'
              ],
              onChanged: (value) => _updateVariations(context, state.appConfig,
                  communityGuidelinesType: value),
            ),
            _VariationDropdownRow(
              label: 'Filled Tab Type',
              value: state.appConfig.variations.filledTabType,
              options: const ['filledTabType_v1', 'filledTabType_v2'],
              onChanged: (value) => _updateVariations(context, state.appConfig,
                  filledTabType: value),
            ),
            _VariationDropdownRow(
              label: 'Border Tab Type',
              value: state.appConfig.variations.borderTabType,
              options: const ['borderTabType_v1', 'borderTabType_v2'],
              onChanged: (value) => _updateVariations(context, state.appConfig,
                  borderTabType: value),
            ),
            _VariationDropdownRow(
              label: 'Property Selector Type',
              value: state.appConfig.variations.propertySelectorType,
              options: const [
                'propertySelectorType_v1',
                'propertySelectorType_v2'
              ],
              onChanged: (value) => _updateVariations(context, state.appConfig,
                  propertySelectorType: value),
            ),
          ],
        );
      },
    );
  }

  void _updateVariations(
    BuildContext context,
    AppConfig appConfig, {
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
    final updatedVariations = appConfig.variations.copyWith(
      feedsCardType: feedsCardType,
      facilityRequestCardType: facilityRequestCardType,
      facilityRequestDetailsType: facilityRequestDetailsType,
      facilityServiceCardType: facilityServiceCardType,
      facilityCategoryCardType: facilityCategoryCardType,
      facilityInfoRowType: facilityInfoRowType,
      accessKeySelectorType: accessKeySelectorType,
      identityBadgeQRCodeType: identityBadgeQRCodeType,
      gatePassCardType: gatePassCardType,
      invitationCardType: invitationCardType,
      duesCardWidgetType: duesCardWidgetType,
      duesDetailsType: duesDetailsType,
      communityCategoryGridItemType: communityCategoryGridItemType,
      communityRequestCardType: communityRequestCardType,
      communityRequestDetailsType: communityRequestDetailsType,
      profileHeaderType: profileHeaderType,
      profileItemType: profileItemType,
      faqsType: faqsType,
      languageSelectionType: languageSelectionType,
      contactUsScreenType: contactUsScreenType,
      communityGuidelinesType: communityGuidelinesType,
      filledTabType: filledTabType,
      borderTabType: borderTabType,
      propertySelectorType: propertySelectorType,
    );

    context.read<HomeCubit>().updateAppVariations(updatedVariations);
  }
}

class _VariationDropdownRow extends StatelessWidget {
  const _VariationDropdownRow({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: options.contains(value) ? value : options.first,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            isDense: true,
          ),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
        const SizedBox(height: 12),
        _VariationPreview(variationType: options.contains(value) ? value : options.first),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _VariationPreview extends StatelessWidget {
  const _VariationPreview({required this.variationType});

  final String variationType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/variations/$variationType.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported, 
                       color: Colors.grey[400], 
                       size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Preview not available',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
