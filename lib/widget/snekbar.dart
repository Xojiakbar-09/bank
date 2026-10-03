import 'package:flutter/material.dart';

void showTopSnackBar(BuildContext context, String message, {bool isError = true}) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  final primaryColor = isError ? const Color(0xFFFF3B30) : const Color(0xFF34C759); // Qizil yoki Yashil
  final iconData = isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E232D), 
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primaryColor.withAlpha(100), 
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withAlpha(40),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: primaryColor.withAlpha(38),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData, 
                  color: primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3), () {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
}