import 'package:animation_login/login/cubit/cubit.dart';
import 'package:animation_login/login/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
                      SizedBox(height: 20),
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.teal,
                          radius: 72,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage:
                                Image.asset(cubit.imageList[cubit.cureentIndex])
                                    .image,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      defaultTextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefix: Icons.email,
                        label: 'Email',
                      ),
                      SizedBox(height: 10),
                      defaultPasswordField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          prefix: Icons.lock,
                          label: 'Password',
                          suffix: cubit.isVisiable
                              ? Icons.visibility
                              : Icons.visibility_off,
                          suffixFunc: () {
                            cubit.changeVisivility();
                          },
                          obscureText: cubit.isVisiable),
                      SizedBox(height: 10),
                      defultButton(onPressed: () {}, lable: 'login')
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

  Widget defultButton({
    required Function onPressed,
    required String lable,
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
            lable.toUpperCase(),
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
            },
            onChanged: (value) {
              print(value.length);
              print(LoginCubit.get(context).cureentIndex);
              if (value.length > LoginCubit.get(context).cureentIndex) {
                if (LoginCubit.get(context).cureentIndex != 24) {
                  LoginCubit.get(context).increaseIndex();
                }
              } else {
                if (emailController.text.length == 0) {
                  LoginCubit.get(context).cureentIndex = 0;
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
                cubit.cureentIndex = 0;
              }
            },
          );
        },
      );
}
