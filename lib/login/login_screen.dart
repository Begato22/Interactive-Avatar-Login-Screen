// ignore_for_file: avoid_print

import 'package:animation_login/login/cubit/cubit.dart';
import 'package:animation_login/login/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            body: Center(
              child: Padding(
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
                            backgroundImage:
                                Image.asset(cubit.imageList[cubit.currentIndex])
                                    .image,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      defaultTextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefix: Icons.email,
                        label: 'Email',
                      ),
                      const SizedBox(height: 10),
                      defaultPasswordField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          prefix: Icons.lock,
                          label: 'Password',
                          suffix: cubit.isVisitable
                              ? Icons.visibility
                              : Icons.visibility_off,
                          suffixFunc: () {
                            cubit.changeVisibility();
                          },
                          obscureText: cubit.isVisitable),
                      const SizedBox(height: 10),
                      defaultButton(onPressed: () {}, label: 'login')
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget defaultButton({
    required Function onPressed,
    required String label,
    bool isDisabled = false,
    Color color = Colors.teal,
  }) =>
      SizedBox(
        width: double.infinity,
        height: 40.0,
        child: ElevatedButton(
          onPressed: () => isDisabled ? null : onPressed(),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDisabled ? Colors.grey : Colors.teal,
          ),
          child: Text(
            label.toUpperCase(),
          ),
        ),
      );
  Widget defaultTextField({
    required TextEditingController controller,
    required TextInputType keyboardType,
    required IconData prefix,
    IconData? suffix,
    Function? suffixFunc,
    //  String? validator,
    required String label,
    bool obscureText = false,
  }) =>
      BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return TextFormField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(prefix),
              suffixIcon: GestureDetector(
                child: Icon(suffix),
                onTap: () => suffixFunc!(),
              ),
              label: Text(label),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
            ),
            obscureText: obscureText,
            validator: (val) {
              if (val!.isEmpty) {
                return 'you must add $label';
              }
              return null;
            },
            onChanged: (value) {
              print(value.length);
              print(LoginCubit.get(context).currentIndex);
              if (value.length > LoginCubit.get(context).currentIndex) {
                if (LoginCubit.get(context).currentIndex != 24) {
                  LoginCubit.get(context).increaseIndex();
                }
              } else {
                if (emailController.text.isEmpty) {
                  LoginCubit.get(context).currentIndex = 0;
                }
                LoginCubit.get(context).decreaseIndex();
              }
            },
          );
        },
      );
  Widget defaultPasswordField({
    required TextEditingController controller,
    required TextInputType keyboardType,
    required IconData prefix,
    IconData? suffix,
    Function? suffixFunc,
    //  String? validator,
    required String label,
    bool obscureText = false,
  }) =>
      BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return TextFormField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(prefix),
              suffixIcon: GestureDetector(
                child: Icon(suffix),
                onTap: () => suffixFunc!(),
              ),
              label: Text(label),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
            ),
            obscureText: obscureText,
            validator: (val) {
              if (val!.isEmpty) {
                return 'you must add $label';
              }
              return null;
            },
            onTap: () async {
              cubit.enteredPasswordField();
              for (int i = 0; i < 6; i++) {
                await Future.delayed(const Duration(milliseconds: 100))
                    .then((value) {
                  cubit.increaseIndex();
                });
              }
            },
            onEditingComplete: () {
              FocusManager.instance.primaryFocus?.unfocus();
              cubit.leavePasswordField();
              print('object');
              for (int i = 0; i < 7; i++) {
                Future.delayed(const Duration(milliseconds: 200)).then((value) {
                  cubit.decreaseIndex();
                });
              }
              if (emailController.text.isEmpty) {
                cubit.currentIndex = 0;
              }
            },
          );
        },
      );
}
