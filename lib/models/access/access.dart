import 'package:flutter/material.dart';

import 'components/form_access.dart';

class Access extends StatelessWidget {
  const Access({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "LOGIN\n",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text("Accedi per confermare la tua identità\n"),
          Container(
              width: 300,
              margin: const EdgeInsets.only(right: 35),
              child: const FormAccess()),
        ],
      )),
    );
  }
}