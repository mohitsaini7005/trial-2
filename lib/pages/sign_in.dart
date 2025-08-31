import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:lali/view/login/login.dart';
import 'package:lali/widgets/button.dart';
import '../blocs/internet_bloc.dart';
import '../blocs/sign_in_bloc.dart';
import '../core/config/config.dart';
import '../pages/done.dart';
import '../core/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/language.dart';



class SignInPage extends StatefulWidget {

  final String tag;
  const SignInPage({super.key, required this.tag});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  bool googleSignInStarted = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();


  handleSkip (){
    final sb = context.read<SignInBloc>();
    sb.setGuestUser();
    nextScreen(context, const DonePage());
    
  }


  handleGoogleSignIn() async{
    final sb = context.read<SignInBloc>();
    final ib = context.read<InternetBloc>();
    setState(() =>googleSignInStarted = true);
    await ib.checkInternet();
    if(ib.hasInternet == false){
      Get.snackbar("Error", 'check your internet connection!');
      
    }else{
      await sb.signInWithGoogle().then((_){
        if(sb.hasError == true){
          Get.snackbar("Error", 'something is wrong. please try again.');
          setState(() =>googleSignInStarted = false);

        }else {
          sb.checkUserExists().then((value){
          if(value == true){
            sb.getUserDatafromFirebase(sb.uid)
            .then((value) => sb.saveDataToSP()
            .then((value) => sb.guestSignout())
            .then((value) => sb.setSignIn()
            .then((value){
              setState(() =>googleSignInStarted = false);
              afterSignIn();
            })));
          } else{
            sb.getJoiningDate()
            .then((value) => sb.saveToFirebase()
            .then((value) => sb.increaseUserCount())
            .then((value) => sb.saveDataToSP()
            .then((value) => sb.guestSignout()
            .then((value) => sb.setSignIn()
            .then((value){
              setState(() => googleSignInStarted = false);
              afterSignIn();
            })))));
          }
            });
          
        }
      });
    }
  }

  afterSignIn (){
      nextScreen(context, const DonePage());
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      key: scaffoldKey,
      appBar: AppBar(
        actions: [
          widget.tag == 'onBoarding'
              ? const SizedBox.shrink()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    elevation: 0,
                  ),
                  onPressed: () => handleSkip(),
                  child: const Text('Guest',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      )).tr()),

          IconButton(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(0),
            iconSize: 22,
            icon: const Icon(Icons.language,),
            onPressed: (){
              nextScreenPopup(context, const LanguagePopup());
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'welcome to',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey[700]),
                  ).tr(),
                  const SizedBox(height: 5,),
                  Text(
                    Config().appName,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey[700]
                    ),
                  ),
                ],
              )),
          Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      'welcome message',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700]),
                    ).tr(),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 3,
                    width: MediaQuery.of(context).size.width * 0.50,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(40)),
                  ),
                ],
              )),
          Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyButton(
                    text: "Sign in with Email",
                    onTap: () => nextScreen(context, const Login()),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: ElevatedButton(
                        onPressed: () => handleGoogleSignIn(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                       
                        child: googleSignInStarted == false
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/google.png',
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Sign In with Google',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor),
                                  )
                                ],
                              )
                            : const Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: Colors.white),
                              )),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05)
                ],
              )),
        ],
      ),
    );
  }



  
}
