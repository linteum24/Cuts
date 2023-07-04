import 'dart:convert';

class EmpleadoModel {
  int? id;
  int id_store;
  String nome;
  String email;
  String movil;
  String photo;
  String? posicao;

  EmpleadoModel(
      {this.id,
      required this.id_store,
      required this.nome,
      required this.email,
      required this.movil,
      required this.photo,
      this.posicao});

  factory EmpleadoModel.fromJson(Map<String, dynamic> json) {
    return EmpleadoModel(
        id: json['id'],
        id_store: json['id_store'],
        nome: json['nome'],
        email: json['email'],
        movil: json['movil'],
        photo: json['photo'],
        posicao: json['posicao']);
  }

  Map<String, dynamic> get toJson => {
        'id': id.toString(),
        'id_store': id_store.toString(),
        'nome': nome,
        'email': email,
        'movil': movil,
        'photo': photo,
        'posicao': posicao
      };

  static Map<String, dynamic> toMap(EmpleadoModel empleado) => {
        'id': empleado.id,
        'id_store': empleado.id_store,
        'nome': empleado.nome,
        'email': empleado.email,
        'movil': empleado.movil,
        'photo': empleado.photo,
        'posicao': empleado.posicao
      };

  static String encode(List<EmpleadoModel> empleados) => json.encode(
        empleados
            .map<Map<String, dynamic>>(
                (empleado) => EmpleadoModel.toMap(empleado))
            .toList(),
      );

  static List<EmpleadoModel> decode(String empleados) =>
      (json.decode(empleados) as List<dynamic>)
          .map<EmpleadoModel>((item) => EmpleadoModel.fromJson(item))
          .toList();
}
