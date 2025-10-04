import 'package:flutter/material.dart';

class PresetSize {
  final String name;
  final double width;
  final double height;
  final IconData icon;

  const PresetSize({
    required this.name,
    required this.width,
    required this.height,
    required this.icon,
  });

  static const List<PresetSize> defaultPresets = [
    PresetSize(
        name: 'Phone', width: 375, height: 667, icon: Icons.phone_android),
    PresetSize(
        name: 'Tablet', width: 768, height: 1024, icon: Icons.tablet_mac),
    PresetSize(
        name: 'Desktop', width: 1200, height: 800, icon: Icons.desktop_mac),
  ];
}

class ScalableDraggablePreview extends StatefulWidget {
  final Widget child;
  final Size initialSize;
  final Size minSize;
  final Size maxSize;
  final VoidCallback? onClose;
  final List<PresetSize>? presetSizes;

  const ScalableDraggablePreview({
    super.key,
    required this.child,
    this.initialSize = const Size(300, 500),
    this.minSize = const Size(200, 300),
    this.maxSize = const Size(800, 1200),
    this.onClose,
    this.presetSizes,
  });

  @override
  State<ScalableDraggablePreview> createState() =>
      _ScalableDraggablePreviewState();
}

class _ScalableDraggablePreviewState extends State<ScalableDraggablePreview> {
  late double _width;
  late double _height;
  late double _x;
  late double _y;
  bool _isDragging = false;
  bool _isResizing = false;

  @override
  void initState() {
    super.initState();
    _width = widget.initialSize.width;
    _height = widget.initialSize.height;
    _x = 100;
    _y = 100;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _x,
      top: _y,
      child: GestureDetector(
        onPanStart: (details) {
          setState(() {
            _isDragging = true;
          });
        },
        onPanUpdate: (details) {
          if (_isDragging && !_isResizing) {
            setState(() {
              _x += details.delta.dx;
              _y += details.delta.dy;

              // Keep within screen bounds
              _x = _x.clamp(0, MediaQuery.of(context).size.width - _width);
              _y = _y.clamp(0, MediaQuery.of(context).size.height - _height);
            });
          }
        },
        onPanEnd: (details) {
          setState(() {
            _isDragging = false;
          });
        },
        child: Container(
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]!.withOpacity(0.95)
                : Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[700]!
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // Header with drag handle and close button
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[700]!
                          : Colors.grey[300]!,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Drag handle
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.drag_indicator,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Device Preview',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Size indicator and controls
                    Row(
                      children: [
                        // Preset size dropdown
                        PopupMenuButton<PresetSize>(
                          icon: Icon(
                            Icons.aspect_ratio,
                            size: 16,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                          ),
                          itemBuilder: (context) =>
                              (widget.presetSizes ?? PresetSize.defaultPresets)
                                  .map(
                                    (preset) => PopupMenuItem<PresetSize>(
                                      value: preset,
                                      child: Row(
                                        children: [
                                          Icon(preset.icon, size: 16),
                                          const SizedBox(width: 8),
                                          Text(preset.name),
                                          const Spacer(),
                                          Text(
                                            '${preset.width.toInt()}×${preset.height.toInt()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  fontFamily: 'monospace',
                                                  fontSize: 10,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onSelected: (preset) {
                            setState(() {
                              _width = preset.width.clamp(
                                  widget.minSize.width, widget.maxSize.width);
                              _height = preset.height.clamp(
                                  widget.minSize.height, widget.maxSize.height);
                            });
                          },
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[700]
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_width.toInt()}×${_height.toInt()}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontFamily: 'monospace',
                                      fontSize: 10,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    // Close button
                    if (widget.onClose != null)
                      IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(Icons.close),
                        iconSize: 18,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                  ],
                ),
              ),
              // Content area
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: widget.child,
                ),
              ),
              // Resize handles
              ..._buildResizeHandles(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildResizeHandles() {
    const handleSize = 12.0;
    const handleColor = Colors.blue;

    return [
      // Bottom-right corner handle
      Positioned(
        bottom: -6,
        right: -6,
        child: GestureDetector(
          onPanStart: (details) {
            setState(() {
              _isResizing = true;
            });
          },
          onPanUpdate: (details) {
            setState(() {
              _width = (_width + details.delta.dx)
                  .clamp(widget.minSize.width, widget.maxSize.width);
              _height = (_height + details.delta.dy)
                  .clamp(widget.minSize.height, widget.maxSize.height);
            });
          },
          onPanEnd: (details) {
            setState(() {
              _isResizing = false;
            });
          },
          child: Container(
            width: handleSize,
            height: handleSize,
            decoration: BoxDecoration(
              color: handleColor,
              borderRadius: BorderRadius.circular(handleSize / 2),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeDownRight,
              child: Container(),
            ),
          ),
        ),
      ),
      // Bottom handle
      Positioned(
        bottom: -6,
        left: _width / 2 - handleSize / 2,
        child: GestureDetector(
          onPanStart: (details) {
            setState(() {
              _isResizing = true;
            });
          },
          onPanUpdate: (details) {
            setState(() {
              _height = (_height + details.delta.dy)
                  .clamp(widget.minSize.height, widget.maxSize.height);
            });
          },
          onPanEnd: (details) {
            setState(() {
              _isResizing = false;
            });
          },
          child: Container(
            width: handleSize,
            height: handleSize,
            decoration: BoxDecoration(
              color: handleColor,
              borderRadius: BorderRadius.circular(handleSize / 2),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeDown,
              child: Container(),
            ),
          ),
        ),
      ),
      // Right handle
      Positioned(
        right: -6,
        top: _height / 2 - handleSize / 2,
        child: GestureDetector(
          onPanStart: (details) {
            setState(() {
              _isResizing = true;
            });
          },
          onPanUpdate: (details) {
            setState(() {
              _width = (_width + details.delta.dx)
                  .clamp(widget.minSize.width, widget.maxSize.width);
            });
          },
          onPanEnd: (details) {
            setState(() {
              _isResizing = false;
            });
          },
          child: Container(
            width: handleSize,
            height: handleSize,
            decoration: BoxDecoration(
              color: handleColor,
              borderRadius: BorderRadius.circular(handleSize / 2),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeRight,
              child: Container(),
            ),
          ),
        ),
      ),
    ];
  }
}
