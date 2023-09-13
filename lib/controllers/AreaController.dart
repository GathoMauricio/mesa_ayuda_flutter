import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../models/Area.dart';

class AreaController {
  Future<List<Area>> apiObtenerAreas() async {
    List<Area> lista = [Area(0, "--Seleccione una opción---")];
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String authToken = localStorage.getString("auth_token").toString();
    var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-obtener-areas');
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
          lista.add(Area(item['id'], item['area']));
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("Error de servidor");
    }
    return lista;
  }
}
