import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';

class DescargarVersion extends StatefulWidget {
  String nuevaVersion;
  DescargarVersion({super.key, required this.nuevaVersion});

  @override
  State<DescargarVersion> createState() => _DescargarVersionState();
}

class _DescargarVersionState extends State<DescargarVersion> {
  // final url =
  //     "http://dotenv.env['SERVER_URL'].toString()/${dotenv.env['PROJECT_PATH']}api-ultima-version-android";
  final url =
      "http://${dotenv.env['SERVER_URL']}${dotenv.env['PROJECT_PATH']}api-descargar-android-app";
  bool descargado = false;
  var progreso = "Presiona para iniciar la descarga";
  var ruta = "Sin ruta";
  @override
  void initState() {
    getPermission();
    super.initState();
  }

  //get storage permission
  void getPermission() async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    await Permission.unknown.request();
    await Permission.requestInstallPackages.request();
  }

  Future<void> descargarArchivo() async {
    Dio dio = Dio();
    try {
      var dir = await getExternalStorageDirectory();
      ruta = "${dir?.path}/mesa_ayuda_" + widget.nuevaVersion + ".apk";

      await dio.download(url, ruta, onReceiveProgress: (rec, total) {
        setState(() {
          progreso =
              "Descargando " + ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      if (kDebugMode) print(e);
    }

    setState(() {
      descargado = true;
      progreso = "Descarga completa";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // color: Colors.red.withOpacity(0.1),
          image: DecorationImage(
              image: AssetImage('assets/restaurant_wallpaper.jpg'),
              fit: BoxFit.cover,
              opacity: 1),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_ppj.png',
              height: 180,
              width: 180,
            ),
            Text(
              "Mesa de Ayuda",
              style: GoogleFonts.indieFlower(
                textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text("Versión " + widget.nuevaVersion,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0)),
            SizedBox(
              height: 20.0,
            ),
            MaterialButton(
              onPressed: () {
                descargarArchivo();
              },
              color: Colors.lightBlue,
              textColor: Colors.white,
              child: Icon(
                Icons.download,
                size: 200,
              ),
              padding: EdgeInsets.all(20),
              shape: CircleBorder(),
            ),
            SizedBox(
              height: 20,
            ),
            Text(progreso,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0)),
            SizedBox(
              height: 20,
            ),
            _descargaCompleta()
          ],
        )),
      ),
    );
  }

  Widget _descargaCompleta() {
    if (descargado) {
      return ElevatedButton(
        onPressed: () async {
          if (await File(ruta).exists()) {
            OpenFile.open(ruta);
          } else {
            print("No se encontró la ruta");
          }
        },
        child: Text(
          "Ejecutar instalador",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
