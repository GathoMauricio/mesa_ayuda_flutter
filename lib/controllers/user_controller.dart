import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mesa_ayuda/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesa_ayuda/helpers/mensajes.dart' as mensajes;

class UserController {
  Future<bool> apiLogin(String email, String password) async {
    var datos = {"email": email, "password": password};
    var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-login', datos);
    var response = await http.post(url);
    //print(response.body);
    if (response.statusCode == 200) {
      //try {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse['estatus'] == 1) {
        //TODO:Confirmar si el usuario está activo
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString("auth_token", jsonResponse['auth_token']);
        localStorage.setString(
            "usuario",
            json.encode({
              'id': jsonResponse['usuario']['id'],
              'rol_id': jsonResponse['usuario']['rol_id'],
              'cliente_id': jsonResponse['usuario']['cliente_id'],
              'estatus': jsonResponse['usuario']['estatus'],
              'nombre': jsonResponse['usuario']['nombre'],
              'apaterno': jsonResponse['usuario']['apaterno'],
              'amaterno': jsonResponse['usuario']['amaterno'],
              'telefono': jsonResponse['usuario']['telefono'],
              'telefono_emergencia': jsonResponse['usuario']
                  ['telefono_emergencia'],
              'email': jsonResponse['usuario']['email'],
              'direccion': jsonResponse['usuario']['direccion'],
              'imagen': jsonResponse['usuario']['imagen'],
            }));
        Usuario u = Usuario.fromJson(
            json.decode(localStorage.getString("usuario") ?? ""));
        print("El usuario " +
            u.nombre +
            " " +
            u.apaterno +
            " inició sesión correctamente...");
        return true;
      } else {
        return false;
      }
      // } catch (e) {
      //   return false;
      // }
    } else {
      print('Request failed with status: ${response.body}.');
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
          localStorage.setString(
              "usuario",
              json.encode({
                'id': jsonResponse['usuario']['id'],
                'rol_id': jsonResponse['usuario']['rol_id'],
                'cliente_id': jsonResponse['usuario']['cliente_id'],
                'estatus': jsonResponse['usuario']['estatus'],
                'nombre': jsonResponse['usuario']['nombre'],
                'apaterno': jsonResponse['usuario']['apaterno'],
                'amaterno': jsonResponse['usuario']['amaterno'],
                'telefono': jsonResponse['usuario']['telefono'],
                'telefono_emergencia': jsonResponse['usuario']
                    ['telefono_emergencia'],
                'email': jsonResponse['usuario']['email'],
                'direccion': jsonResponse['usuario']['direccion'],
                'imagen': jsonResponse['usuario']['imagen'],
              }));
          Usuario u = Usuario.fromJson(
              json.decode(localStorage.getString("usuario") ?? ""));
          print("El usuario " +
              u.nombre +
              " " +
              u.apaterno +
              " inició sesión de nuevo correctamente...");
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

  Future<Usuario> usuarioLogueado() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return Usuario.fromJson(
        json.decode(localStorage.getString("usuario") ?? ""));
  }
}
