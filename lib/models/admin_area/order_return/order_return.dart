import 'package:flutter/material.dart';

import '../../other/super_components/app_bar.dart';
import 'components/order_return_table.dart';

class ResiArea extends StatelessWidget {
  const ResiArea(
      {required this.cfCliente,
      required this.sort,
      required this.pageNumber,
      required this.pageSize,
      super.key});

  final int pageNumber;
  final int pageSize;
  final String sort;
  final String cfCliente;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SuperAppBar(
        area: "management_resi",
        search: "",
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              child: const Text(
                "Resi",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TableResi(
                cfCliente: cfCliente,
                pageNumber: pageNumber,
                pageSize: pageSize,
                sort: sort),
          ],
        ),
      ),
    );
  }
}