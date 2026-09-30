import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/language_selector.dart';
import '../widgets/message_bubble.dart';

/// 聊天对话主页面。
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _handleSend(String text) async {
    final chat = context.read<ChatProvider>();
    final l10n = AppLocalizations.of(context);
    try {
      await chat.sendText(text);
      _scrollToLatest();
    } catch (_) {
      if (!mounted) return;
      final msg = chat.error ?? l10n.errorGeneric;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_friendlyError(msg, l10n))),
      );
    }
  }

  Future<void> _handleRecord() async {
    final chat = context.read<ChatProvider>();
    final l10n = AppLocalizations.of(context);
    try {
      await chat.toggleRecording();
      _scrollToLatest();
    } catch (_) {
      if (!mounted) return;
      final raw = chat.error ?? '';
      String message = l10n.errorGeneric;
      if (raw.contains('permission') || raw.contains('Permission')) {
        message = l10n.errorPermissionMic;
      } else if (raw.contains('STT empty') || raw.contains('Empty recording')) {
        message = l10n.errorSttEmpty;
      } else if (raw.contains('Network') || raw.contains('HTTP')) {
        message = l10n.errorNetwork;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  String _friendlyError(String raw, AppLocalizations l10n) {
    if (raw.contains('Network') || raw.contains('HTTP') || raw.contains('Socket')) {
      return l10n.errorNetwork;
    }
    return l10n.errorGeneric;
  }

  Future<void> _confirmClear() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.clearHistory),
        content: Text(l10n.clearHistoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await context.read<ChatProvider>().clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chat = context.watch<ChatProvider>();
    // reverse 列表：index 0 为最新消息，保证长历史滚动流畅
    final messages = chat.messages.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.clearHistory,
            onPressed: chat.messages.isEmpty ? null : _confirmClear,
            icon: const Icon(Icons.delete_outline),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: LanguageSelector(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? _WelcomeView(l10n: l10n)
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    itemCount: messages.length + (chat.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (chat.isLoading && index == 0) {
                        return const _TypingIndicator();
                      }
                      final msgIndex = chat.isLoading ? index - 1 : index;
                      return MessageBubble(message: messages[msgIndex]);
                    },
                  ),
          ),
          ChatInputBar(
            enabled: !chat.isBusy,
            isRecording: chat.isRecording,
            isTranscribing: chat.isTranscribing,
            onSend: _handleSend,
            onToggleRecord: _handleRecord,
          ),
        ],
      ),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.travel_explore,
                size: 48,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.welcomeTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.welcomeMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 10),
          Text(l10n.loading, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}
