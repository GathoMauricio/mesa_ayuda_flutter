import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<Map> _messageStream = StreamController.broadcast();
  static Stream<Map> get messageStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    //Las app está en segundo plano
    print("onBackgrounHandler ${message.messageId}");
    _messageStream.add(message.data);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    //La app está abierta
    print("onMessageHandler ${message.messageId}");
    _messageStream.add(message.data);
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    //La app está completamente cerrada
    print("onMessageOpenApp ${message.messageId}");
    _messageStream.add(message.data);
  }

  static Future initializeApp() async {
    //Push notifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');
    //Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    //Local notifications
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (localStorage.containsKey('auth_token')) {
      try {
        String authToken = localStorage.getString("auth_token").toString();
        var url = Uri.http(dotenv.env['SERVER_URL'].toString(),
            '${dotenv.env['PROJECT_PATH']}api-actualizar-fcm');
        var response = await http.post(
          url,
          body: {'fcm_token': token},
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $authToken',
          },
        );
        print(response.body);
      } catch (e) {
        print(e);
      }
    }
    //Actualizar fcmToken
  }

  static closeStreams() {
    _messageStream.close();
  }
}
