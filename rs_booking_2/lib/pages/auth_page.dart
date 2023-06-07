// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rs_booking_2/pages/home_page.dart';
import 'package:rs_booking_2/pages/studio_page.dart';
import 'package:rs_booking_2/services/models.dart';
import 'package:rs_booking_2/services/snack_bar.dart';

@RoutePage<void>()
class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({Key? key}) : super(key: key);

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showLogin = true;
  final usersRef = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    isUser;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _registerUser(
        String name, String email, String password) async {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        updateState() {
          isUser;
        }

        // Создаем новый документ в коллекции 'users'
        final newUserRef = usersRef.doc(userCredential.user!.uid);

        // Устанавливаем данные пользователя в этом документе
        await newUserRef.set({
          'name': name,
          'email': email,
          'password': password,
          'id': newUserRef.id, // присваиваем полю 'id' значение id документа
        });

        //print("Пользователь успешно добавлен в коллекцию 'users'!");
      } catch (e) {
        //print("Ошибка при добавлении пользователя в коллекцию 'users': $e");
      }
    }

    Widget _registerButton() {
      return ElevatedButton(
        onPressed: () {
          try {
            _registerUser(
                _nameController.value.toString(),
                _emailController.value.toString(),
                _passwordController.value.toString());
          } on FirebaseAuthException catch (e) {
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
          setState(
            () {
              isUser;
            },
          );
          if (isUser != null) {
            Navigator.of(context).pushNamed('HomePage');
          }
          //print(isUser);
        },
        child: const Text(
          'Регистрация',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
    }

    Future<void> _loginUser() async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        updateState() {
          isUser;
        }
      } on FirebaseAuthException catch (e) {
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
    }

    Widget _loginButton() {
      return ElevatedButton(
        child: const Text(
          'Авторизация',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          try {
            _loginUser();
          } on FirebaseAuthException catch (e) {
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
          setState(
            () {
              isUser;
            },
          );
          if (isUser != null) {
            Navigator.of(context).pushNamed('HomePage');
          }
          //print(isUser);
        },
      );
    }

    Widget _registerForm() {
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
            child: _registerButton(),
          ),
        ),
      ]);
    }

    Widget _loginForm() {
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
            child: _loginButton(),
          ),
        ),
      ]);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(50, 65, 85, 1),
      body: Column(
        children: <Widget>[
          _logo(),
          const SizedBox(
            height: 100,
          ),
          (showLogin
              ? Column(
                  children: <Widget>[
                    _loginForm(),
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
                            isUser;
                          });
                          if (isUser != null) {
                            Navigator.of(context).pushNamed('HomePage');
                          }
                        },
                      ),
                    ),
                  ],
                )
              : Column(
                  children: <Widget>[
                    _registerForm(),
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
                            isUser;
                          });
                          if (isUser != null) {
                            Navigator.of(context).pushNamed('HomePage');
                          }
                        },
                      ),
                    ),
                  ],
                )),
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              child: const Text(
                'Войти как сотрудник студии',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () => Navigator.of(context).pushNamed('StudioAuthPage'),
            ),
          ),
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

//базовый виджет инпута для ввода
Widget _input(
    Icon icon, String hint, TextEditingController controller, bool obscure) {
  return Container(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontSize: 20, color: Colors.white),
      decoration: InputDecoration(
        hintStyle: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white30),
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

class StudioAuthorizationPage extends StatefulWidget {
  const StudioAuthorizationPage({Key? key}) : super(key: key);

  @override
  State<StudioAuthorizationPage> createState() =>
      _StudioAuthorizationPageState();
}

class _StudioAuthorizationPageState extends State<StudioAuthorizationPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _loginController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    Widget _studioLoginForm() {
      return Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 10),
          child:
              _input(const Icon(Icons.email), "Логин", _loginController, false),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 10),
          child: _input(
              const Icon(Icons.lock), "Пароль", _passwordController, true),
        ),
      ]);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(50, 65, 85, 1),
      body: Column(
        children: <Widget>[
          _logo(),
          const SizedBox(
            height: 100,
          ),
          StreamBuilder(
            stream: getStudios(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    _studioLoginForm(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          child: const Text(
                            'Авторизация',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            for (int i = 0;
                                i < snapshot.data!.docs.length;
                                i++) {
                              if (snapshot.data!.docs[i].get('login') ==
                                      _loginController.text &&
                                  snapshot.data!.docs[i].get('password') ==
                                      _passwordController.text) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudioPage(
                                        token: snapshot.data!.docs[i]
                                            .get('login')),
                                  ),
                                );
                                SnackBarService.showSnackBar(
                                    context, 'Данные введены верно', false);
                                break;
                              } else {
                                SnackBarService.showSnackBar(
                                    context, 'Неверные данные', true);
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              child: const Text(
                'Войти как пользователь',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () => Navigator.of(context).pushNamed('/'),
            ),
          ),
          _bottomWave(),
        ],
      ),
    );
  }
}
