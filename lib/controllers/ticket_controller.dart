import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mesa_ayuda/models/ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<Ticket> showTicket(ticket_id) async {
//   SharedPreferences localStorage = await SharedPreferences.getInstance();
//   String authToken = localStorage.getString("auth_token").toString();

//   Ticket ticket = new Ticket();

//   return ticket;
// }
