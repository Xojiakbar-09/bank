import 'package:bank_card/presentation/cubit/register_cubit.dart';
import 'package:bank_card/provider/homeprovider.dart';
import 'package:bank_card/provider/pincodeprovider.dart';
import 'package:bank_card/screens/pinkod.dart'; // PinCodeScreen faylingiz importi
import 'package:bank_card/screens/regiter.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // GetStorage'dan token bor-yo'qligini tekshiramiz
  final box = GetStorage();
  final String? token = box.read('token');

  runApp(
    MultiProvider(
      
      // Barcha ChangeNotifier larni shu yerga qo'yamiz
      providers: [
        ChangeNotifierProvider(create: (_) => PinProvider()),
        ChangeNotifierProvider(create: (_) => Homeprovider()),
        // Cubit'larni ham MultiProvider ichiga shunday qo'shish mumkin:
        BlocProvider(create: (_) => RegisterCubit()),
      ],
      child: MyApp(isLoggedIn: token != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: const ColorScheme.dark(primary: Colors.black)),
      // Token bo'lsa PinCodeScreen, bo'lmasa Register sahifasi ochiladi
      home: isLoggedIn ? const PinCodeScreen() : const Register(),
    );
  }
}