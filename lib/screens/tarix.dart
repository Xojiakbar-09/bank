import 'package:bank_card/provider/homeprovider.dart';
import 'package:bank_card/widget/listtial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tarix extends StatefulWidget {
  const Tarix({super.key});

  @override
  State<Tarix> createState() => _TarixState();
}

class _TarixState extends State<Tarix> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    // Ro'yxat kirib kelishi uchun controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Ekranga kirganda animatsiyani boshlash
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final home = context.watch<Homeprovider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Tranzaksiya tarixi"),
        actionsPadding: const EdgeInsets.only(right: 5),
        actions: [
          // Filter tugmasi uchun aylanish animatsiyasi
          AnimatedRotation(
            turns: _isFiltered ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _isFiltered = !_isFiltered;
                });
                // Animatsiyani qayta ishga tushirish (re-trigger)
                _controller.reset();
                _controller.forward();
              },
              icon: const Icon(Icons.tune),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: home.iconlar.length,
        itemBuilder: (context, index) {
          // Har bir element uchun ketma-ket kechikish (Staggered Animation Interval)
          final double start = (index / home.iconlar.length) * 0.5;
          final double end = start + 0.5;

          final Animation<double> fadeAnimation = CurvedAnimation(
            parent: _controller,
            curve: Interval(
              start.clamp(0.0, 1.0),
              end.clamp(0.0, 1.0),
              curve: Curves.easeOut,
            ),
          );

          final Animation<Offset> slideAnimation =
              Tween<Offset>(
                begin: const Offset(0.0, 0.4), 
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    start.clamp(0.0, 1.0),
                    end.clamp(0.0, 1.0),
                    curve: Curves.easeOutCubic,
                  ),
                ),
              );

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: Listtial(
                icon: home.iconlar[index],
                soz: home.sozlar[index],
                summa: home.summas[index],
                soat: home.soats[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
