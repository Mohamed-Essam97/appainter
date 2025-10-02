import 'package:appainter/home/home.dart';
import 'package:appainter/app_config/app_config.dart';
import 'package:appainter/widgets/widgets.dart';
import 'package:appainter/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class AppConfigEditor extends StatelessWidget {
  const AppConfigEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return MyExpansionPanelList(
      items: [
        _AppInfoSection(),
        _AppLogoSection(),
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
              onChanged: (value) => context.read<HomeCubit>().updateAppName(value),
            ),
            _TextFieldRow(
              label: 'Version',
              value: state.appConfig.version,
              onChanged: (value) => context.read<HomeCubit>().updateAppVersion(value),
            ),
            _TextFieldRow(
              label: 'Package Name',
              value: state.appConfig.packageName,
              onChanged: (value) => context.read<HomeCubit>().updatePackageName(value),
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
              onChanged: (imageAsset) => _updateLogo(context, state.appConfig, defaultLogo: imageAsset),
            ),
            _ImagePickerRow(
              label: 'Dark Logo',
              imageAsset: state.appConfig.logo.dark,
              onChanged: (imageAsset) => _updateLogo(context, state.appConfig, dark: imageAsset),
            ),
            _ImagePickerRow(
              label: 'Small Logo',
              imageAsset: state.appConfig.logo.small,
              onChanged: (imageAsset) => _updateLogo(context, state.appConfig, small: imageAsset),
            ),
            _ImagePickerRow(
              label: 'Splash Screen Logo',
              imageAsset: state.appConfig.logo.splashScreen,
              onChanged: (imageAsset) => _updateLogo(context, state.appConfig, splashScreen: imageAsset),
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
                    child: Text(imageAsset == null ? 'Select Image' : 'Change Image'),
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
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
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
        if (file.bytes != null && file.name != null) {
          final imageAsset = ImageAsset(
            fileName: file.name!,
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