import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuts/main/buscar_screen.dart';
import 'package:cuts/main/citas_screen.dart';
import 'package:cuts/main/list_biz_screen.dart';
import 'package:cuts/main/ajustes_screen.dart';
import 'package:cuts/utils/globals.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      controller.animateToPage(index,
          duration: Duration(seconds: 1), curve: Curves.linear);
    });
  }

  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> updateDataFirestore(
      String collectionPath, String path, Map<String, String> dataNeedUpdate) {
    return FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getStreamFireStore(
      String pathCollection, int limit, String? textSearch) {
    if (textSearch?.isNotEmpty == true) {
      return FirebaseFirestore.instance
          .collection(pathCollection)
          .limit(limit)
          .where(Globals.nickname, isEqualTo: textSearch)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(pathCollection)
          .limit(limit)
          .snapshots();
    }
  }

  void registerNotification() {
    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AndroidNotification? android = message.notification?.android;
      print('onMessage: $message');
      if (message.notification != null && android != null) {
        showNotification(message.notification!);
      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('push token: $token');
      if (token != null) {
        updateDataFirestore(Globals.pathUserCollection,
            Globals.firebaseUser!.uid, {'pushToken': token});
      }
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('drawable/app_icon');
    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      Platform.isAndroid ? 'com.example.cuts' : 'com.example.cuts',
      'Cuts',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    print(remoteNotification);

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
        color: Colors.black, // Status bar color
        child: SafeArea(
            left: false,
            right: false,
            bottom: false,
            child: Scaffold(
                body: SafeArea(
                    child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller,
                  children: <Widget>[
                    ListBussinessPage(
                      itemTapped: _onItemTapped,
                    ),
                    BuscarPage(),
                    CitasPage(),
                    AjustesPage()
                  ],
                )),
                bottomNavigationBar: Theme(
                  data: ThemeData(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    showUnselectedLabels: true,
                    elevation: 0,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.heart),
                        label: 'Tú Cuts',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.magnifyingGlass),
                        label: 'Buscar',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.calendar_month_outlined),
                        label: 'Citas',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.user),
                        label: 'Profile',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    unselectedItemColor: Colors.grey,
                    selectedItemColor: Colors.white,
                    backgroundColor: Colors.black,
                    onTap: _onItemTapped,
                  ),
                ))));
  }
}
