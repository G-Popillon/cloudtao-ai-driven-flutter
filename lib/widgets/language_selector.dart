import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';

/// 顶部语言下拉：中文 / English / ไทย / Tiếng Việt / Bahasa Indonesia。
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: localeProvider.langCode,
        dropdownColor: Colors.white,
        iconEnabledColor: Colors.white,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        selectedItemBuilder: (context) {
          return supportedLanguages
              .map(
                (lang) => Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    lang.label,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList();
        },
        items: supportedLanguages
            .map(
              (lang) => DropdownMenuItem(
                value: lang.code,
                child: Text(
                  lang.label,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
            )
            .toList(),
        onChanged: (code) {
          if (code == null) return;
          context.read<LocaleProvider>().setByCode(code);
        },
      ),
    );
  }
}
