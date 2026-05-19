import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/language_provider.dart';
import '../providers/product_provider.dart';
import '../utils/app_text.dart';
import '../widgets/language_button.dart';
import '../widgets/product_card.dart';
import '../widgets/section_title.dart';
import 'cart_screen.dart';
import 'favorite_screen.dart';
import 'product_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  String keyword = '';
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<String> getCategories(List<Product> products) {
    final categories = products
        .map((product) {
          return product.category;
        })
        .toSet()
        .toList();

    categories.sort();

    return ['All', ...categories];
  }

  List<Product> filterProducts(List<Product> products, String lang) {
    final query = keyword.toLowerCase().trim();

    return products.where((product) {
      final translatedCategory = AppText.category(
        product.category,
        lang,
      ).toLowerCase();

      final matchSearch =
          query.isEmpty ||
          product.title.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          translatedCategory.contains(query);

      final matchCategory =
          selectedCategory == 'All' || product.category == selectedCategory;

      return matchSearch && matchCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final favorite = context.watch<FavoriteProvider>();
    final language = context.watch<LanguageProvider>();
    final lang = language.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppText.get('appName', lang),
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        actions: [
          const LanguageButton(),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                tooltip: AppText.get('wishlist', lang),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return const FavoriteScreen();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.favorite_border),
              ),
              if (favorite.totalFavorites > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: const Color(0xFFD4AF37),
                    child: Text(
                      '${favorite.totalFavorites}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                tooltip: AppText.get('cart', lang),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return const CartScreen();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_bag_outlined),
              ),
              if (cart.totalItems > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: const Color(0xFFD4AF37),
                    child: Text(
                      '${cart.totalItems}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            tooltip: AppText.get('logout', lang),
            onPressed: () {
              context.read<AuthProvider>().logout();
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return const ProductFormScreen();
              },
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(
          AppText.get('addProduct', lang),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final products = filterProducts(provider.products, lang);
          final categories = getCategories(provider.products);

          if (provider.isLoading && provider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.products.isEmpty) {
            return Center(child: Text(provider.errorMessage!));
          }

          return RefreshIndicator(
            color: const Color(0xFFD4AF37),
            onRefresh: provider.fetchProducts,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildLuxuryBanner(lang)),
                SliverToBoxAdapter(child: _buildSearchBox(lang)),
                SliverToBoxAdapter(
                  child: _buildCategoryFilter(categories, lang),
                ),
                SliverToBoxAdapter(
                  child: SectionTitle(
                    title: AppText.get('featuredCollection', lang),
                    subtitle: AppText.get('featuredSubtitle', lang),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 250,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.popularProducts.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 12);
                      },
                      itemBuilder: (context, index) {
                        final product = provider.popularProducts[index];

                        return SizedBox(
                          width: 185,
                          child: ProductCard(
                            product: product,
                            heroTag: 'popular_${product.id ?? index}',
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SectionTitle(
                    title: AppText.get('allProducts', lang),
                    subtitle: AppText.get('allProductsSubtitle', lang),
                  ),
                ),
                if (products.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Center(child: Text(AppText.get('notFound', lang))),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = products[index];

                        return ProductCard(
                          product: product,
                          heroTag: 'all_${product.id ?? index}',
                        );
                      }, childCount: products.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.62,
                          ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLuxuryBanner(String lang) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF3A2A10), Color(0xFF15110A), Color(0xFF2B2111)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0x99D4AF37)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22D4AF37),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppText.get('luxuryCollection', lang),
            style: GoogleFonts.playfairDisplay(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFFFBF2),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppText.get('luxuryDescription', lang),
            style: const TextStyle(color: Color(0xFFF5E7C1), height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.workspace_premium, color: Color(0xFFD4AF37)),
              const SizedBox(width: 8),
              Text(
                AppText.get('premiumExperience', lang),
                style: const TextStyle(
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox(String lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          setState(() {
            keyword = value;
          });
        },
        decoration: InputDecoration(
          hintText: AppText.get('searchHint', lang),
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(List<String> categories, String lang) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = selectedCategory == category;

          return ChoiceChip(
            label: Text(
              AppText.category(category, lang),
              style: TextStyle(
                color: selected ? Colors.black : const Color(0xFF8A6A16),
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: selected,
            selectedColor: const Color(0xFFD4AF37),
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0x55D4AF37)),
            onSelected: (value) {
              setState(() {
                selectedCategory = category;
              });
            },
          );
        },
      ),
    );
  }
}
