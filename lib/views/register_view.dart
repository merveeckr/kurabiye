import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../firebase_options.dart';

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
                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform(),
                );
                final email = _email.text;
                final password = _password.text;
                try {
                  final UserCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                  print(UserCredential);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('Weak-password');
                  } else if (e.code == 'email-already-in-use') {
                    print('Email-already-in-use');
                  }
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
                      .pushNamedAndRemoveUntil('/login/', (route) => false);
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
