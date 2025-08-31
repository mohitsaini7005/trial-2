import 'package:get/get.dart';
import 'package:lali/blocs/internet_bloc.dart';
import 'package:lali/blocs/sign_in_bloc.dart';
import 'package:lali/data/api/api.dart';
import 'package:lali/view/forgot_password/controller/forgot_password_controller.dart';
// import 'package:lali/view/login/controller/login_controller.dart';
import 'package:lali/view/signup/controller/signup_controller.dart';
// import '../../view/reset_password/controller/change_password_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => SignUpController(Get.find()));
    //Get.lazyPut(() => LoginController(Get.find()));
    Get.lazyPut(() => ForgotPasswordController(Get.find()));
    //Get.lazyPut(() => ChangePasswordController(Get.find()));
    Get.lazyPut(() => SignInBloc());
    Get.lazyPut(() => InternetBloc());
  }
}
