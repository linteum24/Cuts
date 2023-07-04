import 'dart:convert';

class StoreModel {
  int id;
  String id_login;
  String email;
  String nombre_store;
  String dueno;
  String movil;
  String morada;
  double lat;
  double lon;
  int? fav;

  StoreModel(
      {required this.id,
      required this.id_login,
      required this.email,
      required this.nombre_store,
      required this.dueno,
      required this.movil,
      required this.morada,
      required this.lat,
      required this.lon,
      this.fav});

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
        id: json['id'],
        id_login: json['id_login'],
        email: json['email'],
        nombre_store: json['nombre_store'],
        dueno: json['dueno'],
        movil: json['movil'],
        morada: json['morada'],
        lat: json['lat'],
        lon: json['lon'],
        fav: json['fav']);
  }

  Map<String, dynamic> get toJson => {
        'id': id.toString(),
        'id_login': id_login,
        'email': email,
        'nombreStore': nombre_store,
        'dueno': dueno,
        'movil': movil,
        'morada': morada,
        'lat': lat.toString(),
        'lon': lon.toString(),
        'fav': fav
      };

  static Map<String, dynamic> toMap(StoreModel storeModel) => {
        'id': storeModel.id,
        'id_login': storeModel.id_login,
        'email': storeModel.email,
        'nombre_store': storeModel.nombre_store,
        'dueno': storeModel.dueno,
        'movil': storeModel.movil,
        'morada': storeModel.morada,
        'lat': storeModel.lat,
        'lon': storeModel.lon,
        'fav': storeModel.fav
      };

  static String encode(List<StoreModel> stores) => json.encode(
        stores
            .map<Map<String, dynamic>>((store) => StoreModel.toMap(store))
            .toList(),
      );

  static List<StoreModel> decode(String stores) =>
      (json.decode(stores) as List<dynamic>)
          .map<StoreModel>((store) => StoreModel.fromJson(store))
          .toList();
}
