import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/weather_source.dart';

/// AI 消息下方的「引用气象数据源」折叠面板。
class SourcePanel extends StatelessWidget {
  const SourcePanel({super.key, required this.sources});

  final List<WeatherSource> sources;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (sources.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(top: 6),
      elevation: 0,
      color: const Color(0xFFE8F4FA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        title: Text(
          l10n.sourcePanelTitle,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        children: [
          for (var i = 0; i < sources.length; i++) ...[
            if (i > 0) const Divider(height: 12),
            _SourceItem(source: sources[i], index: i + 1),
          ],
        ],
      ),
    );
  }
}

class _SourceItem extends StatelessWidget {
  const _SourceItem({required this.source, required this.index});

  final WeatherSource source;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$index. ${source.title}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          if (source.snippet != null && source.snippet!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              source.snippet!,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
          if (source.url != null && source.url!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              source.url!,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
