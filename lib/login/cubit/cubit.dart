import 'package:animation_login/login/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitiState());

  static LoginCubit get(context) => BlocProvider.of(context);

  String basePath = 'assets/images/';

  List<String> imageList = [
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/3.jpg',
    'assets/images/4.jpg',
    'assets/images/5.jpg',
    'assets/images/6.jpg',
    'assets/images/7.jpg',
    'assets/images/8.jpg',
    'assets/images/9.jpg',
    'assets/images/10.jpg',
    'assets/images/11.jpg',
    'assets/images/12.jpg',
    'assets/images/13.jpg',
    'assets/images/14.jpg',
    'assets/images/15.jpg',
    'assets/images/16.jpg',
    'assets/images/17.jpg',
    'assets/images/18.jpg',
    'assets/images/19.jpg',
    'assets/images/20.jpg',
    'assets/images/21.jpg',
    'assets/images/22.jpg',
    'assets/images/23.jpg',
    'assets/images/24.jpg',
    'assets/images/25.jpg',
    'assets/images/26.jpg',
    'assets/images/27.jpg',
    'assets/images/28.jpg',
    'assets/images/29.jpg',
    'assets/images/30.jpg',
    'assets/images/31.jpg',
    'assets/images/32.jpg',
    'assets/images/33.jpg',
  ];

  int currentIndex = 0;

  bool isVisiable = true;

  void changeVisivility() {
    isVisiable = !isVisiable;
    if (isVisiable) {
      decreaseIndex();
    } else {
      increaseIndex();
    }
    emit(LoginChangeVisibilityState());
  }

  void increaseIndex() {
    currentIndex++;

    emit(LoginIncreaseIndexState());
  }

  void decreaseIndex() {
    if (currentIndex != 0) {
      currentIndex--;
    }
    emit(LoginDecreaseIndexState());
  }

  void enteredPasswordField() {
    currentIndex = 25;

    emit(LoginEnterPasswordFieldState());
  }

  void leavePasswordField() {
    // cureentIndex = 20;
    emit(LoginLeavePassordFieldState());
  }
}
