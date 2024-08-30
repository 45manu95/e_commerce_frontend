import 'package:flutter/material.dart';
import '../../other/super_components/app_bar.dart';
import 'components/form_add_product.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SuperAppBar(
        area: "none",
        search: "",
      ),
      body: const Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "\nAggiungi prodotto",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 300, child: FormAddProduct()),
          ],
        ),
      )),
    );
  }
}