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

class LoginButton extends StatefulWidget {
  final Function onPressed;
  final String label;
  final bool isDisabled = false;
  final Color color = Colors.teal;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.label,
    isDisabled = false,
    color = Colors.teal,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40.0,
      child: ElevatedButton(
        onPressed: () => widget.isDisabled ? null : widget.onPressed(),
        style: ElevatedButton.styleFrom(backgroundColor: widget.isDisabled ? Colors.grey : Colors.teal),
        child: Text(widget.label.toUpperCase()),
      ),
    );
  }
}

class DefaultTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData prefix;
  final IconData? suffix;
  final Function? suffixFunc;
  final String label;
  final bool? obscureText;
  const DefaultTextField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.prefix,
    required this.label,
    this.suffix,
    this.suffixFunc,
    this.obscureText = false,
  });

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  late LoginCubit _cubit;
  @override
  void initState() {
    _cubit = context.read<LoginCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            label: Text(widget.label),
            prefixIcon: Icon(widget.prefix),
            suffixIcon: GestureDetector(child: Icon(widget.suffix), onTap: () => widget.suffixFunc!()),
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
          ),
          obscureText: widget.obscureText ?? false,
          onTap: () => _cubit.onEmailTapped(),
          validator: (val) {
            if (val!.isEmpty) {
              return 'you must add ${widget.label}';
            }
            return null;
          },
          onChanged: (value) => _cubit.onEmailChanged(value),
        );
      },
    );
  }
}

class DefaultPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData prefix;
  final IconData? suffix;
  final Function? suffixFunc;
  final String label;
  final bool obscureText;
  const DefaultPasswordField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.prefix,
    this.suffix,
    this.suffixFunc,
    required this.label,
    this.obscureText = false,
  });

  @override
  State<DefaultPasswordField> createState() => _DefaultPasswordFieldState();
}

class _DefaultPasswordFieldState extends State<DefaultPasswordField> {
  late LoginCubit _cubit;
  @override
  void initState() {
    _cubit = context.read<LoginCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.prefix),
            suffixIcon: GestureDetector(
              child: Icon(widget.suffix),
              onTap: () => widget.suffixFunc!(),
            ),
            label: Text(widget.label),
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
          ),
          obscureText: widget.obscureText,
          validator: (val) {
            if (val!.isEmpty) {
              return 'you must add ${widget.label}';
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
}
