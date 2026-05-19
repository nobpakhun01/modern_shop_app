import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/language_provider.dart';
import '../providers/product_provider.dart';
import '../screens/product_detail_screen.dart';
import '../screens/product_form_screen.dart';
import '../utils/app_text.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final String? heroTag;

  const ProductCard({super.key, required this.product, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();
    final language = context.watch<LanguageProvider>();
    final lang = language.languageCode;

    final isFavorite = favoriteProvider.isFavorite(product);
    final tag = heroTag ?? 'product_${product.id ?? product.title}_$hashCode';

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 450),
      tween: Tween(begin: 0.94, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return ProductDetailScreen(product: product, heroTag: tag);
                },
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFFFFF), Color(0xFFFFF7E2)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Hero(
                        tag: tag,
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported_outlined,
                              size: 46,
                              color: Color(0xFFD4AF37),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          favoriteProvider.toggleFavorite(product);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isFavorite
                                ? const Color(0xFFD4AF37)
                                : Colors.white,
                            border: Border.all(color: const Color(0x55D4AF37)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A000000),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isFavorite
                                ? Colors.white
                                : const Color(0xFF8A6A16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: Color(0xFF1F1A12),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  AppText.category(product.category, lang),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF8B806F),
                    fontSize: 11.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFD4AF37),
                      size: 17,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8A6A16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8A6A16),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: AppText.get('addToCart', lang),
                      onPressed: () {
                        cart.addToCart(product);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppText.get('addedToCart', lang)),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add_shopping_cart_rounded,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton<String>(
                      color: Colors.white,
                      onSelected: (value) async {
                        if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return ProductFormScreen(product: product);
                              },
                            ),
                          );
                        }

                        if (value == 'delete') {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text(AppText.get('confirmDelete', lang)),
                                content: Text(
                                  '${AppText.get('confirmDeleteMessage', lang)}\n${product.title}',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: Text(AppText.get('cancel', lang)),
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Text(AppText.get('delete', lang)),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirm == true && context.mounted) {
                            await context.read<ProductProvider>().deleteProduct(
                              product.id ?? 0,
                            );
                          }
                        }
                      },
                      itemBuilder: (_) {
                        return [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text(AppText.get('editProduct', lang)),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(AppText.get('deleteProduct', lang)),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
