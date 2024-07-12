import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mesa_ayuda/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mesa_ayuda/helpers/mensajes.dart' as mensajes;

import '../../controllers/HomeController.dart';
import '../../controllers/UserController.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userController = UserController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool hayToken = false;
  String _emailSolicitud = '';

  @override
  void initState() {
    super.initState();
    _comprobarToken();
  }

  void _comprobarToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (localStorage.containsKey('auth_token')) {
      if (await userController.apiDatosUsuario()) {
        setState(() {
          hayToken = true;
        });
      } else {
        mensajes.mensajeFlash(
            context, "Token inváido, favor de iniciar sesión de nuevo.");
      }
    }
  }

  bool isEmailCorrect = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // _email.text = "contacto@mail.com";
    // _password.text = "Contacto2021";
    // _email.text = "mauricio2769@gmail.com";
    // _password.text = "12345678";
    return hayToken
        ? Home()
        : Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/restaurant_wallpaper.jpg'),
                    fit: BoxFit.cover,
                    opacity: 1),
              ),
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                              ),
                              color: Color.fromRGBO(7, 121, 84, 1)),
                        ),
                        Text(
                          'Por favor ingrese sus datos para continuar',
                          style: GoogleFonts.indieFlower(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                // height: 1.5,
                                fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: isEmailCorrect ? 280 : 200,
                          // _formKey!.currentState!.validate() ? 200 : 600,
                          // height: isEmailCorrect ? 260 : 182,
                          width: MediaQuery.of(context).size.width / 1.1,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10, top: 10),
                                child: TextFormField(
                                  controller: _email,
                                  // onChanged: (val) {
                                  //   setState(() {
                                  //     isEmailCorrect = isEmail(val);
                                  //   });
                                  // },
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    prefixIcon: Icon(Icons.person,
                                        color: Color.fromRGBO(7, 121, 84, 1)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: "Email",
                                    hintText: 'tu_email@dominio.com',
                                    labelStyle: TextStyle(
                                        color: Color.fromRGBO(7, 121, 84, 1)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: _password,
                                    obscuringCharacter: '*',
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.key,
                                        color: Color.fromRGBO(7, 121, 84, 1),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Password",
                                      hintText: '*********',
                                      labelStyle: TextStyle(
                                          color: Color.fromRGBO(7, 121, 84, 1)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Ingrese sus datos de acceso';
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              isEmailCorrect
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          backgroundColor: isEmailCorrect ==
                                                  false
                                              ? Colors.red
                                              : Color.fromRGBO(7, 121, 84, 1),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 131, vertical: 20)
                                          // padding: EdgeInsets.only(
                                          //     left: 120, right: 120, top: 20, bottom: 20),
                                          ),
                                      onPressed: () async {
                                        if (_email.text.isNotEmpty &&
                                            _password.text.isNotEmpty) {
                                          Future<bool> acceso =
                                              userController.apiLogin(context,
                                                  _email.text, _password.text);
                                          if (await acceso) {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Home()),
                                                    (route) => false);
                                          }
                                        } else {
                                          mensajes.mensajeFlash(context,
                                              "Todos los campos son obligatorios.");
                                        }
                                      },
                                      child: const Text(
                                        'Entrar',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ))
                                  : Container(),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿Olvidó su contraseña?',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _enviarSolicitudPassword(context);
                              },
                              child: const Text(
                                'Recuperar contraseña',
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                var hayNuevaVersion = await HomeController()
                                    .hayNuevaVersion() as Map<String, dynamic>;

                                if (hayNuevaVersion['estatus']) {
                                  mensajes.mensajeNuevaVersion(
                                      context,
                                      "Versión disponible: " +
                                          hayNuevaVersion['version']
                                              .toString()
                                              .replaceAll("_", "."),
                                      "Actualmente se ejecuta la versión ${dotenv.env['APP_VERSION'].toString().replaceAll("_", ".")} le sugerimos descargar la versión más reciente.",
                                      hayNuevaVersion['version']);
                                } else {
                                  mensajes.mensajeNuevaVersion(
                                      context,
                                      "Última versión: " +
                                          hayNuevaVersion['version']
                                              .toString()
                                              .replaceAll("_", "."),
                                      "Actualmente se ejecuta la versión ${dotenv.env['APP_VERSION'].toString().replaceAll("_", ".")} \n¿Desea dergargarla de todas formas?.",
                                      hayNuevaVersion['version']);
                                }
                              },
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: const Icon(
                                Icons.downloading,
                                size: 30,
                              ),
                              padding: EdgeInsets.all(16),
                              shape: CircleBorder(),
                            ),
                            Text(
                                "Versión actual. ${dotenv.env['APP_VERSION'].toString().replaceAll("_", ".")}",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Future _enviarSolicitudPassword(context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Solicitar password',
              style: TextStyle(
                  color: Color.fromRGBO(7, 121, 84, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      filled: true,
                      fillColor: Color.fromARGB(240, 230, 221, 221),
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(7, 121, 84, 1)),
                      labelText: 'Escriba su email aquí:',
                    ),
                    onChanged: (value) {
                      _emailSolicitud = value;
                    },
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Enviar',
                  style: TextStyle(
                      color: Color.fromRGBO(7, 121, 84, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ),
                onPressed: () async {
                  if (_emailSolicitud.isEmpty) {
                    mensajes.mensajeFlash(context, "Ingrese su email...");
                  } else {
                    if (await HomeController()
                        .apiSolicitarPassword(context, _emailSolicitud)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          );
        });
  }
}
