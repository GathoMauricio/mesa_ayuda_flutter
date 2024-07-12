import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mesa_ayuda/models/Usuario.dart';
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
    //print(response.body);
    if (response.statusCode == 200) {
      try {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['estatus'] == 1) {
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.setString("auth_token", jsonResponse['auth_token']);
          guardarUsuarioLogeado(jsonResponse['usuario']);
          mensajes.mensajeFlash(
              context, "Bienvenid@ " + jsonResponse['usuario']['name']);
          return true;
        } else {
          mensajes.mensajeFlash(context, jsonResponse['mensaje']);
          return false;
        }
      } catch (e) {
        if (kDebugMode) print(e);
        mensajes.mensajeFlash(context, "Error durante el proceso");
        return false;
      }
    } else {
      mensajes.mensajeFlash(
          context, "No se pudo establecer conexión con el servidor");
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
    // print(response.body);
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
        if (kDebugMode) print(e);
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
        if (kDebugMode) print(e);
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
            'rol_id': usuario['user_rol_id'],
            'cliente_id': usuario['company_branch_id'],
            'estatus': usuario['status'],
            'nombre': usuario['name'],
            'apaterno': usuario['middle_name'],
            'amaterno': usuario['last_name'],
            'telefono': usuario['phone'],
            'telefono_emergencia': usuario['emergency_phone'],
            'email': usuario['email'],
            'direccion': usuario['address'],
            'imagen': usuario['image'],
          }));
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<Usuario> usuarioLogueado() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //print(localStorage.getString("usuario"));
    return Usuario.fromJson(
        json.decode(localStorage.getString("usuario") ?? ""));
  }

  String getRolName(id) {
    switch (id) {
      case 1:
        return "Administrador";
        break;
      case 2:
        return "Soporte técnico";
        break;
      case 3:
        return "Contacto";
        break;
      case 4:
        return "SuperAdmin";
        break;
      default:
        return "Undefined";
    }
  }

  getUserImage(imagen) {
    if (imagen == 'perfil.png') {
      return AssetImage('assets/perfil.jpg');
    } else {
      return NetworkImage(
          'http://${dotenv.env['SERVER_URL']}${dotenv.env['USER_IMAGES_PATH']}$imagen');
    }
  }

  Future<bool> apiActualizarPassword(
      context, currentPassword, newPassword) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String authToken = localStorage.getString("auth_token").toString();
    var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-actualizar-password');
    var response = await http.post(
      url,
      body: {'current_password': currentPassword, 'new_password': newPassword},
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $authToken',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonResponse;
        String body = utf8.decode(response.bodyBytes);
        jsonResponse = convert.jsonDecode(body) as Map<String, dynamic>;
        if (jsonResponse['estatus'] == 1) {
          mensajes.mensajeFlash(context, jsonResponse['mensaje']);
          return true;
        } else {
          mensajes.mensajeFlash(context, jsonResponse['mensaje']);
          return false;
        }
      } catch (e) {
        if (kDebugMode) print(e);
        return false;
      }
    } else {
      return false;
    }
  }
}
