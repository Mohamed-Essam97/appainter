import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_config/models/app_config.dart';
import '../../common/consts.dart';
import '../../home/cubit/home_cubit.dart';
import '../../widgets/widgets.dart';

class ModulesEditor extends StatelessWidget {
  const ModulesEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return MyExpansionPanelList(
      items: const [
        _ModulesConfigSection(),
      ],
    );
  }
}

class _ModulesConfigSection extends ExpansionPanelItem {
  const _ModulesConfigSection({super.key});

  @override
  String get header => 'Modules Configuration';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final modules = state.appConfig.modules;
        return Padding(
          padding: kPaddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enable or disable modules for your application',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3,
                ),
                itemCount: modules.modules.length,
                itemBuilder: (context, index) {
                  final module = modules.modules[index];
                  return _ModuleToggleCard(
                    module: module,
                    onToggle: (enabled) => _toggleModule(
                      context,
                      module.id,
                      enabled,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleModule(BuildContext context, String moduleId, bool enabled) {
    final cubit = context.read<HomeCubit>();
    final currentModules = cubit.state.appConfig.modules;
    final updatedModules = currentModules.toggleModule(moduleId);
    cubit.updateModulesConfig(updatedModules);
  }
}

class _ModuleToggleCard extends StatelessWidget {
  const _ModuleToggleCard({
    required this.module,
    required this.onToggle,
  });

  final AppModule module;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: module.isEnabled
              ? Theme.of(context).primaryColor
              : isDark
                  ? colorScheme.outline
                  : Colors.grey[300]!,
          width: module.isEnabled ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: module.isEnabled
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : isDark
                ? colorScheme.surfaceContainerHighest
                : Colors.grey[50],
      ),
      child: InkWell(
        onTap: () => onToggle(!module.isEnabled),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                _getModuleIcon(module.name),
                size: 20,
                color: module.isEnabled
                    ? Theme.of(context).primaryColor
                    : isDark
                        ? colorScheme.onSurfaceVariant
                        : Colors.grey[600],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _getDisplayName(module.name),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: module.isEnabled
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: module.isEnabled
                            ? Theme.of(context).primaryColor
                            : isDark
                                ? colorScheme.onSurface
                                : Colors.grey[700],
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Switch(
                value: module.isEnabled,
                onChanged: onToggle,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getModuleIcon(String moduleName) {
    switch (moduleName.toLowerCase()) {
      case 'utilities':
        return Icons.build;
      case 'facility':
        return Icons.business;
      case 'community requests':
        return Icons.group;
      case 'smart gates':
        return Icons.sensor_door;
      case 'invitations':
        return Icons.mail;
      case 'dues':
        return Icons.payment;
      case 'documents':
        return Icons.description;
      case 'community payments':
        return Icons.account_balance_wallet;
      default:
        return Icons.extension;
    }
  }

  String _getDisplayName(String moduleName) {
    // Capitalize first letter of each word
    return moduleName
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : word,
        )
        .join(' ');
  }
}
