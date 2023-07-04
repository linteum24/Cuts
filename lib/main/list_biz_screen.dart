import 'package:cuts/main/booking_system/worker_screen.dart';
import 'package:cuts/maps_launcher/lib/maps_launcher.dart';
import 'package:cuts/models/FavModel.dart';
import 'package:cuts/models/StoreModel.dart';
import 'package:cuts/network/NetworkUser.dart';
import 'package:cuts/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListBussinessPage extends StatefulWidget {
  Function itemTapped;
  ListBussinessPage({super.key, required this.itemTapped});

  @override
  State<ListBussinessPage> createState() => _ListBussinessPageState();
}

class _ListBussinessPageState extends State<ListBussinessPage> {
  final _network = NetworkUser();
  late ScrollController _scrollController;
  double heighFav = 0;
  late String id_user;
  List<FavModel>? listFav;
  Future<List<FavModel>?> getListFav() async {
    id_user = await Globals.firebaseUser!.uid;
    listFav = await _network.readFav;
    return listFav;
  }

  var futureFav, futureStore;

  Future<List<StoreModel>?> getListStore() async {
    List<StoreModel>? listStore = await _network.readStores;
    return listStore;
  }

  double _scrollPosition = 0;
  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    futureFav = getListFav();
    futureStore = getListStore();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              PreferredSize(
                preferredSize: screenSize / 3, // Set this height
                child: Container(
                  padding: EdgeInsets.all(15),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/app_icon_sbg.png",
                        width: screenSize.width * 0.2,
                        height: screenSize.height * 0.078,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        style: TextStyle(color: Colors.white),
                        readOnly: true,
                        keyboardType: TextInputType.text,
                        onTap: () => widget.itemTapped(1),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            focusColor: Colors.grey,
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: "Buscar",
                            fillColor: Colors.transparent,
                            prefixIcon: Icon(
                              FontAwesomeIcons.magnifyingGlass,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Favoritos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                  height: screenSize.height * 0.40,
                  child: FutureBuilder<List<FavModel>?>(
                      future: futureFav,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          final list = snapshot.data;
                          if (list!.isEmpty || list == null)
                            return Center(child: Text("Sin Favoritos"));
                          return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: list.length,
                              itemBuilder: (BuildContext context, int index) {
                                var item = list[index];
                                return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: ClampingScrollPhysics(),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                          width: screenSize.width * 0.7,
                                          child: Card(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            elevation: 5,
                                            margin: EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                Stack(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  children: [
                                                    Image.network(
                                                      'https://via.placeholder.com/300?text=BREVE',
                                                      height:
                                                          screenSize.height *
                                                              0.21,
                                                      width: screenSize.width *
                                                          0.7,
                                                      fit: BoxFit.fill,
                                                    ),
                                                    IconButton(
                                                      onPressed: () async {
                                                        bool checkFav =
                                                            await _network
                                                                .deleteFav(
                                                          id_user,
                                                          item.id_store,
                                                        );
                                                        if (checkFav) {
                                                          setState(() {
                                                            futureFav =
                                                                getListFav();
                                                            futureStore =
                                                                getListStore();
                                                          });
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Favorito borrado con suceso",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                              timeInSecForIosWeb:
                                                                  3,
                                                              backgroundColor:
                                                                  Colors.green,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0);
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Error! Intente Nuevamente",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                              timeInSecForIosWeb:
                                                                  3,
                                                              webBgColor:
                                                                  "#FF0000",
                                                              backgroundColor:
                                                                  Colors.red,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0);
                                                        }
                                                      },
                                                      icon: const Icon(
                                                          FontAwesomeIcons
                                                              .solidHeart),
                                                      color: Colors.red,
                                                    )
                                                  ],
                                                ),
                                                Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Text(
                                                      item.nombre_store,
                                                      style: TextStyle(
                                                          fontSize:
                                                              screenSize.width *
                                                                  0.035,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                        child: Text(
                                                      item.morada,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    )),
                                                    IconButton(
                                                        onPressed: () {
                                                          MapsLauncher
                                                              .launchCoordinates(
                                                                  item.lat,
                                                                  item.lon);
                                                        },
                                                        icon: const Icon(
                                                            FontAwesomeIcons
                                                                .diamondTurnRight))
                                                  ],
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.black),
                                                    onPressed: () async {
                                                      final prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      prefs.setString(
                                                          'id_store',
                                                          item.id_store);
                                                      prefs.setString(
                                                          'id_login',
                                                          item.id_login);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  WorkerPage()));
                                                    },
                                                    child: const Text(
                                                      'Reservar Ya',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))
                                              ],
                                            ),
                                          )),
                                    ));
                              });
                        } else if (!snapshot.hasData) {
                          return Center(child: Text("Sin Favoritos"));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      })),
              const Divider(),
              SizedBox(
                height: 8,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Cerca Tuya',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                  height: screenSize.height * 0.4,
                  child: FutureBuilder<List<StoreModel>?>(
                      future: futureStore,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          final list = snapshot.data;

                          return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: list!.length,
                              itemBuilder: (BuildContext context, int index) {
                                var item = list[index];

                                return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: ClampingScrollPhysics(),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                          width: screenSize.width * 0.7,
                                          child: Card(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            elevation: 5,
                                            margin: EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                Stack(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  children: [
                                                    Image.network(
                                                      'https://via.placeholder.com/300?text=BREVE',
                                                      height:
                                                          screenSize.height *
                                                              0.21,
                                                      width: screenSize.width *
                                                          0.7,
                                                      fit: BoxFit.fill,
                                                    ),
                                                    IconButton(
                                                        onPressed: () async {
                                                          if (item.fav == 0) {
                                                            bool checkFav = await _network.writeFav(FavModel(
                                                                id_user:
                                                                    id_user,
                                                                id_store: item
                                                                    .id
                                                                    .toString(),
                                                                id_login: item
                                                                    .id_login,
                                                                email:
                                                                    item.email,
                                                                nombre_store: item
                                                                    .nombre_store,
                                                                dueno:
                                                                    item.dueno,
                                                                movil:
                                                                    item.movil,
                                                                morada:
                                                                    item.morada,
                                                                lat: item.lat,
                                                                lon: item.lon));
                                                            if (checkFav) {
                                                              setState(() {
                                                                futureFav =
                                                                    getListFav();
                                                                futureStore =
                                                                    getListStore();
                                                              });
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Favorito agregado con suceso",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                  timeInSecForIosWeb:
                                                                      3,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Error! Intente Nuevamente",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                  timeInSecForIosWeb:
                                                                      3,
                                                                  webBgColor:
                                                                      "#FF0000",
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);
                                                            }
                                                          } else {
                                                            bool checkFav =
                                                                await _network
                                                                    .deleteFav(
                                                              id_user,
                                                              item.id
                                                                  .toString(),
                                                            );
                                                            if (checkFav) {
                                                              setState(() {
                                                                futureFav =
                                                                    getListFav();
                                                                futureStore =
                                                                    getListStore();
                                                              });
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Favorito borrado con suceso",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                  timeInSecForIosWeb:
                                                                      3,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Error! Intente Nuevamente",
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                  timeInSecForIosWeb:
                                                                      3,
                                                                  webBgColor:
                                                                      "#FF0000",
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);
                                                            }
                                                          }
                                                        },
                                                        icon: item.fav == 0
                                                            ? const Icon(
                                                                FontAwesomeIcons
                                                                    .heart)
                                                            : const Icon(
                                                                FontAwesomeIcons
                                                                    .solidHeart),
                                                        color: Colors.red)
                                                  ],
                                                ),
                                                Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Text(
                                                      item.nombre_store,
                                                      style: TextStyle(
                                                          fontSize:
                                                              screenSize.width *
                                                                  0.035,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                        child: Text(
                                                      item.morada,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    )),
                                                    IconButton(
                                                        onPressed: () {
                                                          MapsLauncher
                                                              .launchCoordinates(
                                                                  item.lat,
                                                                  item.lon);
                                                        },
                                                        icon: const Icon(
                                                            FontAwesomeIcons
                                                                .diamondTurnRight)),
                                                  ],
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.black),
                                                    onPressed: () async {
                                                      final prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      prefs.setString(
                                                          'id_store',
                                                          item.id.toString());
                                                      prefs.setString(
                                                          'id_login',
                                                          item.id_login);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  WorkerPage()));
                                                    },
                                                    child: const Text(
                                                        'Reservar Ya',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)))
                                              ],
                                            ),
                                          )),
                                    ));
                              });
                        } else if (!snapshot.hasData) {
                          return Center(child: Text("Sin locales disponibles"));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      })),
            ])));
  }

  Future<bool> checkIfFav(String id, String nombre) async {
    bool checkIfFav = await _network.checkFav(id, nombre);
    return checkIfFav;
  }
}
