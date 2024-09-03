import 'package:animation_login/login/cubit.dart';
import 'package:animation_login/login/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
