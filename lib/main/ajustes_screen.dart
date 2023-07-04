import 'package:cuts/login/login_screen.dart';
import 'package:cuts/models/UserModel.dart';
import 'package:cuts/network/NetworkUser.dart';
import 'package:cuts/utils/globals.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:settings_ui/settings_ui.dart';

class AjustesPage extends StatefulWidget {
  const AjustesPage({super.key});

  @override
  State<AjustesPage> createState() => _AjustesPageState();
}

class _AjustesPageState extends State<AjustesPage> {
  final _network = NetworkUser();
  UserModel? user;
  Future<UserModel?> getUser() async {
    user = await _network.read;
    return user;
  }

  var userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = getUser();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: FutureBuilder<UserModel?>(
            future: userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final user = snapshot.data;

                return SettingsList(
                  sections: [
                    SettingsSection(
                      title: Text('Datos Usuario'),
                      tiles: <SettingsTile>[
                        SettingsTile.navigation(
                          leading: Icon(FontAwesomeIcons.envelope),
                          title: Text(user!.email),
                        ),
                        SettingsTile.navigation(
                          leading: Icon(FontAwesomeIcons.person),
                          title: Text(user.nome),
                        ),
                        SettingsTile.navigation(
                          leading: Icon(FontAwesomeIcons.phone),
                          title: Text(user.movil),
                        ),
                      ],
                    ),
                    SettingsSection(
                      tiles: <SettingsTile>[
                        SettingsTile.navigation(
                          onPressed: (context) async {
                            await FirebaseAuth.instance.signOut().then(
                                (value) => Navigator.of(context)
                                    .pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()),
                                        (route) => false));
                          },
                          leading: const Icon(
                              FontAwesomeIcons.arrowRightFromBracket),
                          title: const Text('Finalizar sesión'),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
