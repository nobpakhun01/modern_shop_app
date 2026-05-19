import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../utils/app_text.dart';
import '../widgets/language_button.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final auth = context.read<AuthProvider>();

    await auth.login(usernameController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final language = context.watch<LanguageProvider>();
    final lang = language.languageCode;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFBF2),
                  Color(0xFFFFF3D0),
                  Color(0xFFFFFFFF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Card(
                    color: Colors.white,
                    elevation: 8,
                    shadowColor: const Color(0x33D4AF37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(
                        color: Color(0x66D4AF37),
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(26),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 86,
                            height: 86,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFFF1BF),
                              border: Border.all(
                                color: const Color(0xFFD4AF37),
                                width: 1.6,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x33D4AF37),
                                  blurRadius: 18,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: Color(0xFF1F1A12),
                              size: 38,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            AppText.get('appName', lang),
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1F1A12),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppText.get('luxuryExperience', lang),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF6E6252),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            controller: usernameController,
                            style: const TextStyle(
                              color: Color(0xFF1F1A12),
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              labelText: AppText.get('username', lang),
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            style: const TextStyle(
                              color: Color(0xFF1F1A12),
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              labelText: AppText.get('password', lang),
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF8A6A16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          if (auth.errorMessage != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFEBEE),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFFFCDD2),
                                ),
                              ),
                              child: Text(
                                auth.errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: FilledButton(
                              onPressed: auth.isLoading ? null : login,
                              child: auth.isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      AppText.get('login', lang),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              auth.clearError();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return const RegisterScreen();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              AppText.get('noAccount', lang),
                              style: const TextStyle(
                                color: Color(0xFF8A6A16),
                                fontWeight: FontWeight.bold,
                              ),
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
          const Positioned(top: 34, right: 12, child: LanguageButton()),
        ],
      ),
    );
  }
}
