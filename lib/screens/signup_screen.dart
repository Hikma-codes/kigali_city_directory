import 'package:flutter/material.dart';
<<<<<<< HEAD

class SignupScreen extends StatelessWidget {
  final email = TextEditingController();
  final password = TextEditingController();
=======
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final AuthService _auth = AuthService();
  bool _loading = false;
>>>>>>> e18d788 (addition of files)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(title: Text("Create Account")),

      body: Padding(
        padding: EdgeInsets.all(20),

=======
      appBar: AppBar(title: const Text("Create Account")),
      body: Padding(
        padding: const EdgeInsets.all(20),
>>>>>>> e18d788 (addition of files)
        child: Column(
          children: [
            TextField(
              controller: email,
<<<<<<< HEAD
              decoration: InputDecoration(
=======
              decoration: const InputDecoration(
>>>>>>> e18d788 (addition of files)
                labelText: "Email",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
<<<<<<< HEAD

            SizedBox(height: 15),

            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
=======
            const SizedBox(height: 15),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
>>>>>>> e18d788 (addition of files)
                labelText: "Password",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
<<<<<<< HEAD

            SizedBox(height: 20),

            ElevatedButton(
              child: Text("Sign Up"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
=======
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    child: const Text("Sign Up"),
                    onPressed: () async {
                      setState(() => _loading = true);
                      final user = await _auth.signUp(
                        email.text.trim(),
                        password.text.trim(),
                      );
                      setState(() => _loading = false);
                      if (user != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Account created. Please check your email to verify.",
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Sign up failed")),
                        );
                      }
                    },
                  ),
>>>>>>> e18d788 (addition of files)
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
>>>>>>> e18d788 (addition of files)
}
