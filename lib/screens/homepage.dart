import 'package:bank_card/presentation/homewiev.dart';
import 'package:bank_card/provider/homeprovider.dart';
import 'package:bank_card/screens/kartalar.dart';
import 'package:bank_card/screens/tarix.dart';
import 'package:bank_card/widget/circlor.dart';
import 'package:bank_card/widget/listview.dart';
import 'package:bank_card/widget/logout.dart';
import 'package:bank_card/widget/showmodelbottemsheet.dart' hide Kartalar;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // HomeView metodlarini chaqirish uchun GlobalKey
  final GlobalKey<HomeViewState> _homeKey = GlobalKey<HomeViewState>();

  @override
  Widget build(BuildContext context) {
    final home = context.watch<Homeprovider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 29, 12, 60),
        centerTitle: true,
        title: const Text('Mening Kartam'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 29, 12, 60),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Key berildi
                    HomeView(key: _homeKey),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            3,
                            (index) => GestureDetector(
                              onTap: () async {
                                if (index == 0) {
                                  // BottomSheet natijasini kutamiz
                                  final isAdded = await showAddCardBottomSheet(
                                    context,
                                  );

                                  // Karta muvaffaqiyatli qo'shilgan bo'lsa, kartalarni yangilaymiz
                                  if (isAdded == true) {
                                    _homeKey.currentState?.refresh();
                                  }
                                }
                              },
                              child: Circlor(
                                icon: home.icon[index],
                                soz: home.soz[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: home.icons.length,
                  itemBuilder: (context, index) {
                    return Listviewcustom(
                      icon: home.icons[index],
                      soz: home.sozs[index],
                      ontap: () async{
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Tarix()),
                          );
                        } else if (index == home.icons.length - 1) {
                          showLogoutBottomSheet(context);
                        } else if (index == 1) {
                        await   Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Kartalar()),
                          );
                          setState(() {
                            
                          });
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
