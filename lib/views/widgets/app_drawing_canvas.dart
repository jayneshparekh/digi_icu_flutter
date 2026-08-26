import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:get/get.dart';

/// Representation of a single drawn stroke/path on the canvas.
class DrawingPath {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final bool isEraser;

  DrawingPath({
    required this.points,
    required this.color,
    required this.strokeWidth,
    this.isEraser = false,
  });
}

/// A highly customizable drawing canvas widget with integrated editing tools.
class AppDrawingCanvas extends StatefulWidget {
  /// Optional width of the canvas. Defaults to flexible/infinity.
  final double? width;

  /// Optional height of the canvas. Defaults to flexible/infinity.
  final double? height;

  /// Canvas background color. Defaults to white.
  final Color backgroundColor;

  /// Initial pen color. Defaults to black.
  final Color initialPenColor;

  /// Initial stroke line width. Defaults to 3.0.
  final double initialStrokeWidth;

  /// Controls whether the top toolbar is displayed. Defaults to true.
  final bool showToolbar;

  /// Callback when user taps save. Provides PNG encoded bytes [Uint8List].
  final ValueChanged<Uint8List>? onSave;

  /// Custom list of palette colors to pick from.
  final List<Color>? paletteColors;

  /// Decoration for the canvas container border/box.
  final BoxDecoration? canvasDecoration;

  const AppDrawingCanvas({
    super.key,
    this.width,
    this.height,
    this.backgroundColor = AppColors.white,
    this.initialPenColor = AppColors.pureBlack,
    this.initialStrokeWidth = 3.0,
    this.showToolbar = true,
    this.onSave,
    this.paletteColors,
    this.canvasDecoration,
  });

  @override
  State<AppDrawingCanvas> createState() => AppDrawingCanvasState();
}

class AppDrawingCanvasState extends State<AppDrawingCanvas> {
  final List<DrawingPath> _paths = [];
  final List<DrawingPath> _undoStack = [];

  DrawingPath? _currentPath;
  late Color _selectedColor;
  late double _selectedStrokeWidth;
  bool _isEraserMode = false;

  late List<Color> _availableColors;

