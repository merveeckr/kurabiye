import 'package:flutter/material.dart';
import 'package:kurabiye/constants/routes.dart';
import 'package:lottie/lottie.dart';
import '../services/auth/auth_exceptions.dart';
import '../services/auth/auth_service.dart';
import '../utulities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset(
              'assets/add.json',
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
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'Weak password!',
                  );
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(
                    context,
                    'Email is already in use!',
                  );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                    context,
                    'This is an invalid email adress!',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Failed to register',
                  );
                }
              },
              child: const Text(
                "Register",
                style: TextStyle(
                  //color: Colors.grey, // Metin rengini kırmızı yap
                  //fontSize: 20, // Metin boyutunu 20 yap
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text(
                  'Already registered. Login here!',
                  style: TextStyle(
                    //color: Colors.grey, // Metin rengini kırmızı yap
                    //fontSize: 20, // Metin boyutunu 20 yap
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(height: 500),
          ],
        ),
      ),
    );
  }
}
