import 'dart:async';

import 'package:animation_login/login/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitState());

  static LoginCubit get(context) => BlocProvider.of(context);
  late TextEditingController emailController;
  late TextEditingController passwordController;

  String basePath = 'assets/images/';

  int currentIndex = 1;
  bool isVisitable = true;

  void init() async {
    _prepareControllers();
  }

  void _prepareControllers() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<void> prepareMotrinList(BuildContext context) async {
    for (int i = 1; i <= 33; i++) {
      String path = _getImagePath(i);
      scheduleMicrotask(() async {
        await precacheImage(AssetImage(path), context);
      });
    }

    emit(Redraw());
  }

  String _getImagePath(int index) => '$basePath$index.jpg';

  void changeVisibility() {
    isVisitable = !isVisitable;
    if (isVisitable) {
      decreaseIndex(decreaseValue: 3);
    } else {
      increaseIndex(setValue: 33);
    }
    emit(Redraw());
  }

  void increaseIndex({int? setValue, int? increaseValue}) {
    currentIndex = setValue ?? currentIndex + (increaseValue ?? 1);
    emit(Redraw());
  }

  void decreaseIndex({int? setValue, int? decreaseValue}) {
    if (currentIndex == 1) return;

    currentIndex = setValue ?? currentIndex - (decreaseValue ?? 1);
    emit(Redraw());
  }

  void enteredPasswordField() {
    currentIndex = currentIndex >= MotionClip.hideEyes.start ? currentIndex : MotionClip.hideEyes.start;

    emit(Redraw());
  }

  void leavePasswordField() {
    // cureentIndex = 20;
    emit(Redraw());
  }

  Future<void> onEmailTapped() async {
    if (emailController.text.isEmpty) {
      if (currentIndex != MotionClip.watchEmail.start) {
        while (currentIndex != MotionClip.hideEyes.start) {
          await Future.delayed(const Duration(milliseconds: 100)).then((value) {
            decreaseIndex();
          });
        }
        currentIndex = MotionClip.watchEmail.start;
      }
      return;
    } else {
      if (emailController.text.length >= MotionClip.watchEmail.end) {
        currentIndex = MotionClip.watchEmail.end;
      } else {
        while (currentIndex != emailController.text.length) {
          await Future.delayed(const Duration(milliseconds: 70)).then((value) {
            decreaseIndex();
          });
        }
      }
    }
    emit(Redraw());
  }

  Future<void> onPasswordTapped() async {
    enteredPasswordField();
    while (currentIndex != MotionClip.hideEyes.end) {
      await Future.delayed(const Duration(milliseconds: 100)).then((value) {
        increaseIndex();
      });
    }
  }

  void onEmailChanged(String value) {
    if (value.length > currentIndex) {
      if (currentIndex <= MotionClip.watchEmail.end) increaseIndex();
    } else {
      if (emailController.text.isEmpty) currentIndex = MotionClip.watchEmail.start;
      decreaseIndex();
    }
  }

  Future<void> reset() async {
    emailController.text = '';
    passwordController.text = '';
    while (currentIndex != MotionClip.watchEmail.start) {
      await Future.delayed(const Duration(milliseconds: 100)).then((value) {
        decreaseIndex();
      });
    }
  }

  Future<void> palyMotion(bool query, MotionAction action) async {
    while (query) {
      await Future.delayed(const Duration(milliseconds: 100)).then((value) {
        action.isIncrease ? increaseIndex() : decreaseIndex();
      });
    }
  }
}

enum MotionClip {
  watchEmail(1, 25),
  hideEyes(27, 31),
  showPassword(31, 33);

  final int start;
  final int end;

  const MotionClip(this.start, this.end);
}

enum MotionAction {
  increase,
  decrease;

  bool get isIncrease => this == increase;
  bool get isDecrease => this == decrease;
}
