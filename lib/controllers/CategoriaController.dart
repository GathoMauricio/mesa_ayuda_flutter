import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../models/Categoria.dart';

class CategoriaController {
  Future<List<Categoria>> apiObtenerCategoriasPorArea(int areaId) async {
    List<Categoria> lista = [Categoria(0, "--Seleccione una opción---")];
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String authToken = localStorage.getString("auth_token").toString();
    var url = Uri.http(
        dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-obtener-tipos-servicio',
        {'service_area_id': areaId}
            .map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      try {
        String body = convert.utf8.decode(response.bodyBytes);
        var jsonData = convert.jsonDecode(body);
        for (var item in jsonData) {
          lista.add(Categoria(item['id'], item['name']));
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    } else {
      if (kDebugMode) print("Error de servidor");
    }
    return lista;
  }
}
