// ignore_for_file: avoid_print

import 'package:animation_login/login/cubit/cubit.dart';
import 'package:animation_login/login/cubit/states.dart';
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
                          defaultTextField(
                            controller: _cubit.emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefix: Icons.email,
                            label: 'Email',
                          ),
                          const SizedBox(height: 10),
                          defaultPasswordField(
                            controller: _cubit.passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            prefix: Icons.lock,
                            label: 'Password',
                            suffix: _cubit.isVisitable ? Icons.visibility : Icons.visibility_off,
                            suffixFunc: () => _cubit.changeVisibility(),
                            obscureText: _cubit.isVisitable,
                          ),
                          const SizedBox(height: 10),
                          defaultButton(onPressed: () async => await _cubit.reset(), label: 'login')
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
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
          style: ElevatedButton.styleFrom(backgroundColor: isDisabled ? Colors.grey : Colors.teal),
          child: Text(label.toUpperCase()),
        ),
      );

  Widget defaultTextField({
    required TextEditingController controller,
    required TextInputType keyboardType,
    required IconData prefix,
    IconData? suffix,
    Function? suffixFunc,
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
              label: Text(label),
              prefixIcon: Icon(prefix),
              suffixIcon: GestureDetector(child: Icon(suffix), onTap: () => suffixFunc!()),
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            ),
            obscureText: obscureText,
            onTap: () => _cubit.onEmailTapped(),
            validator: (val) {
              if (val!.isEmpty) {
                return 'you must add $label';
              }
              return null;
            },
            onChanged: (value) => _cubit.onEmailChanged(value),
          );
        },
      );

  Widget defaultPasswordField({
    required TextEditingController controller,
    required TextInputType keyboardType,
    required IconData prefix,
    IconData? suffix,
    Function? suffixFunc,
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
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            ),
            obscureText: obscureText,
            validator: (val) {
              if (val!.isEmpty) {
                return 'you must add $label';
              }
              return null;
            },
            onTap: () async => await _cubit.onPasswordTapped(),
            onEditingComplete: () {
              FocusManager.instance.primaryFocus?.unfocus();
              _cubit.leavePasswordField();
              for (int i = 0; i < 7; i++) {
                Future.delayed(const Duration(milliseconds: 200)).then((value) {
                  _cubit.decreaseIndex();
                });
              }
              if (_cubit.emailController.text.isEmpty) {
                _cubit.currentIndex = 0;
              }
            },
          );
        },
      );
}
