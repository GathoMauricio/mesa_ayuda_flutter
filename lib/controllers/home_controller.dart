import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mesa_ayuda/models/ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController {
  Future<List<Ticket>> apiHome() async {
    List<Ticket> lista = [];
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String authToken = localStorage.getString("auth_token").toString();

    var url;
    if (dotenv.env['APP_DEBUG'].toString() == "true") {
      url = Uri.https(dotenv.env['SERVER_URL'].toString(),
          '${dotenv.env['PROJECT_PATH']}api-home');
    } else {
      url = Uri.http(dotenv.env['SERVER_URL'].toString(),
          '${dotenv.env['PROJECT_PATH']}api-home');
    }
    var response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $authToken',
      },
    );

    // var jsonResponse =
    //     convert.jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      try {
        String body = utf8.decode(response.bodyBytes);
        var jsonData = convert.jsonDecode(body);
        //print(jsonData['datos']);
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
}
