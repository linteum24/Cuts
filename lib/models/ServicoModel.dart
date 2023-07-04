import 'dart:convert';

class ServicoModel {
  int? id;
  String nome;
  int tempo;
  double preco;

  ServicoModel(
      {this.id, required this.nome, required this.tempo, required this.preco});

  factory ServicoModel.fromJson(Map<String, dynamic> json) {
    return ServicoModel(
        nome: json['nome'],
        tempo: int.parse(json['tempo'].toString()),
        preco: double.parse(json['preco'].toString()));
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'nome': nome, 'tempo': tempo, 'preco': preco};

  static Map<String, dynamic> toMap(ServicoModel servicioModel) => {
        'id': servicioModel.id,
        'nome': servicioModel.nome,
        'tempo': servicioModel.tempo,
        'preco': servicioModel.preco
      };

  static String encode(List<ServicoModel> servicios) => json.encode(
        servicios
            .map<Map<String, dynamic>>(
                (servicio) => ServicoModel.toMap(servicio))
            .toList(),
      );

  static List<ServicoModel> decode(String servicios) =>
      (json.decode(servicios) as List<dynamic>)
          .map<ServicoModel>((item) => ServicoModel.fromJson(item))
          .toList();
}
