import 'package:bank_card/provider/pincodeprovider.dart';
import 'package:bank_card/widget/snekbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homepage.dart'; 

class PinCodeScreen extends StatelessWidget {
  const PinCodeScreen({super.key});

  // <-- YANGI TOP SNACKBAR FUNKSIYAMIZ -->
  void _showTopMessage(BuildContext context, String text, bool isError) {
    showTopSnackBar(context, text, isError: isError);
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinProvider = context.watch<PinProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "PIN-kod esimda emas",
                    style: TextStyle(color: Color(0xFF8A5CF5), fontSize: 15),
                  ),
                ),
              ),

              const Spacer(),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  bool isFilled = index < pinProvider.currentPin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled
                          ? const Color(0xFF8A5CF5)
                          : Colors.grey.shade800,
                    ),
                  );
                }),
              ),

              const Spacer(),

              Column(
                children: [
                  _buildKeyboardRow(context, ["1", "2", "3"]),
                  const SizedBox(height: 24),
                  _buildKeyboardRow(context, ["4", "5", "6"]),
                  const SizedBox(height: 24),
                  _buildKeyboardRow(context, ["7", "8", "9"]),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 80),
                      _buildNumberButton(context, "0"),
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: IconButton(
                          onPressed: () =>
                              context.read<PinProvider>().onDeleteTap(),
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
      width: 80,
      height: 80,
      child: InkWell(
        onTap: () {
          context.read<PinProvider>().onNumberTap(
            number,
            (text, isError) => _showTopMessage(context, text, isError), // <-- Moslashtirildi
            () => _navigateToHome(context),
          );
        },
        borderRadius: BorderRadius.circular(40),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}