import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetService {
  static Future<bool> showColorPicker({
    required BuildContext context,
    required Color color,
    required ValueChanged<Color> onColorChanged,
    bool enableOpacity = true,
  }) async {
    return ColorPicker(
      key: const Key('widgetService_showColorPicker'),
      color: color,
      borderRadius: 8,
      showMaterialName: false,
      showColorCode: true,
      showColorName: false,
      enableOpacity: enableOpacity,
      enableTonalPalette: true,
      onColorChanged: onColorChanged,
      heading: Text(
        'Color Picker',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      subheading: Text(
        'Select shade',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
      tonalSubheading: Text(
        'Material 3 palette',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
      wheelSubheading: Text(
        'Color wheel',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
      pickersEnabled: const {
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.wheel: true,
      },
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        copyFormat: ColorPickerCopyFormat.numHexRRGGBB,
        copyButton: true,
        pasteButton: true,
        ctrlC: true,
        ctrlV: true,
        snackBarParseError: true,
        snackBarMessage:
            "Invalid hex color format. Use #RRGGBB format.",
      ),
    ).showPickerDialog(
      context,
      constraints: const BoxConstraints(
        minHeight: 480,
        maxWidth: 380,
      ),
    );
  }
}
