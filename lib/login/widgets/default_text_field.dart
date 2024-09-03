import 'package:animation_login/login/cubit.dart';
import 'package:animation_login/login/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
