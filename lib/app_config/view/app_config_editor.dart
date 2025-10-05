import 'dart:typed_data';

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
        _AppSettingsSection(),
        _DrawerConfigSection(),
        // _AppVariationsSection(),
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
              onChanged: (imageAsset) => _updateLogo(
                context,
                state.appConfig,
                defaultLogo: imageAsset,
              ),
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
              onChanged: (imageAsset) => _updateLogo(
                context,
                state.appConfig,
                splashScreen: imageAsset,
              ),
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
                      imageAsset == null ? 'Select Image' : 'Change Image',
                    ),
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

class _DrawerConfigSection extends ExpansionPanelItem {
  const _DrawerConfigSection({super.key});

  @override
  String get header => 'Drawer Configuration';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final drawer = state.appConfig.drawer;
        return SideBySideList(
          padding: kPaddingAll,
          children: [
            _VariationDropdownRow(
              label: 'Drawer Type',
              value: drawer.drawerType,
              options: const ['drawer_v1', 'drawer_v2', 'drawer_v3'],
              onChanged: (value) => _updateDrawerConfig(
                context,
                state.appConfig,
                drawerType: value,
              ),
            ),
            _TextFieldRow(
              label: 'Header Title',
              value: drawer.header.title,
              onChanged: (value) => _updateDrawerConfig(
                context,
                state.appConfig,
                headerTitle: value,
              ),
            ),
            _TextFieldRow(
              label: 'Header Logo',
              value: drawer.header.logo,
              onChanged: (value) => _updateDrawerConfig(
                context,
                state.appConfig,
                headerLogo: value,
              ),
            ),
            const SizedBox(height: 16),
            _DrawerItemsList(drawer: drawer),
          ],
        );
      },
    );
  }

  void _updateDrawerConfig(
    BuildContext context,
    AppConfig appConfig, {
    String? drawerType,
    String? headerTitle,
    String? headerLogo,
  }) {
    final currentDrawer = appConfig.drawer;
    final updatedDrawer = currentDrawer.copyWith(
      drawerType: drawerType,
      header: currentDrawer.header.copyWith(
        title: headerTitle,
        logo: headerLogo,
      ),
    );
    context.read<HomeCubit>().updateDrawerConfig(updatedDrawer);
  }
}

class _DrawerItemsList extends StatelessWidget {
  const _DrawerItemsList({required this.drawer});

  final DrawerConfig drawer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Drawer Items',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddDrawerItemDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Use ReorderableListView for drag-to-sort functionality
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: drawer.items.length,
          onReorder: (oldIndex, newIndex) => _reorderDrawerItems(context, oldIndex, newIndex),
          itemBuilder: (context, index) {
            final item = drawer.items[index];
            return Padding(
              key: ValueKey(item.id),
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _DrawerItemRow(
                index: index,
                item: item,
                onRemove: () => _removeDrawerItem(context, item.id),
                onToggle: () => _toggleDrawerItem(context, item.id),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAddDrawerItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _AddDrawerItemDialog(),
    );
  }

  void _removeDrawerItem(BuildContext context, String itemId) {
    final cubit = context.read<HomeCubit>();
    final currentDrawer = cubit.state.appConfig.drawer;
    final updatedDrawer = currentDrawer.removeItem(itemId);
    cubit.updateDrawerConfig(updatedDrawer);
  }

  void _toggleDrawerItem(BuildContext context, String itemId) {
    final cubit = context.read<HomeCubit>();
    final currentDrawer = cubit.state.appConfig.drawer;
    final updatedDrawer = currentDrawer.toggleItemEnabled(itemId);
    cubit.updateDrawerConfig(updatedDrawer);
  }

  void _reorderDrawerItems(BuildContext context, int oldIndex, int newIndex) {
    final cubit = context.read<HomeCubit>();
    final currentDrawer = cubit.state.appConfig.drawer;
    final updatedDrawer = currentDrawer.reorderItems(oldIndex, newIndex);
    cubit.updateDrawerConfig(updatedDrawer);
  }
}

class _DrawerItemRow extends StatelessWidget {
  const _DrawerItemRow({
    required this.index,
    required this.item,
    required this.onRemove,
    required this.onToggle,
  });

  final int index;
  final DrawerItem item;
  final VoidCallback onRemove;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Switch(
                  value: item.isEnabled,
                  onChanged: (_) => onToggle(),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('ID: ${item.id}'),
            Text('Icon: ${item.icon}'),
            if (item.screen != null) Text('Screen: ${item.screen}'),
            if (item.action != null) Text('Action: ${item.action}'),
          ],
        ),
      ),
    );
  }
}

