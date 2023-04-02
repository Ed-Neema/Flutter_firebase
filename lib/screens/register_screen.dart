import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:freelancer_firebase/screens/home_page.dart';
import 'package:freelancer_firebase/screens/login_screen.dart';
import '../services/auth_service.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmController = TextEditingController();
  // showing loading indicator
  bool loading = false;
  bool googleLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Register"),
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
              TextField(
                obscureText: true,
                controller: confirmController,
                decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 30,
              ),
              loading
                  ? CircularProgressIndicator()
                  : Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.redAccent),
                          onPressed: () async {
                            // setting laoding is true after pressing
                            setState(() {
                              loading = true;
                            });
                            if (emailController.text == "" ||
                                passwordController.text == "") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("All fields are required"),
                                backgroundColor: Colors.redAccent,
                              ));
                            } else if (passwordController.text !=
                                confirmController.text) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Passwords don't match"),
                                backgroundColor: Colors.redAccent,
                              ));
                            } else {
                              User? result = await AuthService().register(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  context);
                              if (result != null) {
                                print("Success");
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(user: result)),
                                    (route) => false);
                              }
                            }

                            // after all is done, set to false
                            setState(() {
                              loading = false;
                            });
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          )),
                    ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text("Already have an account? Login",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent))),
              SizedBox(
                height: 20,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              googleLoading
                  ? CircularProgressIndicator()
                  : SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        setState(() {
                          googleLoading = true;
                        });
                        User? result = await AuthService().signInWithGoogle(context);
                        setState(() {
                          googleLoading = false;
                        });
                        if (result != null) {
                          print("Success");
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(user: result)),
                              (route) => false);
                        }
                      },
                      text: "Continue with Google",
                    )
            ],
          ),
        ),
      ),
    );
  }
}
