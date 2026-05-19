import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../utils/app_text.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();

    return PopupMenuButton<String>(
      tooltip: AppText.get('language', language.languageCode),
      icon: const Icon(Icons.language),
      onSelected: (value) {
        language.changeLanguage(value);
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'th',
            child: Row(
              children: [
                if (language.isThai)
                  const Icon(Icons.check, size: 18, color: Color(0xFF8A6A16))
                else
                  const SizedBox(width: 18),
                const SizedBox(width: 8),
                Text(AppText.get('thai', language.languageCode)),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'en',
            child: Row(
              children: [
                if (language.isEnglish)
                  const Icon(Icons.check, size: 18, color: Color(0xFF8A6A16))
                else
                  const SizedBox(width: 18),
                const SizedBox(width: 8),
                Text(AppText.get('english', language.languageCode)),
              ],
            ),
          ),
        ];
      },
    );
  }
}
