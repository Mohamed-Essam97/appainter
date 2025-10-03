import 'package:appainter/app_config/app_config.dart';
import 'package:appainter/common/common.dart';
import 'package:appainter/home/home.dart';
import 'package:appainter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VariationsEditor extends StatelessWidget {
  const VariationsEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return MyExpansionPanelList(
      items: const [
        _VariationsControlsSection(),
      ],
    );
  }
}

class _VariationsControlsSection extends ExpansionPanelItem {
  const _VariationsControlsSection({super.key});

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
        _VariationPreview(
            variationType: options.contains(value) ? value : options.first),
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
                      color: Colors.grey[400], size: 20),
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