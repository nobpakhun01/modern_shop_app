import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../utils/app_text.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() {
    return _CheckoutScreenState();
  }
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String paymentMethodKey = 'creditCard';

  Future<void> confirmPayment() async {
    final cart = context.read<CartProvider>();

    final totalItems = cart.totalItems;
    final totalPrice = cart.totalPrice;
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();

    cart.clearCart();

    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) {
          return OrderSuccessScreen(
            orderId: orderId,
            totalItems: totalItems,
            totalPrice: totalPrice,
            paymentMethodKey: paymentMethodKey,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final language = context.watch<LanguageProvider>();
    final lang = language.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppText.get('checkout', lang),
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
      ),
      body: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 550),
        tween: Tween(begin: 0, end: 1),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 24 * (1 - value)),
              child: child,
            ),
          );
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF8E5), Color(0xFFFFFFFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: const Color(0x55D4AF37)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFFD4AF37),
                    size: 38,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppText.get('securePayment', lang),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F1A12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppText.get('securePaymentSubtitle', lang),
                    style: const TextStyle(
                      color: Color(0xFF6E6252),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppText.get('paymentMethod', lang),
              style: GoogleFonts.playfairDisplay(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _paymentTile(
              lang: lang,
              titleKey: 'creditCard',
              subtitleKey: 'creditCardSubtitle',
              icon: Icons.credit_card_rounded,
            ),
            _paymentTile(
              lang: lang,
              titleKey: 'promptPay',
              subtitleKey: 'promptPaySubtitle',
              icon: Icons.qr_code_2_rounded,
            ),
            _paymentTile(
              lang: lang,
              titleKey: 'cashOnDelivery',
              subtitleKey: 'cashOnDeliverySubtitle',
              icon: Icons.local_shipping_outlined,
            ),
            const SizedBox(height: 22),
            Text(
              AppText.get('orderSummary', lang),
              style: GoogleFonts.playfairDisplay(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _summaryRow(
                      title: AppText.get('totalItems', lang),
                      value: '${cart.totalItems}',
                    ),
                    const Divider(height: 28),
                    _summaryRow(
                      title: AppText.get('totalPayment', lang),
                      value: '\$${cart.totalPrice.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: cart.items.isEmpty ? null : confirmPayment,
                icon: const Icon(Icons.verified_user_outlined),
                label: Text(AppText.get('confirmPayment', lang)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentTile({
    required String lang,
    required String titleKey,
    required String subtitleKey,
    required IconData icon,
  }) {
    final selected = paymentMethodKey == titleKey;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: selected ? const Color(0xFFFFF5D6) : Colors.white,
        border: Border.all(
          color: selected ? const Color(0xFFD4AF37) : const Color(0x33D4AF37),
          width: selected ? 1.4 : 1,
        ),
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: Color(0x1AD4AF37),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: RadioListTile<String>(
        value: titleKey,
        groupValue: paymentMethodKey,
        activeColor: const Color(0xFFD4AF37),
        onChanged: (value) {
          setState(() {
            paymentMethodKey = value!;
          });
        },
        secondary: Icon(icon, color: const Color(0xFF8A6A16)),
        title: Text(
          AppText.get(titleKey, lang),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F1A12),
          ),
        ),
        subtitle: Text(
          AppText.get(subtitleKey, lang),
          style: const TextStyle(color: Color(0xFF8B806F)),
        ),
      ),
    );
  }

  Widget _summaryRow({
    required String title,
    required String value,
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: isTotal ? const Color(0xFF1F1A12) : const Color(0xFF6E6252),
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF8A6A16),
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 22 : 15,
          ),
        ),
      ],
    );
  }
}