class _AddDrawerItemDialog extends StatefulWidget {
  @override
  State<_AddDrawerItemDialog> createState() => _AddDrawerItemDialogState();
}

class _AddDrawerItemDialogState extends State<_AddDrawerItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _iconController = TextEditingController();
  final _screenController = TextEditingController();
  final _actionController = TextEditingController();
  String _selectedType = 'screen';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Drawer Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'ID'),
                validator: (value) =>
                    value?.isEmpty == true ? 'ID is required' : null,
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Title is required' : null,
              ),
              TextFormField(
                controller: _iconController,
                decoration: const InputDecoration(labelText: 'Icon Path'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Icon is required' : null,
              ),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'screen', child: Text('Screen')),
                  DropdownMenuItem(value: 'action', child: Text('Action')),
                ],
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              if (_selectedType == 'screen')
                TextFormField(
                  controller: _screenController,
                  decoration: const InputDecoration(labelText: 'Screen Name'),
                  validator: (value) =>
                      _selectedType == 'screen' && value?.isEmpty == true
                          ? 'Screen name is required'
                          : null,
                ),
              if (_selectedType == 'action')
                TextFormField(
                  controller: _actionController,
                  decoration: const InputDecoration(labelText: 'Action Name'),
                  validator: (value) =>
                      _selectedType == 'action' && value?.isEmpty == true
                          ? 'Action name is required'
                          : null,
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addItem,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _addItem() {
    if (_formKey.currentState?.validate() == true) {
      final newItem = DrawerItem(
        id: _idController.text,
        title: _titleController.text,
        icon: _iconController.text,
        screen: _selectedType == 'screen' ? _screenController.text : null,
        action: _selectedType == 'action' ? _actionController.text : null,
      );

      final cubit = context.read<HomeCubit>();
      final currentDrawer = cubit.state.appConfig.drawer;
      final updatedDrawer = currentDrawer.addItem(newItem);
      cubit.updateDrawerConfig(updatedDrawer);

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _iconController.dispose();
    _screenController.dispose();
    _actionController.dispose();
    super.dispose();
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
              onChanged: (value) => _updateVariations(
                context,
                state.appConfig,
                feedsCardType: value,
              ),
            ),
            _VariationDropdownRow(
              label: 'Facility Request Card',
              value: state.appConfig.variations.facilityRequestCardType,
              options: const [
                'facilityRequestCard_v1',
                'facilityRequestCard_v2',
              ],
              onChanged: (value) => _updateVariations(
                context,
                state.appConfig,
                facilityRequestCardType: value,
              ),
            ),
            _VariationDropdownRow(
              label: 'Identity Badge QR Code',
              value: state.appConfig.variations.identityBadgeQRCodeType,
              options: const [
                'identityBadgeQRCode_v1',
                'identityBadgeQRCode_v2',
              ],
              onChanged: (value) => _updateVariations(
                context,
                state.appConfig,
                identityBadgeQRCodeType: value,
              ),
            ),
            _VariationDropdownRow(
              label: 'Gate Pass Card',
              value: state.appConfig.variations.gatePassCardType,
              options: const ['gatePassCard_v1', 'gatePassCard_v2'],
              onChanged: (value) => _updateVariations(
                context,
                state.appConfig,
                gatePassCardType: value,
              ),
            ),
            _VariationDropdownRow(
              label: 'Invitation Card',
              value: state.appConfig.variations.invitationCardType,
              options: const ['invitationCard_v1', 'invitationCard_v2'],
              onChanged: (value) => _updateVariations(
                context,
                state.appConfig,
                invitationCardType: value,
              ),
            ),
            _VariationDropdownRow(
              label: 'Dues Card Widget',
              value: state.appConfig.variations.duesCardWidgetType,
              options: const ['duesCardWidget_v1', 'duesCardWidget_v2'],
              onChanged: (value) => _updateVariations(
                context,
                state.appConfig,
                duesCardWidgetType: value,
              ),
            ),
            _VariationDropdownRow(
              label: 'Community Request Card',
              value: state.appConfig.variations.communityRequestCardType,
              options: const [
                'communityRequestCard_v1',
                'communityRequestCard_v2',
              ],
              onChanged: (value) => _updateVariations(
                context,
                state.appConfig,
                communityRequestCardType: value,
              ),
            ),
            _VariationDropdownRow(
              label: 'Profile Header',
              value: state.appConfig.variations.profileHeaderType,
              options: const ['profileHeader_v1', 'profileHeader_v2'],
              onChanged: (value) => _updateVariations(
                context,
                state.appConfig,
                profileHeaderType: value,
              ),
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
              onChanged: (value) => _updateVariations(
                context,
                state.appConfig,
                languageSelectionType: value,
              ),
            ),
            _VariationDropdownRow(
              label: 'Contact Us Screen',
              value: state.appConfig.variations.contactUsScreenType,
              options: const ['contactUsScreen_v1', 'contactUsScreen_v2'],
              onChanged: (value) => _updateVariations(
                context,
                state.appConfig,
                contactUsScreenType: value,
              ),
            ),
            _VariationDropdownRow(
              label: 'Community Guidelines',
              value: state.appConfig.variations.communityGuidelinesType,
              options: const [
                'communityGuidelines_v1',
                'communityGuidelines_v2',
              ],
              onChanged: (value) => _updateVariations(
                context,
                state.appConfig,
                communityGuidelinesType: value,
              ),
            ),
            _VariationDropdownRow(
              label: 'Filled Tab Type',
              value: state.appConfig.variations.filledTabType,
              options: const ['filledTabType_v1', 'filledTabType_v2'],
              onChanged: (value) => _updateVariations(
                context,
                state.appConfig,
                filledTabType: value,
              ),
            ),
            _VariationDropdownRow(
              label: 'Border Tab Type',
              value: state.appConfig.variations.borderTabType,
              options: const ['borderTabType_v1', 'borderTabType_v2'],
              onChanged: (value) => _updateVariations(
                context,
                state.appConfig,
                borderTabType: value,
              ),
            ),
            _VariationDropdownRow(
              label: 'Property Selector Type',
              value: state.appConfig.variations.propertySelectorType,
              options: const [
                'propertySelectorType_v1',
                'propertySelectorType_v2',
              ],
              onChanged: (value) => _updateVariations(
                context,
                state.appConfig,
                propertySelectorType: value,
              ),
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
          initialValue: options.contains(value) ? value : options.first,
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
          variationType: options.contains(value) ? value : options.first,
        ),
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
                  Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[400],
                    size: 20,
                  ),
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

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

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
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _FilePickerRow extends StatelessWidget {
  const _FilePickerRow({
    required this.label,
    required this.fileName,
    required this.onChanged,
    this.allowedExtensions = const ['pdf'],
  });

  final String label;
  final String? fileName;
  final ValueChanged<String?> onChanged;
  final List<String> allowedExtensions;

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
              if ((fileName ?? '').isNotEmpty) ...[
                Text(
                  fileName!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
              ],
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickFile(context),
                    child: Text(
                      (fileName ?? '').isEmpty ? 'Select File' : 'Change File',
                    ),
                  ),
                  if ((fileName ?? '').isNotEmpty)
                    TextButton(
                      onPressed: () => onChanged(''),
                      child: const Text('Clear'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        onChanged(file.name);
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick file: $e')),
      );
    }
  }
}

