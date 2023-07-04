import 'dart:convert';
import 'package:cuts/models/ServicoModel.dart';

class ServicioList {
  int? id;
  int id_store;
  List<ServicoModel> list;

  ServicioList({
    this.id,
    required this.id_store,
    required this.list,
  });

  factory ServicioList.fromJson(Map<String, dynamic> json) {
    var servico = json['servicoList'].toString().replaceAll(r"\", "");
    return ServicioList(
      id: json['id'],
      id_store: json['id_store'],
      list: ServicoModel.decode(servico),
    );
  }

  Map<String, dynamic> get toJson => {
        'id': id.toString(),
        'id_store': id_store.toString(),
        'servicoList': ServicoModel.encode(list),
      };

  static Map<String, dynamic> toMap(ServicioList scheduleList) => {
        'id': scheduleList.id,
        'id_store': scheduleList.id_store,
        'servicoList': scheduleList.list,
      };
}
