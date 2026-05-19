import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../utils/app_text.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final int totalItems;
  final double totalPrice;
  final String paymentMethodKey;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.totalItems,
    required this.totalPrice,
    required this.paymentMethodKey,
  });

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    final lang = language.languageCode;

    return Scaffold(
      body: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 650),
        tween: Tween(begin: 0, end: 1),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.scale(scale: 0.94 + (0.06 * value), child: child),
          );
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(26),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD4AF37), Color(0xFFFFE7A0)],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33D4AF37),
                              blurRadius: 24,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 56,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        AppText.get('orderSuccessful', lang),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F1A12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppText.get('thankYou', lang),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF6E6252)),
                      ),
                      const SizedBox(height: 24),
                      _infoTile(
                        title: AppText.get('orderId', lang),
                        value: '#$orderId',
                      ),
                      _infoTile(
                        title: AppText.get('payment', lang),
                        value: AppText.get(paymentMethodKey, lang),
                      ),
                      _infoTile(
                        title: AppText.get('items', lang),
                        value: '$totalItems',
                      ),
                      _infoTile(
                        title: AppText.get('total', lang),
                        value: '\$${totalPrice.toStringAsFixed(2)}',
                        isTotal: true,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.popUntil(context, (route) {
                              return route.isFirst;
                            });
                          },
                          icon: const Icon(Icons.home_outlined),
                          label: Text(AppText.get('backHome', lang)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile({
    required String title,
    required String value,
    bool isTotal = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isTotal ? const Color(0xFFFFF5D6) : const Color(0xFFFFFBF2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x33D4AF37)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF6E6252),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: const Color(0xFF8A6A16),
                fontWeight: FontWeight.bold,
                fontSize: isTotal ? 20 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
