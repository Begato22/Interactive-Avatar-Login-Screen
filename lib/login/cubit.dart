import 'package:animation_login/login/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitState());

  static LoginCubit get(context) => BlocProvider.of(context);
  late TextEditingController emailController;
  late TextEditingController passwordController;

  String basePath = 'assets/images/';

  List<Image?> motionList = [];
  int currentIndex = 0;
  bool isVisitable = true;

  void init() async {
    _prepareControllers();
    await _prepareMotrinList();
  }

  void _prepareControllers() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<void> _prepareMotrinList() async {
    for (var i = 1; i <= 33; i++) {
      motionList.add(await _loadImageFromAsset(_getImagePath(i)));
    }

    emit(Redraw());
  }

  Future<Image?> _loadImageFromAsset(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      return Image.memory(
        data.buffer.asUint8List(),
        fit: BoxFit.contain, // Optional: Set how the image should be displayed
      );
    } catch (_) {
      emit(Error());
      return null;
    }
  }

  String _getImagePath(int index) {
    return '$basePath$index.jpg';
  }

  void changeVisibility() {
    isVisitable = !isVisitable;
    if (isVisitable) {
      decreaseIndex();
    } else {
      increaseIndex();
    }
    emit(Redraw());
  }

  void increaseIndex() {
    currentIndex++;

    emit(Redraw());
  }

  void decreaseIndex() {
    if (currentIndex != 0) {
      currentIndex--;
    }
    emit(Redraw());
  }

  void enteredPasswordField() {
    currentIndex = MotionClip.hideEyes.start;

    emit(Redraw());
  }

  void leavePasswordField() {
    // cureentIndex = 20;
    emit(Redraw());
  }

  Future<void> onEmailTapped() async {
    if (emailController.text.isEmpty) {
      if (currentIndex != MotionClip.watchEmail.start) {
        while (currentIndex != MotionClip.watchEmail.start) {
          await Future.delayed(const Duration(milliseconds: 70)).then((value) {
            decreaseIndex();
          });
        }
      }
      return;
    }
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
      if (currentIndex != MotionClip.hideEyes.start) increaseIndex();
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
        if (action.isIncrease) {
          increaseIndex();
        } else {
          decreaseIndex();
        }
      });
    }
  }
}

enum MotionClip {
  watchEmail(0, 23),
  hideEyes(24, 31),
  showPassword(32, 33);

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
