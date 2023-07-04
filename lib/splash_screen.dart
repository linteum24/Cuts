import 'package:cuts/login/about_you_screen.dart';
import 'package:cuts/login/login_screen.dart';
import 'package:cuts/network/NetworkUser.dart';
import 'package:cuts/utils/globals.dart';
import 'package:cuts/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:cuts/main/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'SplashScreen';

  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  NetworkUser _network = NetworkUser();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      (() async {
        final isLoggedIn = Globals.firebaseUser != null;

        if (!mounted) return;
        if (isLoggedIn == false) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => LoginPage(),
            ),
          );
        } else {
          var email;
          bool? check;
          if (Globals.firebaseUser!.email == null ||
              Globals.firebaseUser!.email!.isEmpty) {
            final prefs = await SharedPreferences.getInstance();
            email = prefs.getString('email');
            check = await _network.checkRegister(email);
          } else
            check = await _network.checkRegister(Globals.firebaseUser!.email!);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  check == true ? AboutYouPage() : HomePage(),
            ),
          );
        }
      })();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: CustomLoader(),
      ),
    );
  }
}