  static const String _iconPathPrefix = 'assets/icons/svg/';

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialPenColor;
    _selectedStrokeWidth = widget.initialStrokeWidth;
    _availableColors = widget.paletteColors ??
        const [
          AppColors.pureBlack,
          Colors.purple,
          AppColors.blue,
          AppColors.teal,
          AppColors.success,
          Colors.yellow,
          AppColors.warning,
          AppColors.error,
          Colors.brown,
          AppColors.medicalGray,
        ];
  }

  void _onPanStart(DragStartDetails details, RenderBox box) {
    final localPosition = box.globalToLocal(details.globalPosition);
    setState(() {
      _currentPath = DrawingPath(
        points: [localPosition],
        color: _isEraserMode ? widget.backgroundColor : _selectedColor,
        strokeWidth: _selectedStrokeWidth,
        isEraser: _isEraserMode,
      );
      _undoStack.clear();
    });
  }

  void _onPanUpdate(DragUpdateDetails details, RenderBox box) {
    final localPosition = box.globalToLocal(details.globalPosition);
    if (_currentPath != null) {
      setState(() {
        _currentPath!.points.add(localPosition);
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentPath != null) {
      setState(() {
        _paths.add(_currentPath!);
        _currentPath = null;
      });
    }
  }

  void _undo() {
    if (_paths.isNotEmpty) {
      setState(() {
        _undoStack.add(_paths.removeLast());
      });
    }
  }

  void _redo() {
    if (_undoStack.isNotEmpty) {
      setState(() {
        _paths.add(_undoStack.removeLast());
      });
    }
  }

  void _clear() {
    if (_paths.isNotEmpty) {
      setState(() {
        _undoStack.addAll(_paths.reversed);
        _paths.clear();
      });
    }
  }

  /// Exports current drawing as PNG image bytes.
  Future<Uint8List?> exportToPngImage({Size canvasSize = const Size(800, 1200)}) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height),
    );

    // Draw background
    final bgPaint = Paint()..color = widget.backgroundColor;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height),
      bgPaint,
    );

    // Draw strokes
    for (final pathData in _paths) {
      _drawPathOnCanvas(canvas, pathData);
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(
      canvasSize.width.toInt(),
      canvasSize.height.toInt(),
    );
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Future<void> _handleSave() async {
    final bytes = await exportToPngImage();
    if (bytes != null && widget.onSave != null) {
      widget.onSave!(bytes);
      _clear();
    }
  }

  void _showColorPicker() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'select_color'.tr,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _availableColors.map((color) {
                    final isSelected = !_isEraserMode && _selectedColor == color;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                          _isEraserMode = false;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.teal : AppColors.medicalGray,
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                color: color.computeLuminance() > 0.5 ? AppColors.pureBlack : AppColors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showStrokeWidthPicker() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'stroke_width'.tr,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('thin'.tr),
                        Expanded(
                          child: Slider(
                            value: _selectedStrokeWidth,
                            min: 1.0,
                            max: 25.0,
                            activeColor: AppColors.teal,
                            onChanged: (val) {
                              setModalState(() {
                                _selectedStrokeWidth = val;
                              });
                              setState(() {
                                _selectedStrokeWidth = val;
                              });
                            },
                          ),
                        ),
                        Text('thick'.tr),
                      ],
                    ),
                    Text('${_selectedStrokeWidth.toStringAsFixed(1)} px'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showToolbar) _buildToolbar(),
        const SizedBox(height: 8),
        _buildCanvasArea(),
      ],
    );
  }

  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButton(
            assetName: 'ink_pen.svg',
            tooltip: 'pen'.tr,
            isActive: !_isEraserMode,
            activeColor: _selectedColor,
            onPressed: () {
              setState(() {
                _isEraserMode = false;
              });
            },
          ),
          _buildIconButton(
            assetName: 'ink_eraser.svg',
            tooltip: 'eraser'.tr,
            isActive: _isEraserMode,
            onPressed: () {
              setState(() {
                _isEraserMode = true;
              });
            },
          ),
          _buildIconButton(
            assetName: 'palette.svg',
            tooltip: 'color_palette'.tr,
            onPressed: _showColorPicker,
          ),
          _buildIconButton(
            assetName: 'line_weight.svg',
            tooltip: 'line_width'.tr,
            onPressed: _showStrokeWidthPicker,
          ),
          _buildIconButton(
            assetName: 'ic_undo.svg',
            tooltip: 'undo'.tr,
            isEnabled: _paths.isNotEmpty,
            onPressed: _undo,
          ),
          _buildIconButton(
            assetName: 'ic_redo.svg',
            tooltip: 'redo'.tr,
            isEnabled: _undoStack.isNotEmpty,
            onPressed: _redo,
          ),
          _buildIconButton(
            assetName: 'delete.svg',
            tooltip: 'clear_canvas'.tr,
            onPressed: _clear,
          ),
          _buildIconButton(
            assetName: 'ic_save.svg',
            tooltip: 'save_png'.tr,
            onPressed: _handleSave,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required String assetName,
    required String tooltip,
    VoidCallback? onPressed,
    bool isActive = false,
    bool isEnabled = true,
    Color? activeColor,
  }) {
    final Color tintColor = !isEnabled
        ? AppColors.medicalGray
        : isActive
            ? (activeColor ?? AppColors.teal)
            : AppColors.coolGray;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: isActive
              ? BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: SvgPicture.asset(
            '$_iconPathPrefix$assetName',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(tintColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Widget _buildCanvasArea() {
    final defaultDecoration = BoxDecoration(
      color: widget.backgroundColor,
      border: Border.all(color: AppColors.pureBlack, width: 2.0),
      borderRadius: BorderRadius.circular(4.0),
    );

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: widget.canvasDecoration ?? defaultDecoration,
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onPanStart: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                _onPanStart(details, box);
              },
              onPanUpdate: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                _onPanUpdate(details, box);
              },
              onPanEnd: _onPanEnd,
              child: CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _DrawingPainter(
                  paths: _paths,
                  currentPath: _currentPath,
                  backgroundColor: widget.backgroundColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPath> paths;
  final DrawingPath? currentPath;
  final Color backgroundColor;

  _DrawingPainter({
    required this.paths,
    required this.currentPath,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    for (final pathData in paths) {
      _drawPathOnCanvas(canvas, pathData);
    }

    if (currentPath != null) {
      _drawPathOnCanvas(canvas, currentPath!);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) {
    return true;
  }
}

void _drawPathOnCanvas(Canvas canvas, DrawingPath pathData) {
  if (pathData.points.isEmpty) {
    return;
  }

  final paint = Paint()
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = pathData.strokeWidth
    ..style = PaintingStyle.stroke;

  if (pathData.isEraser) {
    paint.blendMode = BlendMode.clear;
  } else {
    paint.color = pathData.color;
    paint.blendMode = BlendMode.srcOver;
  }

  if (pathData.points.length == 1) {
    canvas.drawPoints(ui.PointMode.points, [pathData.points.first], paint);
  } else {
    final path = Path()..moveTo(pathData.points.first.dx, pathData.points.first.dy);
    for (int i = 1; i < pathData.points.length; i++) {
      path.lineTo(pathData.points[i].dx, pathData.points[i].dy);
    }
    canvas.drawPath(path, paint);
  }
}
