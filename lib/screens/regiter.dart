import 'package:bank_card/core/utils/checkcontroller.dart';
import 'package:bank_card/presentation/cubit/register_cubit.dart';
import 'package:bank_card/presentation/cubit/register_stet.dart';
import 'package:bank_card/screens/pinkod.dart';
import 'package:bank_card/screens/sign_in.dart';
import 'package:bank_card/widget/snekbar.dart';
import 'package:bank_card/widget/vustomtext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
            showTopSnackBar(
              context,
              "xatolik yuz berdi", 
              isError: true,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                          "Ro‘yxatdan o‘tish",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Bank xizmatlaridan foydalanish uchun hisob yarating",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                  const SizedBox(height: 50),
                  IosStyleTextField(
                    obscureText: false,
                    placeholder: "Enter your email",
                    controller: _emailController,
                  ),
                  IosStyleTextField(
                    obscureText: true,
                    placeholder: "Enter your password",
                    controller: _passwordController,
                  ),
                  IosStyleTextField(
                    obscureText: false,
                    placeholder: "Enter your username",
                    controller: _usernameController,
                  ),
                  const Spacer(),
                  ValueListenableBuilder<bool>(
                    valueListenable: isbutten,
                    builder: (context, isButtonEnabled, child) {
                      return state.status == RegisterStatus.loading
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               CircularProgressIndicator(
                                color: Colors.white,
                               ),
                            ],
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
                                      context.read<RegisterCubit>().signUp(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        username: _usernameController.text,
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
