import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/language_provider.dart';
import '../providers/product_provider.dart';
import '../utils/app_text.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() {
    return _ProductFormScreenState();
  }
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isSaving = false;

  bool get isEditMode {
    return widget.product != null;
  }

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      final product = widget.product!;

      titleController.text = product.title;
      priceController.text = product.price.toString();
      categoryController.text = product.category;
      imageController.text = product.image;
      descriptionController.text = product.description;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    categoryController.dispose();
    imageController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> saveProduct() async {
    final lang = context.read<LanguageProvider>().languageCode;

    final title = titleController.text.trim();
    final priceText = priceController.text.trim();
    final category = categoryController.text.trim();
    final image = imageController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty ||
        priceText.isEmpty ||
        category.isEmpty ||
        image.isEmpty ||
        description.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppText.get('pleaseFill', lang))));
      return;
    }

    final price = double.tryParse(priceText);

    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppText.get('invalidPrice', lang))),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    final product = Product(
      id: widget.product?.id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: widget.product?.rating ?? 4.5,
      ratingCount: widget.product?.ratingCount ?? 1,
    );

    final productProvider = context.read<ProductProvider>();

    if (isEditMode) {
      await productProvider.updateProduct(product);
    } else {
      await productProvider.addProduct(product);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      isSaving = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    final lang = language.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode
              ? AppText.get('editProduct', lang)
              : AppText.get('addProduct', lang),
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: AppText.get('productName', lang),
                      prefixIcon: const Icon(Icons.shopping_bag_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: AppText.get('price', lang),
                      prefixIcon: const Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      labelText: AppText.get('category', lang),
                      prefixIcon: const Icon(Icons.category_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: imageController,
                    decoration: InputDecoration(
                      labelText: AppText.get('imageUrl', lang),
                      prefixIcon: const Icon(Icons.image_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: descriptionController,
                    minLines: 4,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: AppText.get('productDescription', lang),
                      prefixIcon: const Icon(Icons.description_outlined),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton.icon(
                      onPressed: isSaving ? null : saveProduct,
                      icon: isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        isEditMode
                            ? AppText.get('saveEdit', lang)
                            : AppText.get('save', lang),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
