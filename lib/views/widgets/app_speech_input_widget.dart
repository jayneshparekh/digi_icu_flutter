import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Language model definition for Speech-To-Text selection.
class SpeechLanguage {
  final String name;
  final String localeId;

  const SpeechLanguage({required this.name, required this.localeId});
}

/// A highly customizable, real-time Speech-To-Text input widget.
///
/// Can wrap or attach to any [TextEditingController] and stream spoken words directly into it.
/// Supports language selection (English, Hindi, Gujarati, Marathi) and active mic toggle state.
class AppSpeechInputWidget extends StatefulWidget {
  /// The target text controller to write recognized speech into.
  final TextEditingController controller;

  /// Optional label text above the field.
  final String? label;

  /// Hint text if no child is provided.
  final String? hintText;

  /// Custom height for the text area box.
  final double? height;

  /// Custom width for the text widget container.
  final double? width;

  /// Max lines for default TextField if no child widget is supplied.
  final int maxLines;

  /// Visibility flag. If false, hides the widget entirely. Defaults to true.
  final bool isVisible;

  /// Initial selected language locale. Defaults to English ('en_IN').
  final String defaultLocaleId;

  /// Callback when recognized speech text changes.
  final ValueChanged<String>? onChanged;

  /// Optional custom list of supported speech languages.
  final List<SpeechLanguage>? supportedLanguages;

  const AppSpeechInputWidget({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.height,
    this.width,
    this.maxLines = 4,
    this.isVisible = true,
    this.defaultLocaleId = 'en_IN',
    this.onChanged,
    this.supportedLanguages,
  });

  @override
  State<AppSpeechInputWidget> createState() => _AppSpeechInputWidgetState();
}

class _AppSpeechInputWidgetState extends State<AppSpeechInputWidget> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isSpeechAvailable = false;
  late SpeechLanguage _selectedLanguage;

  static const String _iconPathPrefix = 'assets/icons/svg/';

  late final List<SpeechLanguage> _languages;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _languages = widget.supportedLanguages ??
        [
          SpeechLanguage(name: 'lang_english'.tr, localeId: 'en_IN'),
          SpeechLanguage(name: 'lang_hindi'.tr, localeId: 'hi_IN'),
          SpeechLanguage(name: 'lang_gujarati'.tr, localeId: 'gu_IN'),
          SpeechLanguage(name: 'lang_marathi'.tr, localeId: 'mr_IN'),
        ];

    _selectedLanguage = _languages.firstWhere(
      (lang) => lang.localeId == widget.defaultLocaleId,
      orElse: () => _languages.first,
    );

    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      _isSpeechAvailable = await _speech.initialize(
        onError: (errorNotification) {
          if (mounted) {
            setState(() {
              _isListening = false;
            });
          }
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (mounted) {
              setState(() {
                _isListening = false;
              });
            }
          }
        },
      );
    } catch (_) {
      _isSpeechAvailable = false;
    }
  }

  Future<String> _getResolvedLocaleId() async {
    final targetLocaleId = _selectedLanguage.localeId;
    try {
      if (_isSpeechAvailable) {
        final systemLocales = await _speech.locales();
        if (systemLocales.isNotEmpty) {
          final prefix = targetLocaleId.split('_').first.toLowerCase();
          final match = systemLocales.firstWhere(
            (loc) => loc.localeId.toLowerCase().startsWith(prefix),
            orElse: () => stt.LocaleName(targetLocaleId, _selectedLanguage.name),
          );
          return match.localeId;
        }
      }
    } catch (_) {}
    return targetLocaleId;
  }

  void _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
      return;
    }

    await _startListening();
  }

  Future<void> _startListening() async {
    if (!_isSpeechAvailable) {
      _isSpeechAvailable = await _speech.initialize();
    }

    if (!_isSpeechAvailable) return;

    final existingText = widget.controller.text.trim();
    final prefix = existingText.isNotEmpty ? '$existingText ' : '';

    setState(() {
      _isListening = true;
    });

    final activeLocaleId = await _getResolvedLocaleId();

    await _speech.listen(
      localeId: activeLocaleId,
      listenFor: const Duration(minutes: 3),
      pauseFor: const Duration(seconds: 30),
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: false,
        listenMode: stt.ListenMode.dictation,
      ),
      onResult: (result) {
        if (mounted) {
          final recognizedWords = result.recognizedWords;
          if (recognizedWords.isNotEmpty) {
            final newText = '$prefix$recognizedWords';
            widget.controller.text = newText;
            widget.controller.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.controller.text.length),
            );

            if (widget.onChanged != null) {
              widget.onChanged!(widget.controller.text);
            }
          }
        }
      },
    );
  }

  void _onLanguageChanged(SpeechLanguage? newLang) async {
    if (newLang == null || newLang == _selectedLanguage) return;

    final wasListening = _isListening;
    if (wasListening) {
      await _speech.stop();
    }

    setState(() {
      _selectedLanguage = newLang;
    });

    if (wasListening) {
      await _startListening();
    }
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null && widget.label!.isNotEmpty) ...[
            Text(
              widget.label!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 6),
          ],
          _buildHeaderRow(),
          const SizedBox(height: 8),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Language Dropdown
        DropdownButton<SpeechLanguage>(
          value: _selectedLanguage,
          underline: const SizedBox.shrink(),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          items: _languages.map((SpeechLanguage lang) {
            return DropdownMenuItem<SpeechLanguage>(
              value: lang,
              child: Text(
                lang.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: _onLanguageChanged,
        ),
        // Mic / Stop Circular Action Button
        GestureDetector(
          onTap: _toggleListening,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isListening ? Colors.red : AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: (_isListening ? Colors.red : AppColors.primary)
                      .withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                '$_iconPathPrefix${_isListening ? 'ic_stop.svg' : 'ic_mic.svg'}',
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField() {
    return Container(
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isListening ? Colors.red : Colors.grey.shade400,
          width: _isListening ? 1.5 : 1.0,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        maxLines: widget.maxLines,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'type_speak_notes_hint'.tr,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