class _AppSettingsSection extends ExpansionPanelItem {
  const _AppSettingsSection({super.key});

  @override
  String get header => 'App Settings';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final settings = state.appConfig.settings;
        return SideBySideList(
          padding: kPaddingAll,
          children: [
            _SwitchRow(
              label: 'Private App',
              value: settings.isPrivateApp,
              onChanged: (v) => context
                  .read<HomeCubit>()
                  .updateAppSettings(settings.copyWith(isPrivateApp: v)),
            ),
            _SwitchRow(
              label: 'Have Account Selector',
              value: settings.haveAccountSelector,
              onChanged: (v) => context
                  .read<HomeCubit>()
                  .updateAppSettings(settings.copyWith(haveAccountSelector: v)),
            ),
            _FilePickerRow(
              label: 'Service Prices PDF',
              fileName: settings.communityGuidelinesPdfs.servicePricesPdf,
              onChanged: (v) => context.read<HomeCubit>().updateAppSettings(
                    settings.copyWith(
                      communityGuidelinesPdfs: settings.communityGuidelinesPdfs
                          .copyWith(servicePricesPdf: v ?? ''),
                    ),
                  ),
            ),
            _FilePickerRow(
              label: 'Owner Guide PDF',
              fileName: settings.communityGuidelinesPdfs.ownerPdf,
              onChanged: (v) => context.read<HomeCubit>().updateAppSettings(
                    settings.copyWith(
                      communityGuidelinesPdfs: settings.communityGuidelinesPdfs
                          .copyWith(ownerPdf: v ?? ''),
                    ),
                  ),
            ),
            _TextFieldRow(
              label: 'First Tab Label',
              value: settings.communityGuidelinesPdfs.firstTabLabel,
              onChanged: (v) => context.read<HomeCubit>().updateAppSettings(
                    settings.copyWith(
                      communityGuidelinesPdfs: settings.communityGuidelinesPdfs
                          .copyWith(firstTabLabel: v),
                    ),
                  ),
            ),
            _TextFieldRow(
              label: 'Second Tab Label',
              value: settings.communityGuidelinesPdfs.secondTabLabel,
              onChanged: (v) => context.read<HomeCubit>().updateAppSettings(
                    settings.copyWith(
                      communityGuidelinesPdfs: settings.communityGuidelinesPdfs
                          .copyWith(secondTabLabel: v),
                    ),
                  ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Accounts',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _AccountsEditor(accounts: settings.accounts),
          ],
        );
      },
    );
  }
}

