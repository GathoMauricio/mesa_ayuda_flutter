import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mesa_ayuda/models/Ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesa_ayuda/helpers/mensajes.dart' as mensajes;

class TicketController {
  Future<bool> apiStoreTicket(context, Ticket ticket) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String authToken = localStorage.getString("auth_token").toString();
    var datos =
        ticket.toJson().map((key, value) => MapEntry(key, value.toString()));
    mensajes.mensajeFlash(context, "Validando...");
    var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
        '${dotenv.env['PROJECT_PATH']}api-store-ticket', datos);
    var response = await http.post(
      url,
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



// Future<Ticket> showTicket(ticket_id) async {
//   SharedPreferences localStorage = await SharedPreferences.getInstance();
//   String authToken = localStorage.getString("auth_token").toString();

//   Ticket ticket = new Ticket();

//   return ticket;
// }
