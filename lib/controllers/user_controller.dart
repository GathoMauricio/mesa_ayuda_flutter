import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mesa_ayuda/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesa_ayuda/helpers/mensajes.dart' as mensajes;

class UserController {
  Future<bool> apiLogin(context, String email, String password) async {
    var datos = {"email": email, "password": password};
    mensajes.mensajeFlash(context, "Validando...");
    var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-login', datos);
    var response = await http.post(url);
    mensajes.quitarMensajeFlash(context);
    print(response.body);
    if (response.statusCode == 200) {
      try {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['estatus'] == 1) {
          //TODO:Confirmar si el usuario está activo

          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.setString("auth_token", jsonResponse['auth_token']);
          guardarUsuarioLogeado(jsonResponse['usuario']);
          mensajes.mensajeFlash(
              context, "Bienvenid@ " + jsonResponse['usuario']['nombre']);
          return true;
        } else {
          mensajes.mensajeFlash(context, jsonResponse['mensaje']);
          return false;
        }
      } catch (e) {
        mensajes.mensajeFlash(context, "Error durante el proceso");
        return false;
      }
    } else {
      mensajes.mensajeFlash(context, "Respuesta erronea del servidor");
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

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonResponse;
        String body = utf8.decode(response.bodyBytes);
        jsonResponse = convert.jsonDecode(body) as Map<String, dynamic>;
        if (jsonResponse['estatus'] == 1) {
          guardarUsuarioLogeado(jsonResponse['usuario']);
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

  void guardarUsuarioLogeado(usuario) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    try {
      localStorage.setString(
          "usuario",
          json.encode({
            'id': usuario['id'],
            'rol_id': usuario['rol_id'],
            'cliente_id': usuario['cliente_id'],
            'estatus': usuario['estatus'],
            'nombre': usuario['nombre'],
            'apaterno': usuario['apaterno'],
            'amaterno': usuario['amaterno'],
            'telefono': usuario['telefono'],
            'telefono_emergencia': usuario['telefono_emergencia'],
            'email': usuario['email'],
            'direccion': usuario['direccion'],
            'imagen': usuario['imagen'],
          }));
      //print("Usuario guardado");
    } catch (e) {
      print(e);
    }
  }

  Future<Usuario> usuarioLogueado() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return Usuario.fromJson(
        json.decode(localStorage.getString("usuario") ?? ""));
  }
}
