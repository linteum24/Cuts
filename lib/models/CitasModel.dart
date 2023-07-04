import 'dart:convert';

class CitasModel {
  int? id;
  int id_store;
  int id_empleado;
  String? id_user;
  String id_login;
  String nome;
  String email;
  String movil;
  String fecha;
  String startTime;
  String endTime;
  String tituloServico;
  String preco;
  String notas;

  CitasModel({
    this.id,
    required this.id_store,
    required this.id_empleado,
    this.id_user,
    required this.id_login,
    required this.nome,
    required this.email,
    required this.movil,
    required this.fecha,
    required this.startTime,
    required this.endTime,
    required this.tituloServico,
    required this.preco,
    required this.notas,
  });

  factory CitasModel.fromJson(Map<String, dynamic> json) {
    return CitasModel(
        id: json['id'],
        id_store: json['id_store'],
        id_empleado: json['id_empleado'],
        id_user: json['id_user'],
        id_login: json['id_login'],
        nome: json['nome'],
        email: json['email'],
        movil: json['movil'],
        fecha: json['fecha'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        tituloServico: json['tituloServico'],
        preco: json['preco'],
        notas: json['notas']);
  }

  Map<String, dynamic> get toJson => {
        'id': id.toString(),
        'id_store': id_store.toString(),
        'id_empleado': id_empleado.toString(),
        'id_user': id_user.toString(),
        'id_login': id_login,
        'nome': nome,
        'email': email,
        'movil': movil,
        'fecha': fecha,
        'startTime': startTime,
        'endTime': endTime,
        'tituloServico': tituloServico,
        'preco': preco,
        'notas': notas
      };

  static Map<String, dynamic> toMap(CitasModel cita) => {
        'id': cita.id.toString(),
        'id_store': cita.id_store.toString(),
        'id_empleado': cita.id_empleado.toString(),
        'id_user': cita.id_user.toString(),
        'id_login': cita.id_login,
        'nome': cita.nome,
        'email': cita.email,
        'movil': cita.movil,
        'fecha': cita.fecha,
        'startTime': cita.startTime,
        'endTime': cita.endTime,
        'tituloServico': cita.tituloServico,
        'preco': cita.preco,
        'notas': cita.notas
      };

  static String encode(List<CitasModel> citas) => json.encode(
        citas
            .map<Map<String, dynamic>>((cita) => CitasModel.toMap(cita))
            .toList(),
      );

  static List<CitasModel> decode(String citas) =>
      (json.decode(citas) as List<dynamic>)
          .map<CitasModel>((cita) => CitasModel.fromJson(cita))
          .toList();
}
