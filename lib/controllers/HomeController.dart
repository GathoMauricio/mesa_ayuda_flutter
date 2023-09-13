import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mesa_ayuda/helpers/mensajes.dart' as mensajes;
import 'package:mesa_ayuda/models/Ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class HomeController {
  Future<List<Ticket>> apiHome() async {
    List<Ticket> lista = [];
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String authToken = localStorage.getString("auth_token").toString();

    var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-home');
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
        for (var item in jsonData['datos']) {
          lista.add(Ticket(
              item['id'],
              item['estatus'],
              item['area'],
              item['categoria'],
              item['sintoma'],
              item['usuarioFinal'],
              item['folio'],
              item['prioridad'],
              item['descripcion']));
        }
      } catch (e) {
        print("Error al obtener la información");
      }
    } else {
      print("Error de servidor");
    }
    return lista;
  }

  Future<Object> hayNuevaVersion() async {
    var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-ultima-version-android');
    var response = await http.post(url);
    if (response.statusCode == 200) {
      try {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (dotenv.env['APP_VERSION'] == jsonResponse['última_version']) {
          return {"estatus": false, "version": jsonResponse['última_version']};
        } else {
          return {"estatus": true, "version": jsonResponse['última_version']};
        }
      } catch (e) {
        return {"estatus": false, "version": null};
      }
    } else {
      return {"estatus": false, "version": null};
    }
  }
}
