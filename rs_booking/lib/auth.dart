// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rs_booking/services/models.dart';
import 'package:rs_booking/services/snack_bar.dart';

class Authorization extends StatefulWidget {
  const Authorization({Key? key}) : super(key: key);

  @override
  State<Authorization> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late int _id;
  late String _email;
  late String _name;
  late String _password;
  bool showLogin = true;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Widget _logo() {
      return const Padding(
        padding: EdgeInsets.only(top: 100),
        child: Align(
          child: Text(
            'RS-booking',
            style: TextStyle(
                fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      );
    }

    Widget _input(Icon icon, String hint, TextEditingController controller,
        bool obscure) {
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
            hintStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white30),
            hintText: hint,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 3),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white54, width: 1),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: IconTheme(
                data: const IconThemeData(color: Colors.white),
                child: icon,
              ),
            ),
          ),
        ),
      );
    }

    Future createUser(thisUser user) async {
      final DocumentReference docUser =
          FirebaseFirestore.instance.collection('users').doc(isUser);

      final json = user.toJson();

      docUser.set(json);
    }

    Widget _registerButton(String text, void Function() func) {
      return ElevatedButton(
        onPressed: () {
          final user = thisUser(
            email: _email,
            password: _password,
            name: _name,
            id: _id,
          );
          createUser(user);

          final navigator = Navigator.of(context);

          //final isValid = formKey.currentState!.validate();
          //if (!isValid) return;

          try {
            FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
          } on FirebaseAuthException catch (e) {
            //print(e.code);

            if (e.code == 'user-not-found' || e.code == 'wrong-password') {
              SnackBarService.showSnackBar(
                context,
                'Неправильный email или пароль. Повторите попытку',
                true,
              );
              return;
            } else {
              SnackBarService.showSnackBar(
                context,
                'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
                true,
              );
              return;
            }
          }
          navigator.pushNamedAndRemoveUntil(
              '/', (Route<dynamic> route) => false);
        },
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).primaryColor),
        ),
      );
    }

    Widget _loginButton(String text, void Function() func) {
      return ElevatedButton(
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).primaryColor),
        ),
        onPressed: () {
          final navigator = Navigator.of(context);

          //final isValid = formKey.currentState!.validate();
          //if (!isValid) return;

          try {
            FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
          } on FirebaseAuthException catch (e) {
            //print(e.code);

            if (e.code == 'user-not-found' || e.code == 'wrong-password') {
              SnackBarService.showSnackBar(
                context,
                'Неправильный email или пароль. Повторите попытку',
                true,
              );
              return;
            } else {
              SnackBarService.showSnackBar(
                context,
                'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
                true,
              );
              return;
            }
          }

          navigator.pushNamedAndRemoveUntil(
              '/', (Route<dynamic> route) => false);
        },
      );
    }

    Widget _registerForm(String label, void Function() func) {
      return Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 10),
          child:
              _input(const Icon(Icons.email), "Email", _emailController, false),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 10),
          child: _input(const Icon(Icons.man), "Имя", _nameController, false),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 10),
          child: _input(
              const Icon(Icons.lock), "Пароль", _passwordController, true),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: _registerButton(label, func),
          ),
        ),
      ]);
    }

    Widget _loginForm(String label, void Function() func) {
      return Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 10),
          child:
              _input(const Icon(Icons.email), "Email", _emailController, false),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 10),
          child: _input(
              const Icon(Icons.lock), "Пароль", _passwordController, true),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: _loginButton(label, func),
          ),
        ),
      ]);
    }

    @override
    void dispose() {
      _emailController.dispose();
      _passwordController.dispose();

      super.dispose();
    }

    Future<void> _loginUser() async {
      final navigator = Navigator.of(context);

      //final isValid = formKey.currentState!.validate();
      //if (!isValid) return;

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } on FirebaseAuthException catch (e) {
        //print(e.code);

        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          SnackBarService.showSnackBar(
            context,
            'Неправильный email или пароль. Повторите попытку',
            true,
          );
          return;
        } else {
          SnackBarService.showSnackBar(
            context,
            'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
            true,
          );
          return;
        }
      }

      navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }

    Future<void> _registerUser() async {
      final navigator = Navigator.of(context);

      //final isValid = formKey.currentState!.validate();
      //if (!isValid) return;

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        //print(e.code);

        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          SnackBarService.showSnackBar(
            context,
            'Неправильный email или пароль. Повторите попытку',
            true,
          );
          return;
        } else {
          SnackBarService.showSnackBar(
            context,
            'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
            true,
          );
          return;
        }
      }

      navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }

    Widget _bottomWave() {
      return Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
              color: Colors.white,
              height: 300,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          _logo(),
          const SizedBox(
            height: 100,
          ),
          (showLogin
              ? Column(
                  children: <Widget>[
                    _loginForm('Войти', _loginUser),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        child: const Text(
                            'Ещё не зарегистрированы? Сделайте это сейчас!',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        onTap: () {
                          setState(() {
                            showLogin = false;
                          });
                        },
                      ),
                    ),
                  ],
                )
              : Column(
                  children: <Widget>[
                    _registerForm('Регистрация', _registerUser),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        child: const Text(
                            'Уже зарегистрированы? Просто войдите!',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        onTap: () {
                          setState(() {
                            showLogin = true;
                          });
                        },
                      ),
                    ),
                  ],
                )),
          _bottomWave(),
        ],
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height + 5);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
