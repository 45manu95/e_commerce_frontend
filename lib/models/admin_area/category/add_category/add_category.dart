import 'package:flutter/material.dart';
import '../../../other/super_components/app_bar.dart';
import 'components/form_add_category.dart';
class AddCategory extends StatelessWidget {
  const AddCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SuperAppBar(area: "none", search: ""),
      body: const Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "\nAggiungi categoria",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 300, child: FormAddCategory()),
          ],
        ),
      )),
    );
  }
}