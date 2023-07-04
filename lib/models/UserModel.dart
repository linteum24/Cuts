import 'dart:convert';

class UserModel {
  String id;
  String email;
  String nome;
  String dt_nascimento;
  String movil;

  UserModel(
      {required this.id,
      required this.email,
      required this.nome,
      required this.dt_nascimento,
      required this.movil});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        email: json['email'],
        nome: json['nome'],
        dt_nascimento: json['dt_nascimento'],
        movil: json['movil']);
  }

  Map<String, dynamic> get toJson => {
        'id': id,
        'email': email,
        'nome': nome,
        'dt_nascimento': dt_nascimento,
        'movil': movil,
      };

  static Map<String, dynamic> toMap(UserModel servicioModel) => {
        'id': servicioModel.id,
        'email': servicioModel.email,
        'nome': servicioModel.nome,
        'dt_nascimento': servicioModel.dt_nascimento,
        'movil': servicioModel.movil,
      };

  static String encode(List<UserModel> users) => json.encode(
        users
            .map<Map<String, dynamic>>((user) => UserModel.toMap(user))
            .toList(),
      );

  static List<UserModel> decode(String users) =>
      (json.decode(users) as List<dynamic>)
          .map<UserModel>((user) => UserModel.fromJson(user))
          .toList();
}
