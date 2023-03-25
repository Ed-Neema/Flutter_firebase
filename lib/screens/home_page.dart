import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
          TextButton.icon(
            onPressed: () async {
              try {
                await AuthService().signout(context);
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("${error.toString()}"),
                  backgroundColor: Colors.redAccent,
                ));
              }
            },
            icon: Icon(Icons.logout),
            label: Text("Sign out"),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          )
        ],
      ),
    );
  }
}
