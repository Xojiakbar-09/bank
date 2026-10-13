import 'package:bank_card/core/utils/checkcontroller.dart';
import 'package:bank_card/presentation/cubit/register_cubit.dart';
import 'package:bank_card/presentation/cubit/register_stet.dart';
import 'package:bank_card/presentation/cubit/uploud_image_cubit.dart';
import 'package:bank_card/screens/sign_in.dart';
import 'package:bank_card/widget/avatar.dart';
import 'package:bank_card/widget/snekbar.dart';
import 'package:bank_card/widget/vustomtext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 1. Asosiy sahifa - Cubit'lar shu yerda ulanadi
class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => UploadCubit()),
      ],
      child: const RegisterView(),
    );
  }
}

// 2. UI va dizayn qismi
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkcontroler(
      email: _emailController,
      password: _passwordController,
      userbane: _usernameController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.status == RegisterStatus.authentificate) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } else if (state.status == RegisterStatus.failure) {
            showTopSnackBar(context, "Xatolik yuz berdi", isError: true);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ro‘yxatdan o‘tish",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Bank xizmatlaridan foydalanish uchun hisob yarating",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Avatar yuklash vidjeti
                  const Center(
                    child: ProfileAvatarUpdateWidget(),
                  ),

                  const SizedBox(height: 30),
                  IosStyleTextField(
                    obscureText: false,
                    placeholder: "Enter your email",
                    controller: _emailController,
                  ),
                  const SizedBox(height: 12),
                  IosStyleTextField(
                    obscureText: true,
                    placeholder: "Enter your password",
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 12),
                  IosStyleTextField(
                    obscureText: false,
                    placeholder: "Enter your username",
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 40),

                  ValueListenableBuilder<bool>(
                    valueListenable: isbutten,
                    builder: (context, isButtonEnabled, child) {
                      return state.status == RegisterStatus.loading
                          ? const Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            )
                          : CupertinoButton.filled(
                              color: Colors.purple,
                              minimumSize: Size(
                                MediaQuery.sizeOf(context).width,
                                55,
                              ),
                              pressedOpacity: 0.4,
                              onPressed: isButtonEnabled
                                  ? () {
                                      // UploadCubit ichidagi rasmni olib signUp'ga yuboramiz
                                      final imageFile = context.read<UploadCubit>().state.image;

                                      context.read<RegisterCubit>().signUp(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        username: _usernameController.text,
                                        avatar: imageFile,
                                      );
                                    }
                                  : null,
                              child: const Text('Register'),
                            );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}