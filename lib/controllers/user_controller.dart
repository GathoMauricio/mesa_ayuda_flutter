import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  Future<bool> apiLogin(String email, String password) async {
    var datos = {"email": email, "password": password};
    var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-login', datos);
    var response = await http.post(url);
    //print(response.body);
    if (response.statusCode == 200) {
      try {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['estatus'] == 1) {
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.setString("auth_token", jsonResponse['auth_token']);
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    } else {
      //print('Request failed with status: ${response.body}.');
      return false;
    }
  }

  Future<bool> apiLogout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String authToken = localStorage.getString("auth_token").toString();
    var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-logout');
    var response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $authToken',
      },
    );
    //print(response.body);
    if (response.statusCode == 200) {
      try {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['estatus'] == 1) {
          localStorage.remove('auth_token');
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> apiDatosUsuario() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String authToken = localStorage.getString("auth_token").toString();

    var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-datos-usuario');

    var response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $authToken',
      },
    );
    //print(response.body);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonResponse;
        String body = utf8.decode(response.bodyBytes);
        jsonResponse = convert.jsonDecode(body) as Map<String, dynamic>;
        if (jsonResponse['estatus'] == 1) {
          return true;
        } else {
          localStorage.remove('auth_token');
          return false;
        }
      } catch (e) {
        localStorage.remove('auth_token');
        return false;
      }
    } else {
      localStorage.remove('auth_token');
      return false;
    }
  }
}
