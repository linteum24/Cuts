import 'dart:async';
import 'dart:convert';
import 'package:cuts/models/CitasModel.dart';
import 'package:cuts/models/EmpleadoModel.dart';
import 'package:cuts/models/FavModel.dart';
import 'package:cuts/models/ScheduleList.dart';
import 'package:cuts/models/ServicioList.dart';
import 'package:cuts/models/ServicoModel.dart';
import 'package:cuts/models/StoreModel.dart';
import 'package:cuts/models/UserModel.dart';
import 'package:cuts/utils/globals.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NetworkUser {
  final _baseUrl = 'https://servercutsv2-fftzzyeluq-oa.a.run.app/';

//User Crud
  Future<UserModel?> get read async {
    var email;
    final prefs = await SharedPreferences.getInstance();

    if (Globals.firebaseUser!.email == null ||
        Globals.firebaseUser!.email!.isEmpty)
      email = prefs.getString('email');
    else
      email = Globals.firebaseUser!.email;
    final url = '${_baseUrl}user/read/$email';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body)[0]);
    }
    return null;
  }

  Future<bool> write(
    UserModel userModel,
  ) async {
    final url = '${_baseUrl}user/write';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: userModel.toJson,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'));

    switch (response.statusCode) {
      case 503:
        return true;
      default:
        return false;
    }
  }

  Future<bool> checkRegister(String email) async {
    final url = '${_baseUrl}user/checkRegister';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: {"email": email},
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'));
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }

  Future<void> update(
    UserModel userModel,
  ) async {
    final url = '${_baseUrl}user/update';
    final uri = Uri.parse(url);
    await http.post(
      uri,
      body: userModel.toJson,
    );
  }

  //Citas

  Future<List<CitasModel>> readCitas(String id, String fecha) async {
    final url = '${_baseUrl}booking/readCitas';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: {"id": id, "fecha": fecha},
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'));

    return CitasModel.decode(response.body);
  }

  Future<List<CitasModel>> readUserCitas(String id_user) async {
    final url = '${_baseUrl}user/readUserCitas';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: {"id_user": id_user},
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'));

    return CitasModel.decode(response.body);
  }

  Future<bool> writeCitas(
    CitasModel citasModel,
  ) async {
    final url = '${_baseUrl}user/writeCitas';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: citasModel.toJson,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'));
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }

  Future<bool> checkBook(
      String idStore, String idEmpleado, String startTime) async {
    final url = '${_baseUrl}booking/checkBook';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: {
          "id_store": idStore,
          "id_empleado": idEmpleado,
          "startTime": startTime
        },
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'));
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }

  //Favoritos

  Future<bool> writeFav(
    FavModel favModel,
  ) async {
    final url = '${_baseUrl}user/writeFav';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: favModel.toJson,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'));

    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }

  Future<bool> checkFav(String id, String nombre) async {
    final url = '${_baseUrl}user/checkFav';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: {"id": id, "nombreStore": nombre},
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'));
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }

  Future<bool> deleteFav(String id, String id_store) async {
    final url = '${_baseUrl}user/deleteFav';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: {"id": id, "id_store": id_store},
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'));
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }

  Future<List<FavModel>?> get readFav async {
    String idUser = await Globals.firebaseUser!.uid;
    final url = '${_baseUrl}user/readFav?id_user=$idUser';
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return FavModel.decode(response.body);
    }
    return null;
  }

  //Tienda

  Future<List<StoreModel>?> get readStores async {
    var id_user = Globals.firebaseUser!.uid;
    final url = "${_baseUrl}user/readStores?id_user=" + id_user;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return StoreModel.decode(response.body);
    }
    return null;
  }

  Future<StoreModel?> readStore(int id) async {
    final url = '${_baseUrl}user/readUserStore';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: {
          "id": id.toString(),
        },
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'));
    return StoreModel.fromJson(jsonDecode(response.body)[0]);
  }

  //Servicios

  Future<List<ServicoModel>> readServicos(String id) async {
    final url = '${_baseUrl}user/readServicos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: {
          "id": id,
        },
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'));
    return ServicoModel.decode(jsonDecode(response.body)[0]['servicoList']);
  }

  //Empleados

  Future<List<EmpleadoModel>> readEmpleados(String id) async {
    final url = '${_baseUrl}user/readEmpleados';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: {"id": id},
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'));

    return EmpleadoModel.decode(response.body);
  }

  //Schedule

  Future<ScheduleList> readSchedule(String id) async {
    final url = '${_baseUrl}user/readSchedule';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: {
          "id": id,
        },
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'));
    return ScheduleList.fromJson(jsonDecode(response.body)[0]);
  }
}
