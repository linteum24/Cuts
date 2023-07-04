import 'dart:convert';

import 'package:cuts/main/booking_system/calendario_screen.dart';
import 'package:cuts/models/ServicioList.dart';
import 'package:cuts/models/ServicoModel.dart';
import 'package:cuts/network/NetworkUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicoPage extends StatefulWidget {
  const ServicoPage({Key? key}) : super(key: key);

  @override
  State<ServicoPage> createState() => _ServicoPageState();
}

class _ServicoPageState extends State<ServicoPage> {
  bool _customTileExpanded = false;
  int? selectedIndex;
  int? selected;
  final _network = NetworkUser();

  var futureServico;
  Future<List<ServicoModel>?> getListServico() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id_store');
    var servicoList = await _network.readServicos(id!);
    print(servicoList);
    return servicoList;
  }

  @override
  void initState() {
    futureServico = getListServico();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final double itemHeight = (screenSize.height - kToolbarHeight - 24) / 2;
    final double itemWidth = screenSize.width / 2;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              color: Colors.white,
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              }),
          centerTitle: true,
          title: Text(
            'Elija el Servicio',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          primary: true,
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: screenSize.height * 0.03,
                      right: screenSize.height * 0.03),
                  child: Column(children: [
                    SizedBox(height: 30.0),
                    FutureBuilder<List<ServicoModel>?>(
                        future: getListServico(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            final list = snapshot.data;

                            return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio:
                                            (itemWidth / itemHeight * 1.8),
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20),
                                itemCount: list!.length,
                                controller:
                                    ScrollController(keepScrollOffset: false),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext ctx, index) {
                                  var item = list[index];

                                  return GestureDetector(
                                      onTap: () async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        prefs.setString(
                                            'servico_nombre', item.nome);
                                        prefs.setString('servico_preco',
                                            item.preco.toString());
                                        prefs.setString('servico_tempo',
                                            item.tempo.toString());
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CalendarioPage()));
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            side: new BorderSide(
                                                color: Colors.black,
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        color: Colors.white,
                                        margin: new EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            bottom: screenSize.height * 0.02),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              item.nome,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      item.tempo.toString() +
                                                          ' Min',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      item.preco.toString() +
                                                          '€',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ));
                                });
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        }),
                  ]))),
        ));
  }
}
