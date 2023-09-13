import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mesa_ayuda/controllers/HomeController.dart';
import 'package:mesa_ayuda/views/auth/login.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mesa_ayuda/helpers/mensajes.dart' as mensajes;

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mesa de Ayuda',
      home: const MyHomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      var hayNuevaVersion =
          await HomeController().hayNuevaVersion() as Map<String, dynamic>;

      if (hayNuevaVersion['estatus']) {
        mensajes.mensajeNuevaVersion(
            context,
            "Versión disponible: " +
                hayNuevaVersion['version'].toString().replaceAll("_", "."),
            "Actualmente se ejecuta la versión ${dotenv.env['APP_VERSION'].toString().replaceAll("_", ".")} le sugerimos descargar la versión más reciente.",
            hayNuevaVersion['version']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Login();
  }
}
