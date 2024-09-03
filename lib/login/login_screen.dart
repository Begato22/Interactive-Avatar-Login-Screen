// ignore_for_file: avoid_print

import 'package:animation_login/login/cubit.dart';

import 'package:animation_login/login/states.dart';
import 'package:animation_login/login/widgets/default_password_field.dart';
import 'package:animation_login/login/widgets/default_text_field.dart';
import 'package:animation_login/login/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginCubit _cubit;

  @override
  void initState() {
    _cubit = BlocProvider.of<LoginCubit>(context);
    _cubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: _cubit.motionList.isEmpty
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.teal,
                              radius: 72,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: _cubit.motionList[_cubit.currentIndex]?.image,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          DefaultTextField(
                            controller: _cubit.emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefix: Icons.email,
                            label: 'Email',
                          ),
                          const SizedBox(height: 10),
                          DefaultPasswordField(
                            controller: _cubit.passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            prefix: Icons.lock,
                            label: 'Password',
                            suffix: _cubit.isVisitable ? Icons.visibility : Icons.visibility_off,
                            suffixFunc: () => _cubit.changeVisibility(),
                            obscureText: _cubit.isVisitable,
                          ),
                          const SizedBox(height: 10),
                          LoginButton(onPressed: () async => await _cubit.reset(), label: 'login')
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