class _AccountsEditor extends StatelessWidget {
  const _AccountsEditor({required this.accounts});

  final List<AppAccount> accounts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Account'),
            onPressed: () {
              final cubit = context.read<HomeCubit>();
              final current = List<AppAccount>.from(
                cubit.state.appConfig.settings.accounts,
              );
              current.add(
                const AppAccount(
                  accountKey: '',
                  accountName: '',
                  accountLogo: '',
                ),
              );
              cubit.updateAppSettings(
                cubit.state.appConfig.settings.copyWith(accounts: current),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < accounts.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _AccountRow(index: i, account: accounts[i]),
          ),
      ],
    );
  }
}

class _AccountRow extends StatefulWidget {
  const _AccountRow({required this.index, required this.account});

  final int index;
  final AppAccount account;

  @override
  State<_AccountRow> createState() => _AccountRowState();
}

class _AccountRowState extends State<_AccountRow> {
  Uint8List? _logoPreviewBytes;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final account = widget.account;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TextFieldRow(
              label: 'Account Key',
              value: account.accountKey,
              onChanged: (v) {
                final updated = account.copyWith(accountKey: v);
                final updatedList = List<AppAccount>.from(
                  state.appConfig.settings.accounts,
                );
                updatedList[widget.index] = updated;
                context.read<HomeCubit>().updateAppSettings(
                      state.appConfig.settings.copyWith(accounts: updatedList),
                    );
              },
            ),
            _TextFieldRow(
              label: 'Account Name',
              value: account.accountName,
              onChanged: (v) {
                final updated = account.copyWith(accountName: v);
                final updatedList = List<AppAccount>.from(
                  state.appConfig.settings.accounts,
                );
                updatedList[widget.index] = updated;
                context.read<HomeCubit>().updateAppSettings(
                      state.appConfig.settings.copyWith(accounts: updatedList),
                    );
              },
            ),
            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    'Account Logo',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_logoPreviewBytes != null) ...[
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              _logoPreviewBytes!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ] else if ((account.accountLogo).isNotEmpty) ...[
                        Text(
                          account.accountLogo,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                      ],
                      Wrap(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: _pickLogoImage,
                            child: Text(
                              (account.accountLogo).isEmpty
                                  ? 'Select Image'
                                  : 'Change Image',
                            ),
                          ),
                          if ((account.accountLogo).isNotEmpty)
                            TextButton(
                              onPressed: () {
                                setState(() => _logoPreviewBytes = null);
                                final updated =
                                    account.copyWith(accountLogo: '');
                                final updatedList = List<AppAccount>.from(
                                  state.appConfig.settings.accounts,
                                );
                                updatedList[widget.index] = updated;
                                context.read<HomeCubit>().updateAppSettings(
                                      state.appConfig.settings
                                          .copyWith(accounts: updatedList),
                                    );
                              },
                              child: const Text('Clear'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickLogoImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          setState(() => _logoPreviewBytes = file.bytes);
        }
        final cubit = context.read<HomeCubit>();
        final state = cubit.state;
        final account = widget.account;
        final updated = account.copyWith(accountLogo: file.name);
        final updatedList = List<AppAccount>.from(
          state.appConfig.settings.accounts,
        );
        updatedList[widget.index] = updated;
        cubit.updateAppSettings(
          state.appConfig.settings.copyWith(accounts: updatedList),
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }
}
