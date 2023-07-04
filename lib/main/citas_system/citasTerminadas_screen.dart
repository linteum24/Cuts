import 'package:cuts/models/CitasModel.dart';
import 'package:cuts/network/NetworkUser.dart';
import 'package:cuts/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CitasTerminadasPage extends StatefulWidget {
  const CitasTerminadasPage({super.key});

  @override
  State<CitasTerminadasPage> createState() => _CitasTerminadasPageState();
}

class _CitasTerminadasPageState extends State<CitasTerminadasPage> {
  var _network = NetworkUser();
  var futureCitas;
  List<String> stores_nome = [];
  Future<List<CitasModel>> getCitas() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('id');
    var list = await _network.readUserCitas(uid!);
    for (int i = 0; i < list.length; i++) {
      var store = await _network.readStore(list[i].id_store);
      stores_nome.add(store!.nombre_store);
    }
    return list;
  }

  @override
  void initState() {
    futureCitas = getCitas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
          child: FutureBuilder<List<CitasModel>?>(
              future: futureCitas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final list = snapshot.data;
                  if (list!.isEmpty || list == null) {
                    return Center(
                      child: Text('Sin Citas Terminadas'),
                    );
                  }
                  return RefreshIndicator(
                      onRefresh: () {
                        return Future(() {
                          setState(() {
                            futureCitas = getCitas();
                          });
                        });
                      },
                      child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8),
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            var item = list[index];
                            var nome_store = stores_nome[index];
                            if (DateTime.parse(item.endTime)
                                .isBefore(DateTime.now())) {
                              return SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  physics: ClampingScrollPhysics(),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                        width: screenSize.width * 0.7,
                                        height: screenSize.height * 0.2,
                                        child: Card(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            elevation: 5,
                                            margin: EdgeInsets.all(10),
                                            child: Row(children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    item.tituloServico,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    nome_store,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )
                                                ],
                                              ),
                                              Spacer(),
                                              VerticalDivider(),
                                              Column(
                                                children: [
                                                  Text(DateFormat.MMMM().format(
                                                      DateTime.parse(
                                                          item.startTime))),
                                                  Text(DateFormat.d().format(
                                                      DateTime.parse(
                                                          item.startTime))),
                                                  Text(DateFormat.y().format(
                                                      DateTime.parse(
                                                          item.startTime))),
                                                  Text(DateFormat.Hm().format(
                                                      DateTime.parse(
                                                          item.startTime))),
                                                ],
                                              )
                                            ]))),
                                  ));
                            } else {
                              if (DateTime.parse(item.endTime)
                                      .isAfter(DateTime.now()) &&
                                  list.length == 1) {
                                return Container();
                              }
                            }
                          }));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No tienes Citas'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
    );
  }
}
