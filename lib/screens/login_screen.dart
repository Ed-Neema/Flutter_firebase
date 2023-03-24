import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer_firebase/screens/register_screen.dart';

import '../services/auth_service.dart';
import 'home_page.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.redAccent),
                    onPressed: () async {
                      if (emailController.text == "" ||
                          passwordController.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("All fields are required"),
                          backgroundColor: Colors.redAccent,
                        ));
                      } else {
                        try {
                          User? result = await AuthService().login(
                              emailController.text.trim(),
                              passwordController.text.trim());
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(" Log in Successful"),
                            backgroundColor: Colors.greenAccent,
                          ));
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("${error.toString()}"),
                            backgroundColor: Colors.redAccent,
                          ));
                        }
                      }
                    },
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()));
                  },
                  child: Text("Don't have an account? Sign Up",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent)))
            ],
          ),
        ),
      ),
    );
  }
}
