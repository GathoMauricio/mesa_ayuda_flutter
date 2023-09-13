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
    _email.text = "test@mail.com";
    _password.text = "12345678";
    return hayToken
        ? Home()
        : Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                  // color: Colors.red.withOpacity(0.1),
                  image: DecorationImage(
                      image: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShp2T_UoR8vXNZXfMhtxXPFvmDWmkUbVv3A40TYjcunag0pHFS_NMblOClDVvKLox4Atw&usqp=CAU',
                        //'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSx7IBkCtYd6ulSfLfDL-aSF3rv6UfmWYxbSE823q36sPiQNVFFLatTFdGeUSnmJ4tUzlo&usqp=CAU'
                      ),
                      fit: BoxFit.cover,
                      opacity: 0.3)),
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.network(
                            'https://assets6.lottiefiles.com/private_files/lf30_ulp9xiqw.json', //shakeing lock
                            //'https://assets6.lottiefiles.com/packages/lf20_k9wsvzgd.json',
                            animate: true,
                            height: 120,
                            width: 600),
                        // logo here
                        // Image.asset(
                        //   'assets/images/logo_new.png',
                        //   height: 120,
                        //   width: 120,
                        // ),
                        Text(
                          "Mesa de Ayuda",
                          style: GoogleFonts.indieFlower(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),
                        ),
                        Text(
                          'Por favor ingresa tus datos para continuar',
                          style: GoogleFonts.indieFlower(
                            textStyle: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                                // height: 1.5,
                                fontSize: 15),
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
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: "Email",
                                    hintText: 'tu_email@dominio.com',
                                    labelStyle: TextStyle(color: Colors.blue),
                                    // suffixIcon: IconButton(
                                    //     onPressed: () {},
                                    //     icon: Icon(Icons.close,
                                    //         color: Colors.blue))
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
                                        color: Colors.blue,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Password",
                                      hintText: '*********',
                                      labelStyle: TextStyle(color: Colors.blue),
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
                                          backgroundColor:
                                              isEmailCorrect == false
                                                  ? Colors.red
                                                  : Colors.blue,
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

                        //this is button
                        // const SizedBox(
                        //   height: 30,
                        // ),
                        // ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(10.0)),
                        //         backgroundColor: Colors.blue,
                        //         padding: EdgeInsets.symmetric(
                        //             horizontal: MediaQuery.of(context).size.width / 3.3,
                        //             vertical: 20)
                        //         // padding: EdgeInsets.only(
                        //         //     left: 120, right: 120, top: 20, bottom: 20),
                        //         ),
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => loginScreen()));
                        //     },
                        //     child: Text(
                        //       'Sounds Good!',
                        //       style: TextStyle(fontSize: 17),
                        //     )), //
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
                              onPressed: () {},
                              child: const Text(
                                'Recuperar contraseña',
                                style: TextStyle(
                                    color: Colors.blue,
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
                              color: Colors.green,
                              textColor: Colors.white,
                              child: const Icon(
                                Icons.downloading,
                                size: 30,
                              ),
                              padding: EdgeInsets.all(16),
                              shape: CircleBorder(),
                            ),
                            Text(
                                "v. ${dotenv.env['APP_VERSION'].toString().replaceAll("_", ".")}",
                                style: TextStyle(
                                  color: Colors.purple,
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
}
