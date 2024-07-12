import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mesa_ayuda/helpers/mensajes.dart' as mensajes;
import 'package:mesa_ayuda/models/ArchivoAdjunto.dart';
import 'package:mesa_ayuda/models/Ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Area.dart';
import '../models/Seguimiento.dart';

class HomeController {
  Future<List<Ticket>> apiHome(List<Area> areas) async {
    String listAreas = "";
    for (var item in areas) {
      listAreas += '${item.id},';
    }
    List<Ticket> lista = [];
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String authToken = localStorage.getString("auth_token").toString();

    var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-obtener-casos-usuario');
    var response = await http.post(
      url,
      body: {'selected_areas': listAreas},
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $authToken',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      try {
        String body = convert.utf8.decode(response.bodyBytes);
        var jsonData = convert.jsonDecode(body);
        for (var ticket in jsonData['datos']) {
          List<Seguimiento> seguimientos = [];
          for (var seguimiento in ticket['seguimientos']) {
            seguimientos.add(Seguimiento(
              seguimiento['id'],
              seguimiento['ticket_id'],
              seguimiento['autor'],
              seguimiento['texto'],
              seguimiento['created_at'],
            ));
          }
          List<ArchivoAdjunto> archivos = [];
          for (var archivo in ticket['archivos']) {
            archivos.add(ArchivoAdjunto(
                archivo['id'],
                archivo['case_id'],
                archivo['author'],
                archivo['name'],
                archivo['route'],
                archivo['mime_type'],
                archivo['created_at']));
          }
          Ticket aux = Ticket(
              ticket['id'],
              ticket['estatus'],
              ticket['area'],
              ticket['categoria'],
              ticket['sintoma'],
              ticket['usuarioFinal'],
              ticket['folio'],
              ticket['prioridad'],
              ticket['descripcion']);
          aux.created_at = ticket['created_at'];
          aux.seguimientos = seguimientos;
          aux.archivos = archivos;
          lista.add(aux);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    } else {
      if (kDebugMode) print("Error de servidor");
    }
    return lista;
  }

  Future<Object> hayNuevaVersion() async {
    var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-ultima-version-android');
    var response = await http.get(url);
    //print(response.body);
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
        if (kDebugMode) print(e);
        return {"estatus": false, "version": null};
      }
    } else {
      return {"estatus": false, "version": null};
    }
  }

  Future<bool> apiSolicitarPassword(context, email) async {
    var url = Uri.http(
        dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-solicitar-password',
        {'email': email});
    var response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      try {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['estatus'] == 1) {
          mensajes.mensajeFlash(context, jsonResponse['mensaje']);
          return true;
        } else {
          mensajes.mensajeFlash(context, jsonResponse['mensaje']);
          return false;
        }
      } catch (e) {
        print(e);
        mensajes.mensajeFlash(context, "Error durante el proceso");
        return false;
      }
    } else {
      mensajes.mensajeFlash(context, "Respuesta erronea del servidor");
      print('Request failed with status: ${response.body}.');
      return false;
    }
  }
}
