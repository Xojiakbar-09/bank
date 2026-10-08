import 'package:bank_card/presentation/cubit/register_cubit.dart';
import 'package:bank_card/provider/homeprovider.dart';
import 'package:bank_card/provider/pincodeprovider.dart';
import 'package:bank_card/screens/pinkod.dart'; 
import 'package:bank_card/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();

  final token = await FlutterSecureStorage().read(key: "jwt");

  // 2. Token bo'lmasa Register o'rniga LoginScreen ochiladi
  final Widget initialScreen = (token != null && token.isNotEmpty) 
      ? PinCodeScreen() 
      : LoginScreen(); 

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PinProvider()),
        ChangeNotifierProvider(create: (_) => Homeprovider()),
        BlocProvider(create: (_) => RegisterCubit()),
      ],
      child: MyApp(initialScreen: initialScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  
  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: const ColorScheme.dark(primary: Colors.black)),
      home: initialScreen, 
    );
  }
}