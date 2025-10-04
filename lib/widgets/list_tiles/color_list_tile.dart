import 'package:appainter/services/services.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorListTile extends StatefulWidget {
  final String title;
  final String? tooltip;
  final Color color;
  final void Function(Color) onColorChanged;
  final bool enableOpacity;

  const ColorListTile({
    super.key,
    required this.title,
    required this.color,
    required this.onColorChanged,
    this.enableOpacity = true,
    this.tooltip,
  });

  @override
  State<ColorListTile> createState() => _ColorListTileState();
}

class _ColorListTileState extends State<ColorListTile> {
  late TextEditingController _hexController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _hexController = TextEditingController(text: widget.color.hex);
  }

  @override
  void didUpdateWidget(ColorListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color && !_isEditing) {
      _hexController.text = widget.color.hex;
    }
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  void _onHexChanged(String value) {
    if (value.length == 6) {
      try {
        final color = Color(int.parse('FF$value', radix: 16));
        widget.onColorChanged(color);
      } catch (e) {
        // Invalid hex color, ignore
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.grey[900]?.withOpacity(0.3)
            : Colors.grey[100]?.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark 
              ? Colors.grey[700]?.withOpacity(0.3) ?? Colors.grey
              : Colors.grey[300]?.withOpacity(0.6) ?? Colors.grey,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // Color swatch
            GestureDetector(
              onTap: () async {
                final prevColor = widget.color;
                final colorChanged = await WidgetService.showColorPicker(
                  context: context,
                  color: widget.color,
                  onColorChanged: widget.onColorChanged,
                  enableOpacity: widget.enableOpacity,
                );

                if (!colorChanged) {
                  widget.onColorChanged(prevColor);
                }
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isDark 
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark 
                          ? Colors.black.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.colorize,
                  color: isDark ? Colors.white : Colors.black54,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Title and hex input
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark 
                          ? Colors.white.withOpacity(0.9)
                          : Colors.black.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDark 
                          ? Colors.black.withOpacity(0.3)
                          : Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isDark 
                            ? Colors.grey[600]?.withOpacity(0.3) ?? Colors.grey
                            : Colors.grey[400]?.withOpacity(0.5) ?? Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _hexController,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        color: isDark 
                            ? Colors.white.withOpacity(0.8)
                            : Colors.black.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: InputBorder.none,
                        hintText: 'RRGGBB',
                        hintStyle: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          color: isDark 
                              ? Colors.grey[500]
                              : Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                        prefixText: '#',
                        prefixStyle: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          color: isDark 
                              ? Colors.grey[400]
                              : Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                        isDense: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9A-Fa-f]'),
                        ),
                        LengthLimitingTextInputFormatter(6),
                        UpperCaseTextFormatter(),
                      ],
                      onChanged: _onHexChanged,
                      onTap: () => setState(() => _isEditing = true),
                      onEditingComplete: () =>
                          setState(() => _isEditing = false),
                      onSubmitted: (_) => setState(() => _isEditing = false),
                    ),
                  ),
                ],
              ),
            ),

            // Tooltip icon
            if (widget.tooltip != null) ...[
              const SizedBox(width: 8),
              Tooltip(
                message: widget.tooltip!,
                child: Icon(
                  Icons.help_outline,
                  size: 16,
                  color: isDark 
                      ? Colors.grey[500]
                      : Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
