import 'package:cuts/main/booking_system/servico_screen.dart';
import 'package:cuts/models/EmpleadoModel.dart';
import 'package:cuts/network/NetworkUser.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerPage extends StatefulWidget {
  const WorkerPage({Key? key}) : super(key: key);

  @override
  State<WorkerPage> createState() => _WorkerPageState();
}

class _WorkerPageState extends State<WorkerPage> {
  int? selectedIndex;
  final _network = NetworkUser();

  Future<List<EmpleadoModel>?> getListEmpleados() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id_store');
    return _network.readEmpleados(id!);
  }

  @override
  void initState() {
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
          title: Text(
            'Elija el Empleado',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
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
                    FutureBuilder<List<EmpleadoModel>?>(
                        future: getListEmpleados(),
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
                                            (itemWidth / itemHeight * 1.3),
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
                                        prefs.setInt('worker_id', item.id!);
                                        prefs.setString(
                                            'worker_nombre', item.nome);
                                        prefs.setString(
                                            'worker_photo', item.photo);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ServicoPage()));
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
                                            /*imagesList[index].isNotEmpty
                                                ? Image.asset(
                                                    'assets/balram.jpg',
                                                    width:
                                                        screenSize.width * 0.15,
                                                    height:
                                                        screenSize.height * 0.1,
                                                  )
                                                : Icon(
                                                    Icons.cut_sharp,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),*/
                                            SizedBox(
                                              height: 15,
                                            ),
                                            SizedBox(
                                                width: screenSize.width * 0.2,
                                                child: Text(
                                                  item.nome,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ));
                                });
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  ]))),
        ));
  }
}
