import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mesa_ayuda/models/ArchivoAdjunto.dart';
import 'package:mesa_ayuda/models/Ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesa_ayuda/helpers/mensajes.dart' as mensajes;

import '../models/Seguimiento.dart';

class TicketController {
  Future<bool> apiStoreTicket(context, Ticket ticket) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String authToken = localStorage.getString("auth_token").toString();
    var datos =
        ticket.toJson().map((key, value) => MapEntry(key, value.toString()));
    mensajes.mensajeFlash(context, "Validando...");
    var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-guardar-caso', datos);
    var response = await http.post(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $authToken',
      },
    );
    mensajes.quitarMensajeFlash(context);
    //print(response.body);
    if (response.statusCode == 200) {
      try {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        mensajes.mensajeFlash(context, jsonResponse['mensaje']);
        if (jsonResponse['estatus'] == 1) {
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
      mensajes.mensajeFlash(context, "Respuesta erronea del servidor");
      print('Request failed with status: ${response.body}.');
      return false;
    }
  }

  Future<Ticket> apiGetTicket(context, ticketId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String authToken = localStorage.getString("auth_token").toString();
    Ticket ticket = Ticket(0, 'estatus', 'area', 'categoria', 'sintoma',
        'usuarioFinal', 'folio', 'prioridad', 'descripcion');

    var datos = {'caso_id': ticketId.toString()};
    var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-obtener-info-caso', datos);
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
        String body = convert.utf8.decode(response.bodyBytes);
        var jsonData = convert.jsonDecode(body);
        //var datos = jsonData['datos'];
        //print(jsonData);
        List<Seguimiento> seguimientos = [];
        for (var seguimiento in jsonData['seguimientos']) {
          seguimientos.add(Seguimiento(
            seguimiento['id'],
            seguimiento['ticket_id'],
            seguimiento['autor'],
            seguimiento['texto'],
            seguimiento['created_at'],
          ));
        }
        List<ArchivoAdjunto> archivos = [];
        for (var archivo in jsonData['archivos']) {
          archivos.add(ArchivoAdjunto(
              archivo['id'],
              archivo['case_id'],
              archivo['author'],
              archivo['name'],
              archivo['route'],
              archivo['mime_type'],
              archivo['created_at']));
        }

        ticket = Ticket(
            jsonData['id'],
            jsonData['estatus'],
            jsonData['area'],
            jsonData['categoria'],
            jsonData['sintoma'],
            jsonData['usuarioFinal'],
            jsonData['folio'],
            jsonData['prioridad'],
            jsonData['descripcion']);
        ticket.seguimientos = seguimientos;
        ticket.archivos = archivos;
        mensajes.mensajeFlash(context, "Información actualizada");
        return ticket;
      } catch (e) {
        if (kDebugMode) print(e);
        mensajes.mensajeFlash(context, "Error durante el proceso");
      }
    } else {
      print('Request failed with status: ${response.body}.');
    }
    return ticket;
  }

  Future<bool> apiactualizarEstatusTicket(context, ticketId, estatus) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String authToken = localStorage.getString("auth_token").toString();
    mensajes.mensajeFlash(context, "Enviando...");
    var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-actualizar-estatus-ticket');
    var response = await http.post(
      url,
      body: {
        'case_id': ticketId.toString(),
        'estatus': estatus,
      },
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $authToken',
      },
    );
    mensajes.quitarMensajeFlash(context);
    print(response.body);
    if (response.statusCode == 200) {
      try {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        mensajes.mensajeFlash(context, jsonResponse['mensaje']);
        if (jsonResponse['estatus'] == 1) {
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
      mensajes.mensajeFlash(context, "Respuesta erronea del servidor");
      print('Request failed with status: ${response.body}.');
      return false;
    }
  }
}
