import 'dart:convert';

class FavModel {
  int? id;
  String id_user;
  String id_store;
  String id_login;
  String email;
  String nombre_store;
  String dueno;
  String movil;
  String morada;
  double lat;
  double lon;

  FavModel(
      {this.id,
      required this.id_user,
      required this.id_store,
      required this.id_login,
      required this.email,
      required this.nombre_store,
      required this.dueno,
      required this.movil,
      required this.morada,
      required this.lat,
      required this.lon});

  factory FavModel.fromJson(Map<String, dynamic> json) {
    return FavModel(
        id: json['id'],
        id_user: json['id_user'],
        id_store: json['id_store'],
        id_login: json['id_login'],
        email: json['email'],
        nombre_store: json['nombre_store'],
        dueno: json['dueno'],
        movil: json['movil'],
        morada: json['morada'],
        lat: json['lat'],
        lon: json['lon']);
  }

  Map<String, dynamic> get toJson => {
        'id': id.toString(),
        'id_user': id_user,
        'id_store': id_store,
        'id_login': id_login,
        'email': email,
        'nombreStore': nombre_store,
        'dueno': dueno,
        'movil': movil,
        'morada': morada,
        'lat': lat.toString(),
        'lon': lon.toString()
      };

  static Map<String, dynamic> toMap(FavModel favModel) => {
        'id': favModel.id,
        'id_user': favModel.id_user,
        'id_store': favModel.id_store,
        'id_login': favModel.id_login,
        'email': favModel.email,
        'nombre_store': favModel.nombre_store,
        'dueno': favModel.dueno,
        'movil': favModel.movil,
        'morada': favModel.morada,
        'lat': favModel.lat,
        'lon': favModel.lon
      };

  static String encode(List<FavModel> favs) => json.encode(
        favs.map<Map<String, dynamic>>((fav) => FavModel.toMap(fav)).toList(),
      );

  static List<FavModel> decode(String favs) =>
      (json.decode(favs) as List<dynamic>)
          .map<FavModel>((fav) => FavModel.fromJson(fav))
          .toList();
}
