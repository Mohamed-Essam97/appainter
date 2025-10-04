import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appainter/home/home.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ndialog/ndialog.dart';

class ImportButton extends StatefulWidget {
  final Color color;

  const ImportButton({super.key, required this.color});

  @override
  State<ImportButton> createState() => _ImportButtonState();
}

class _ImportButtonState extends State<ImportButton> {
  ProgressDialog? _dialog;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.isImportingTheme) {
          _dialog = ProgressDialog(
            context,
            title: const Text('Import'),
            message: const Text('Importing theme data'),
            dismissable: false,
          )..show();
        } else if (!state.isImportingTheme) {
          _dialog?.dismiss();
        }
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isHovered 
                ? Colors.white.withOpacity(0.1) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(
              MdiIcons.applicationImport,
              color: widget.color,
              size: 20,
            ),
            tooltip: 'Import Theme',
            onPressed: () => context.read<HomeCubit>().themeImported(),
          ),
        ),
      ),
    );
  }
}
