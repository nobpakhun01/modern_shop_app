import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_provider.dart';
import '../providers/language_provider.dart';
import '../utils/app_text.dart';
import '../widgets/product_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorite = context.watch<FavoriteProvider>();
    final language = context.watch<LanguageProvider>();
    final lang = language.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppText.get('wishlist', lang),
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (favorite.items.isNotEmpty)
            TextButton(
              onPressed: () {
                favorite.clearFavorites();
              },
              child: Text(
                AppText.get('clear', lang),
                style: const TextStyle(
                  color: Color(0xFF8A6A16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: favorite.items.isEmpty
            ? Center(
                key: const ValueKey('empty_favorite'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: 72,
                      color: Color(0xFFD4AF37),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      AppText.get('noFavoriteTitle', lang),
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppText.get('noFavorite', lang),
                      style: const TextStyle(color: Color(0xFF8B806F)),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                key: const ValueKey('favorite_items'),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                itemCount: favorite.items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.62,
                ),
                itemBuilder: (context, index) {
                  final product = favorite.items[index];

                  return ProductCard(
                    product: product,
                    heroTag: 'favorite_${product.id ?? index}',
                  );
                },
              ),
      ),
    );
  }
}
