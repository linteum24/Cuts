import 'package:cuts/main/home.dart';
import 'package:cuts/models/CitasModel.dart';
import 'package:cuts/models/ScheduleModel.dart';
import 'package:cuts/models/UserModel.dart';
import 'package:cuts/network/NetworkUser.dart';
import 'package:cuts/time_slot/lib/model/time_slot_Interval.dart';
import 'package:cuts/time_slot/lib/time_slot_from_interval.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({Key? key}) : super(key: key);

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  //coger la hora
  DateTime? selectTime;
  //Coger el dia
  DatePickerController datePickerController = DatePickerController();
  DateTime _selectedValue = DateTime.now();
  //BottomSheet Variables
  PersistentBottomSheetController? controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? nombre, photo, servicoNombre, servicoPreco, servicoTempo, id_login;
  int? idStore, idEmpleado;
  //List variables y funcion
  final _network = NetworkUser();
  UserModel? user;
  getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    idStore = int.parse(prefs.getString('id_store')!);
    idEmpleado = prefs.getInt('worker_id');
    id_login = prefs.getString('id_login');
    nombre = prefs.getString('worker_nombre');
    photo = prefs.getString('worker_photo');
    servicoNombre = prefs.getString('servico_nombre');
    servicoPreco = prefs.getString('servico_preco');
    servicoTempo = prefs.getString('servico_tempo');
    user = await _network.read;
  }

  List<ScheduleModel>? listSchedule;
  var futureSchedule;
  Future<List<ScheduleModel>> getListSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id_store')!;
    var scheduleList = await _network.readSchedule(id);
    listSchedule = scheduleList.list;
    return listSchedule!;
  }

  List<CitasModel>? listCitas;
  Future<List<CitasModel>> getCitas(DateTime fecha) async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id_store')!;
    listCitas =
        await _network.readCitas(id, DateFormat('yyyy-MM-dd').format(fecha));
    return listCitas!;
  }

  @override
  void initState() {
    getPrefs();
    futureSchedule = getListSchedule();
    getCitas(_selectedValue);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _settingModalBottomSheet(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              color: Colors.white,
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context)
                  ..pop()
                  ..pop();
              }),
          centerTitle: true,
          title: Text(
            'Elija Fecha y Hora',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          child: FutureBuilder<List<ScheduleModel>?>(
              future: futureSchedule,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final list = snapshot.data;

                  return Column(children: [
                    DatePicker(
                      DateTime.now(),
                      locale: "es_ES",
                      width: 60,
                      height: screenSize.height * 0.11,
                      controller: datePickerController,
                      initialSelectedDate: _selectedValue,
                      selectionColor: Colors.black,
                      selectedTextColor: Colors.white,
                      daysCount: 40,
                      onDateChange: (date) {
                        // New date selected
                        for (int x = 0; x < list!.length; x++) {
                          if (!list[x].on_off && date.weekday == list[x].id) {
                            Fluttertoast.showToast(
                                msg: "Encerrado! Intente otro dia",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }
                        setState(() {
                          futureSchedule = getListSchedule();
                          _selectedValue = date;
                          getCitas(date);
                          selectTime = date;
                        });
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: screenSize.width * 0.03,
                            right: screenSize.width * 0.03),
                        child: TimesSlotGridViewFromInterval(
                          initTime: _selectedValue,
                          crossAxisCount: 4,
                          listCitas: listCitas,
                          servicoTempo: int.parse(servicoTempo!),
                          selectedColor: Colors.black,
                          unSelectedColor: Colors.grey[50],
                          day: _selectedValue,
                          timeSlotInterval: TimeSlotInterval(
                            start:
                                listSchedule![_selectedValue.weekday - 1].on_off
                                    ? listSchedule![_selectedValue.weekday - 1]
                                        .initTime
                                    : TimeOfDay(hour: 0, minute: 0),
                            end:
                                listSchedule![_selectedValue.weekday - 1].on_off
                                    ? listSchedule![_selectedValue.weekday - 1]
                                        .endTime
                                    : TimeOfDay(hour: 0, minute: 0),
                            interval: const Duration(hours: 0, minutes: 15),
                          ),
                          onChange: (value) {
                            setState(() {
                              _selectedValue = value;
                              selectTime = value;
                            });
                          },
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                  ]);
                }
                return const Center(child: CircularProgressIndicator());
              }),
        ));
  }

  void _settingModalBottomSheet(BuildContext context) async {
    var screenSize = MediaQuery.of(context).size;
    controller = _scaffoldKey.currentState!.showBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        enableDrag: false, (BuildContext context) {
      return Container(
          color: Colors.black,
          child: Padding(
              padding: EdgeInsets.only(
                  left: screenSize.width * 0.03,
                  right: screenSize.width * 0.03),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Pedido',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Image.network(
                        'https://via.placeholder.com/300?text=DITTO',
                        height: 50,
                        width: 50,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nombre!,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            servicoNombre!,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            servicoPreco! + '€',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            servicoTempo! + ' Min',
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      )
                    ],
                  ),
                  ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.white),
                      ),
                      onPressed: () {
                        bool? check;
                        for (var day in listSchedule!) {
                          if (day.id == _selectedValue.weekday) {
                            check = day.on_off;
                          }
                        }
                        if (!check!) {
                          Fluttertoast.showToast(
                              msg: "Elija Otro Dia!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (listSchedule![_selectedValue.weekday - 1]
                                    .initTime
                                    .hour >
                                selectTime!.hour ||
                            listSchedule![_selectedValue.weekday - 1]
                                    .endTime
                                    .hour <
                                selectTime!.hour) {
                          Fluttertoast.showToast(
                              msg: "Elija Otra hora!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          final dt =
                              DateFormat('yyyy-MM-dd').format(_selectedValue);

                          saveCita(
                              idStore!,
                              idEmpleado!,
                              user!.id,
                              user!.nome,
                              user!.email,
                              user!.movil,
                              dt,
                              selectTime.toString(),
                              servicoTempo!,
                              servicoNombre!,
                              servicoPreco!,
                              '');
                        }
                      },
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(color: Colors.black),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )));
    });
  }

  Future<void> saveCita(
    int idStore,
    int idEmpleado,
    String idUser,
    String nome,
    String email,
    String movil,
    String fecha,
    String startTime,
    String tempoServico,
    String tituloServico,
    String preco,
    String notas,
  ) async {
    if (idUser.isNotEmpty &&
        nome.isNotEmpty &&
        movil.isNotEmpty &&
        fecha.isNotEmpty &&
        tituloServico.isNotEmpty) {
      final time = DateTime.parse(startTime);
      final endTime = time.add(Duration(minutes: int.parse(tempoServico)));
      var s = CitasModel(
          id: null,
          id_store: idStore,
          id_empleado: idEmpleado,
          id_user: idUser,
          id_login: id_login!,
          nome: nome,
          email: email,
          movil: movil,
          fecha: fecha,
          startTime: startTime,
          endTime: endTime.toString(),
          tituloServico: tituloServico,
          preco: preco,
          notas: notas);
      bool c = await _network.checkBook(
          idStore.toString(), idEmpleado.toString(), startTime);
      if (c) {
        await _network.writeCitas(s);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        Fluttertoast.showToast(
            msg: "Cita creada con suceso",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Error! Ya esta ocupada",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            webBgColor: "#FF0000",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Error! Rellena todos los campos",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          webBgColor: "#FF0000",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
