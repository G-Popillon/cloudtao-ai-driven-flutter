import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// 底部输入栏：文字输入、发送、录音（点击开始/再点结束）。
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.enabled,
    required this.isRecording,
    required this.isTranscribing,
    required this.onSend,
    required this.onToggleRecord,
  });

  final bool enabled;
  final bool isRecording;
  final bool isTranscribing;
  final ValueChanged<String> onSend;
  final VoidCallback onToggleRecord;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final busy = !widget.enabled || widget.isTranscribing;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 录音按钮：点击开始，再次点击结束
            IconButton(
              tooltip: widget.isRecording ? l10n.recordStop : l10n.recordStart,
              onPressed: busy && !widget.isRecording
                  ? null
                  : widget.onToggleRecord,
              icon: Icon(
                widget.isRecording ? Icons.stop_circle : Icons.mic,
                color: widget.isRecording
                    ? AppTheme.recording
                    : AppTheme.primary,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: !busy && !widget.isRecording,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  hintText: widget.isRecording
                      ? l10n.recording
                      : widget.isTranscribing
                          ? l10n.loading
                          : l10n.inputHint,
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: busy || widget.isRecording ? null : _submit,
              child: Text(l10n.send),
            ),
          ],
        ),
      ),
    );
  }
}
