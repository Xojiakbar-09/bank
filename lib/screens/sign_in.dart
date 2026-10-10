import 'package:bank_card/repository/auth_repository.dart';
import 'package:bank_card/screens/pinkod.dart'; // Kirgandan keyin ochiladigan ekran
import 'package:bank_card/screens/regiter.dart'; // Ro'yxatdan o'tish ekrani
import 'package:bank_card/widget/snekbar.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _handleLogin() async {
    if (_identifierController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      showTopSnackBar(context, "Barcha maydonlarni to'ldiring");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthRepository.login(
        identifier: _identifierController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        // Muvaffaqiyatli kirgach, PinCodeScreen yoki Home'ga o'tish
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PinCodeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        showTopSnackBar(
          context,
          "Xatolik: ${e.toString().replaceAll('HttpException: ', '')}",
        );
        // ignore: avoid_print
        print("Xatolik: ${e.toString().replaceAll('HttpException: ', '')}");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121214), // Uzum uslubidagi to'q fon
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Orqaga qaytish yoki logotip o'rniga minimal sarlavha
              const Text(
                "Xush kelibsiz! 👋",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Davom etish uchun hisobingizga kiring",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 40),

              // Email yoki Username maydoni
              TextField(
                controller: _identifierController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Email yoki Username",
                  hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
                  filled: true,
                  fillColor: const Color(0xFF1E1E24),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF7E22CE),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Parol maydoni
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Parol",
                  hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
                  filled: true,
                  fillColor: const Color(0xFF1E1E24),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF7E22CE),
                      width: 1.5,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Kirish tugmasi (Binafsha rang - Uzum style)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7E22CE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                      : const Text(
                          "Kirish",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const Spacer(),

              // Ro'yxatdan o'tish sahifasiga o'tish havolasi
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Hisobingiz yo'qmi? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: const Text(
                      "Ro'yxatdan o'tish",
                      style: TextStyle(
                        color: Color(0xFF9333EA),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
