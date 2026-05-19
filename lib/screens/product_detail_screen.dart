import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/language_provider.dart';
import '../utils/app_text.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final String? heroTag;

  const ProductDetailScreen({super.key, required this.product, this.heroTag});

  @override
  State<ProductDetailScreen> createState() {
    return _ProductDetailScreenState();
  }
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> fadeAnimation;
  late final Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final tag = widget.heroTag ?? 'detail_${product.id ?? product.title}';

    final cart = context.read<CartProvider>();
    final favorite = context.watch<FavoriteProvider>();
    final language = context.watch<LanguageProvider>();

    final lang = language.languageCode;
    final isFavorite = favorite.isFavorite(product);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppText.get('productDetail', lang),
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              favorite.toggleFavorite(product);
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.redAccent : const Color(0xFF8A6A16),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFFFFFBF2),
          border: Border(top: BorderSide(color: Color(0x33D4AF37))),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8A6A16),
                  ),
                ),
              ),
              SizedBox(
                height: 54,
                child: FilledButton.icon(
                  onPressed: () {
                    cart.addToCart(product);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppText.get('addedToCart', lang))),
                    );
                  },
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: Text(AppText.get('addToCart', lang)),
                ),
              ),
            ],
          ),
        ),
      ),
      body: FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                height: 360,
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFFFF7E2),
                      Color(0xFFFFFBF2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: const Color(0x55D4AF37)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1AD4AF37),
                      blurRadius: 30,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: Hero(
                  tag: tag,
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported_outlined,
                        size: 70,
                        color: Color(0xFFD4AF37),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2C2),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0x55D4AF37)),
                    ),
                    child: Text(
                      AppText.category(product.category, lang),
                      style: const TextStyle(
                        color: Color(0xFF8A6A16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFFD4AF37),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    AppText.get('premiumProduct', lang),
                    style: const TextStyle(
                      color: Color(0xFF8A6A16),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                product.title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F1A12),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFD4AF37)),
                  const SizedBox(width: 5),
                  Text(
                    '${product.rating.toStringAsFixed(1)} ${AppText.get('rating', lang)}',
                    style: const TextStyle(
                      color: Color(0xFF8A6A16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '(${product.ratingCount} ${AppText.get('reviews', lang)})',
                    style: const TextStyle(color: Color(0xFF8B806F)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                AppText.get('description', lang),
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F1A12),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.description,
                style: const TextStyle(
                  fontSize: 15.5,
                  height: 1.7,
                  color: Color(0xFF5A5145),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
