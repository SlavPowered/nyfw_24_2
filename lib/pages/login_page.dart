import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyfw_24_2/auth.dart';
import 'package:nyfw_24_2/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = true;
  final Auth auth = Auth();
  String? _errorMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Log In' : 'Sign Up'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                isLogin ? "Login" : "Sign Up",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                _errorMsg!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    isLogin ? await _login() : await _signup();
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      isLogin ? "Login" : "Signup",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => isLogin = !isLogin);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      isLogin ? 'Sign Up' : 'Log In',
                      style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    try {
      await auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Login successful"),
        duration: Duration(seconds: 3),
      ));

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) => MyHomePage(title: 'Main Page')),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() => _errorMsg = "user not found");
      } else if (e.code == 'wrong-password') {
        setState(() => _errorMsg = "wrong password");
      } else {
        setState(() => _errorMsg = e.message);
      }
      _emailController.clear();
      _passwordController.clear();
    }
  }

  Future<void> _signup() async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      setState(() => isLogin = true);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Signup successful"),
        duration: Duration(seconds: 3),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          _errorMsg = "password too weak";
          _passwordController.clear();
          _emailController.clear();
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          _errorMsg = "email already in use";
          _passwordController.clear();
          _emailController.clear();
        });
      } else {
        setState(() => _errorMsg = e.message);
      }
    }
  }
}
