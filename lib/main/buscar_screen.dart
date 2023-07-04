import 'dart:convert';
import 'dart:math';

import 'package:cuts/main/booking_system/worker_screen.dart';
import 'package:cuts/maps_launcher/lib/maps_launcher.dart';
import 'package:cuts/models/FavModel.dart';
import 'package:cuts/models/StoreModel.dart';
import 'package:cuts/network/NetworkUser.dart';
import 'package:cuts/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuscarPage extends StatefulWidget {
  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage>
    with AutomaticKeepAliveClientMixin {
  PersistentBottomSheetController? controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late MapController mapcontroller;
  double? lat, lon;
  final _network = NetworkUser();
  List<StoreModel>? listStore;

  getLatLon() async {
    final url = Uri.parse('http://ip-api.com/json/');
    final data = await http.get(url);
    Map<String, dynamic> map = jsonDecode(data.body);
    lat = map['lat'] as double;
    lon = map['lon'] as double;
  }

  @override
  void initState() {
    super.initState();
    getLatLon();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void dispose() {
    super.dispose();
    mapcontroller.dispose();
  }

  final ScrollController listViewController = new ScrollController();

  getListStore(BuildContext context) async {
    var screenSize = MediaQuery.of(context).size;
    listStore = await _network.readStores;
    for (int x = 0; x < listStore!.length; x++) {
      await mapcontroller.addMarker(
          GeoPoint(latitude: listStore![x].lat, longitude: listStore![x].lon),
          markerIcon: MarkerIcon(
            icon: Icon(
              FontAwesomeIcons.locationDot,
              color: Colors.black,
              size: screenSize.width * 0.15,
            ),
          ),
          angle: pi / 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Stack(children: <Widget>[
      Scaffold(
        key: _scaffoldKey,
        body: FutureBuilder(
            future: getLatLon(),
            builder: ((context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    setState(() {
                      getLatLon();
                    });
                    return Text('Error: ${snapshot.error}');
                  } else {
                    mapcontroller = MapController(
                      initMapWithUserPosition: false,
                      initPosition: GeoPoint(latitude: lat!, longitude: lon!),
                    );
                    getListStore(context);

                    return OSMFlutter(
                      controller: mapcontroller,
                      trackMyPosition: false,
                      initZoom: 10,
                      minZoomLevel: 8,
                      maxZoomLevel: 18,
                      stepZoom: 1.0,
                      onGeoPointClicked: (p0) {
                        _settingModalBottomSheet(context, p0);
                      },
                    );
                  }
                case ConnectionState.none:
                  return const Text('none');
              }
            })),
      )
    ]);
  }

  @override
  bool get wantKeepAlive => true;

  void _settingModalBottomSheet(BuildContext context, GeoPoint coord) async {
    var screenSize = MediaQuery.of(context).size;
    String id = Globals.firebaseUser!.uid;

    final index = listStore!.indexWhere((element) =>
        element.lat == coord.latitude && element.lon == coord.longitude);
    controller = _scaffoldKey.currentState!.showBottomSheet(
        constraints: BoxConstraints(
            minWidth: screenSize.width * 0.5,
            maxWidth: screenSize.width * 0.7,
            minHeight: screenSize.height * 0.5 * 9.0 / 16.0,
            maxHeight: screenSize.height * 0.7 * 9.0 / 16.0),
        enableDrag: true, (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return PointerInterceptor(
            // debug: true,
            child: SizedBox(
          width: screenSize.width * 0.5,
          height: screenSize.height * 0.33,
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(5),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Image.network(
                      'https://via.placeholder.com/300?text=DITTO',
                      height: screenSize.height * 0.15,
                      width: screenSize.width * 0.7,
                      fit: BoxFit.fill,
                    ),
                    IconButton(
                        onPressed: () async {
                          if (listStore![index].fav == 0) {
                            bool checkFav = await _network.writeFav(FavModel(
                                id_user: id,
                                id_store: listStore![index].id.toString(),
                                id_login: listStore![index].id_login,
                                email: listStore![index].email,
                                nombre_store: listStore![index].nombre_store,
                                dueno: listStore![index].dueno,
                                movil: listStore![index].movil,
                                morada: listStore![index].morada,
                                lat: listStore![index].lat,
                                lon: listStore![index].lon));
                            if (checkFav) {
                              setState(() {
                                listStore![index].fav = 1;
                              });

                              Fluttertoast.showToast(
                                  msg: "Favorito agregado con suceso",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Error! Intente Nuevamente",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 3,
                                  webBgColor: "#FF0000",
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          } else {
                            bool checkFav = await _network.deleteFav(
                              id,
                              listStore![index].id.toString(),
                            );
                            if (checkFav) {
                              setState(() {
                                listStore![index].fav = 0;
                              });
                              Fluttertoast.showToast(
                                  msg: "Favorito borrado con suceso",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Error! Intente Nuevamente",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 3,
                                  webBgColor: "#FF0000",
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          }
                        },
                        icon: listStore![index].fav == 0
                            ? const Icon(FontAwesomeIcons.heart)
                            : const Icon(FontAwesomeIcons.solidHeart),
                        color: Colors.red)
                  ],
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(listStore![index].nombre_store)),
                Row(
                  children: [
                    Flexible(
                        child: Text(
                      listStore![index].morada,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )),
                    IconButton(
                        onPressed: () {
                          MapsLauncher.launchCoordinates(
                              listStore![index].lat, listStore![index].lon);
                        },
                        icon: const Icon(FontAwesomeIcons.diamondTurnRight)),
                  ],
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString(
                          'id_store', listStore![index].id.toString());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkerPage()));
                    },
                    child: const Text('Reservar Ya',
                        style: TextStyle(color: Colors.white)))
              ],
            ),
          ),
        ));
      });
    });
  }
}
