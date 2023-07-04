import 'package:cuts/login/about_you_screen.dart';
import 'package:cuts/login/auth.dart';
import 'package:cuts/main/home.dart';
import 'package:cuts/network/NetworkUser.dart';
import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  NetworkUser _network = NetworkUser();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          tileMode: TileMode.repeated,
          colors: [
            // use your preferred colors
            Colors.black,
            Color(0xff0F2027),
            Color(0xff203A43),
            Color(0xff2C5364),
          ],
          // start at the top
          begin: Alignment.topCenter,
          // end at the bottom
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: screenSize.height * 0.08,
            ),
            Image.asset(
              "assets/images/app_icon_sbg.png",
              width: screenSize.width * 0.55,
              height: screenSize.height * 0.2,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: screenSize.height * 0.2,
            ),
            Padding(
                padding: EdgeInsets.only(
                    left: screenSize.width * 0.1,
                    right: screenSize.width * 0.1),
                child: SocialLoginButton(
                  buttonType: SocialLoginButtonType.google,
                  height: screenSize.height * 0.07,
                  borderRadius: 20,
                  fontSize: screenSize.width * 0.05,
                  onPressed: () async {
                    await signInWithGoogle(context).then((result) async {
                      bool check = await _network.checkRegister(result!.email!);
                      if (result != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) =>
                                  check == true ? AboutYouPage() : HomePage()),
                        );
                      }
                    }).catchError((error) {
                      print('Registration Error: $error');
                    });
                  },
                )),
            /*SizedBox(
              height: screenSize.height * 0.03,
            ),
            Padding(
                padding: EdgeInsets.only(
                    left: screenSize.width * 0.1,
                    right: screenSize.width * 0.1),
                child: SocialLoginButton(
                  height: screenSize.height * 0.07,
                  borderRadius: 20,
                  fontSize: screenSize.width * 0.05,
                  buttonType: SocialLoginButtonType.facebook,
                  onPressed: () async {
                    await signInWithFacebook().then((result) async {
                      bool check = await _network.checkRegister(result!.email!);
                      print(result);
                      if (result != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) =>
                                  check == true ? AboutYouPage() : HomePage()),
                        );
                      }
                    }).catchError((error) {
                      print('Registration Error: $error');
                    });
                  },
                )),*/
            Spacer(),
          ],
        ),
      ),
    ));
  }
}
