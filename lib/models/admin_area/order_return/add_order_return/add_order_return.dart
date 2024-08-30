import 'package:flutter/material.dart';
import '../../../other/super_components/app_bar.dart';
import 'components/form_add_order_return.dart';

// ignore: must_be_immutable
class AddReso extends StatelessWidget {
  AddReso({required this.numeroOrdine, required this.cfCliente, super.key});

  int numeroOrdine;
  String cfCliente;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SuperAppBar(area: "none", search: ""),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "\nAggiungi motivazione reso",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
                width: 300,
                child: FormAddReso(
                  numeroOrdine: numeroOrdine,
                  cfCliente: cfCliente,
                )),
          ],
        ),
      )),
    );
  }
}