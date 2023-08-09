import 'package:flutter/material.dart';
import 'package:kurabiye/constants/routes.dart';
import 'package:kurabiye/services/auth/auth_service.dart';
import 'package:lottie/lottie.dart';
import '../services/auth/auth_exceptions.dart';
import '../utulities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset(
              'assets/moon.json',
              width: 250, // Genişliği 200 yapabilirsiniz.
              height: 250,
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 300, // Sabit genişlik
                  height: 60,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage('assets/box_back.png'),
                        fit: BoxFit.cover),
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 244, 233, 136),
                        width: 2.0),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person),
                      hintText: "enter your email here",
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Boşluk
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 300, // Sabit genişlik
                height: 60,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('assets/box_back.png'),
                      fit: BoxFit.cover),
                  color: Colors.white,
                  border: Border.all(
                      color: const Color.fromARGB(255, 244, 233, 136),
                      width: 2.0),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.key_rounded),
                    hintText: "enter your password here",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().logIn(
                    email: email,
                    password: password,
                  );
                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (route) => false,
                    );
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (route) => false,
                    );
                  }
                } on WrongPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'Wrong credentials!',
                  );
                } on UserNotFoundAuthException {
                  await showErrorDialog(
                    context,
                    'User not found!',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Authentication error',
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 253, 249, 210),
                // Metin rengi
                //backgroundColor:
                //Color.fromARGB(255, 229, 212, 236), // Buton rengi
                minimumSize: const Size(200, 0), // Buton boyutu
                shape: const StadiumBorder(
                    side: BorderSide(
                        color: Color.fromARGB(255, 253, 249, 210), width: 1)),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.grey, // Metin rengini kırmızı yap
                  //fontSize: 20, // Metin boyutunu 20 yap
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text(
                'Not registered yet? Register here!',
                style: TextStyle(
                  color: Colors.grey, // Metin rengini kırmızı yap
                  //fontSize: 20, // Metin boyutunu 20 yap
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 500),
          ],
        ),
      ),
    );
  }
}
