import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:get/get.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class AppRichEditorDialog extends StatefulWidget {
  final String? initialHtml;
  final String? manualRxId;
  final Function(String html) onSave;

  const AppRichEditorDialog({
    super.key,
    this.initialHtml,
    this.manualRxId,
    required this.onSave,
  });

  static Future<void> show({
    BuildContext? context,
    String? initialHtml,
    String? manualRxId,
    required Function(String html) onSave,
  }) {
    return Get.dialog<void>(
      AppRichEditorDialog(
        initialHtml: initialHtml,
        manualRxId: manualRxId,
        onSave: onSave,
      ),
      barrierDismissible: false,
    );
  }

  @override
  State<AppRichEditorDialog> createState() => _AppRichEditorDialogState();
}

class _AppRichEditorDialogState extends State<AppRichEditorDialog> {
  late final QuillController _quillController;
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initQuillController();
  }

  void _initQuillController() {
    String raw = widget.initialHtml ?? '';
    if (raw == 'null' || raw == '<br>') {
      raw = '';
    }

    Document document;
    if (raw.trim().isNotEmpty) {
      try {
        final delta = HtmlToDelta().convert(raw);
        document = Document.fromDelta(delta);
      } catch (_) {
        document = Document()..insert(0, raw);
      }
    } else {
      document = Document();
    }

    _quillController = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _quillController.dispose();
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  String _getHtmlOutput() {
    try {
      final delta = _quillController.document.toDelta();
      final deltaList = <Map<String, dynamic>>[];
      for (final op in delta.operations) {
        deltaList.add(op.toJson());
      }
      final converter = QuillDeltaToHtmlConverter(
        deltaList,
        ConverterOptions.forEmail(),
      );
      final html = converter.convert();
      return html;
    } catch (_) {
      return _quillController.document.toPlainText().trim();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing =
        widget.manualRxId != null && widget.manualRxId!.isNotEmpty;

    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 680),
        child: Column(
          children: [
            // Top Title Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isEditing
                          ? 'ds_edit_manual_rx'.tr
                          : 'ds_manual_rx_dialog_title'.tr,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.white),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'cancel'.tr,
                  ),
                ],
              ),
            ),

            // Flutter Quill Toolbar
            Container(
              decoration: const BoxDecoration(
                color: AppColors.lightGray,
                border: Border(
                  bottom: BorderSide(color: AppColors.medicalGray, width: 1),
                ),
              ),
              child: QuillSimpleToolbar(
                controller: _quillController,
                config: const QuillSimpleToolbarConfig(
                  showFontFamily: false,
                  showFontSize: false,
                  showBoldButton: true,
                  showItalicButton: true,
                  showUnderLineButton: true,
                  showStrikeThrough: true,
                  showColorButton: true,
                  showBackgroundColorButton: true,
                  showClearFormat: true,
                  showHeaderStyle: true,
                  showListBullets: true,
                  showListNumbers: true,
                  showListCheck: false,
                  showCodeBlock: false,
                  showQuote: false,
                  showIndent: true,
                  showLink: false,
                  showUndo: true,
                  showRedo: true,
                  showDirection: false,
                  showSearchButton: false,
                  showSubscript: false,
                  showSuperscript: false,
                  showAlignmentButtons: true,
                ),
              ),
            ),

            // Flutter Quill Editor
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  textTheme: Theme.of(context).textTheme.apply(
                        bodyColor: AppColors.navy,
                        displayColor: AppColors.navy,
                      ),
                  textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: AppColors.teal,
                    selectionColor: AppColors.medicalGray,
                    selectionHandleColor: AppColors.teal,
                  ),
                ),
                child: Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.all(12.0),
                  child: QuillEditor(
                    controller: _quillController,
                    focusNode: _editorFocusNode,
                    scrollController: _editorScrollController,
                    config: QuillEditorConfig(
                      placeholder: 'ds_insert_rx_hint'.tr,
                      expands: true,
                      padding: const EdgeInsets.all(8),
                      autoFocus: true,
                      customStyles: DefaultStyles(
                        paragraph: DefaultTextBlockStyle(
                          const TextStyle(
                            color: AppColors.navy,
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                          const HorizontalSpacing(0, 0),
                          const VerticalSpacing(0, 0),
                          const VerticalSpacing(0, 0),
                          null,
                        ),
                        placeHolder: DefaultTextBlockStyle(
                          const TextStyle(
                            color: AppColors.coolGray,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          const HorizontalSpacing(0, 0),
                          const VerticalSpacing(0, 0),
                          const VerticalSpacing(0, 0),
                          null,
                        ),
                        lists: DefaultListBlockStyle(
                          const TextStyle(
                            color: AppColors.navy,
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                          const HorizontalSpacing(0, 0),
                          const VerticalSpacing(0, 0),
                          const VerticalSpacing(0, 4),
                          null,
                          null,
                        ),
                        h1: DefaultTextBlockStyle(
                          const TextStyle(
                            color: AppColors.navy,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          const HorizontalSpacing(0, 0),
                          const VerticalSpacing(8, 4),
                          const VerticalSpacing(0, 0),
                          null,
                        ),
                        h2: DefaultTextBlockStyle(
                          const TextStyle(
                            color: AppColors.navy,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          const HorizontalSpacing(0, 0),
                          const VerticalSpacing(6, 3),
                          const VerticalSpacing(0, 0),
                          null,
                        ),
                        h3: DefaultTextBlockStyle(
                          const TextStyle(
                            color: AppColors.navy,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          const HorizontalSpacing(0, 0),
                          const VerticalSpacing(4, 2),
                          const VerticalSpacing(0, 0),
                          null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Action Buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.medicalGray)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.navy,
                      side: const BorderSide(color: AppColors.medicalGray),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'cancel'.tr,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      final plainText =
                          _quillController.document.toPlainText().trim();
                      if (plainText.isEmpty) {
                        AppSnackbars.showWarning(
                          'warning_title'.tr,
                          'ds_please_enter_prescription'.tr,
                        );
                        return;
                      }
                      final html = _getHtmlOutput();
                      Navigator.of(context).pop();
                      widget.onSave(html);
                    },
                    child: Text(
                      'save'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
