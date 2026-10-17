import 'dart:math';

import 'package:bank_card/provider/pincodeprovider.dart';
import 'package:bank_card/widget/snekbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';

class PinCodeScreen extends StatefulWidget {
  const PinCodeScreen({super.key});

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _entranceController,
    curve: Curves.easeOut,
  );

  late final Animation<Offset> _slideAnimation =
      Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: Curves.easeOutCubic,
        ),
      );

  // PIN nuqtalari uchun shake kontrolleri
  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  // Yozuvning joylashuvini boshqarish uchun flag
  bool _isMovedAboveTitle = false;

  void _triggerAnimations() {
    _shakeController.forward(from: 0.0);
    
    // Snackbar 1 soniya turib bo'lgach, yozuv sarlavha tepasiga o'tadi
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isMovedAboveTitle = true;
        });
      }
    });
  }

  void _showTopMessage(BuildContext context, String text, bool isError) {
    if (isError) {
      _triggerAnimations();
    }
    showTopSnackBar(context, text, isError: isError);
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinProvider = context.watch<PinProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // Yuqori o'ng tarafdagi yozuv
                  Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: _isMovedAboveTitle ? 0.0 : 1.0,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "PIN-kod esimda emas",
                          style: TextStyle(
                            color: Color(0xFF8A5CF5),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Sarlavha tepasidagi doimiy ajratilgan balandlik (48px)
                  // Bu joy doim tayyor turadi, shunda pastdagi matn va nuqtalar hech qachon surilmaydi
                  SizedBox(
                    height: 48,
                    child: Center(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: _isMovedAboveTitle ? 1.0 : 0.0,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "PIN-kod esimda emas",
                            style: TextStyle(
                              color: Color(0xFF8A5CF5),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Sarlavha matni ("PIN-kodni kiriting")
                  Text(
                    pinProvider.titleText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // PIN Nuqtalari (Shake animatsiyasi bilan)
                  AnimatedBuilder(
                    animation: _shakeController,
                    builder: (context, child) {
                      final sine = sin(_shakeController.value * pi * 4);
                      return Transform.translate(
                        offset: Offset(sine * 12, 0),
                        child: child,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        bool isFilled = index < pinProvider.currentPin.length;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: isFilled ? 18 : 14,
                          height: isFilled ? 18 : 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isFilled
                                ? const Color(0xFF8A5CF5)
                                : Colors.grey.shade800,
                            boxShadow: [
                              BoxShadow(
                                color: isFilled
                                    ? const Color(0xFF8A5CF5).withValues(alpha: 0.6)
                                    : const Color(0xFF8A5CF5).withValues(alpha: 0.0),
                                blurRadius: isFilled ? 14.0 : 0.0,
                                spreadRadius: isFilled ? 3.0 : 0.0,
                                offset: Offset.zero,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const Spacer(),

                  // Klaviatura qismi
                  Column(
                    children: [
                      _buildKeyboardRow(context, ["1", "2", "3"]),
                      const SizedBox(height: 20),
                      _buildKeyboardRow(context, ["4", "5", "6"]),
                      const SizedBox(height: 20),
                      _buildKeyboardRow(context, ["7", "8", "9"]),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(width: 75),
                          _buildNumberButton(context, "0"),
                          SizedBox(
                            width: 75,
                            height: 75,
                            child: IconButton(
                              onPressed: () {
                                if (_isMovedAboveTitle) {
                                  setState(() {
                                    _isMovedAboveTitle = false;
                                  });
                                }
                                context.read<PinProvider>().onDeleteTap();
                              },
                              icon: const Icon(
                                Icons.backspace_outlined,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboardRow(BuildContext context, List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((num) => _buildNumberButton(context, num)).toList(),
    );
  }

  Widget _buildNumberButton(BuildContext context, String number) {
    return SizedBox(
      width: 75,
      height: 75,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (_isMovedAboveTitle) {
              setState(() {
                _isMovedAboveTitle = false;
              });
            }

            context.read<PinProvider>().onNumberTap(
              number,
              (text, isError) => _showTopMessage(context, text, isError),
              () => _navigateToHome(context),
            );
          },
          borderRadius: BorderRadius.circular(40),
          splashColor: const Color(0xFF8A5CF5).withOpacity(0.3),
          highlightColor: const Color(0xFF8A5CF5).withOpacity(0.1),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}