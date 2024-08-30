import 'package:flutter/material.dart';

import '../../other/super_components/app_bar.dart';
import 'components/table_orders.dart';

class OrdersArea extends StatelessWidget {
  const OrdersArea(
      {required this.cfCliente,
      required this.pageNumber,
      required this.pageSize,
      required this.search,
      required this.filter,
      required this.sort,
      super.key});

  final int pageNumber;
  final int pageSize;
  final String search;
  final List<String> filter;
  final String sort;
  final String cfCliente;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SuperAppBar(
        area: "management_orders",
        search: "",
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              child: const Text(
                "Ordini",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TableOrders(
                cfCliente: cfCliente,
                pageNumber: pageNumber,
                pageSize: pageSize,
                search: search,
                filter: filter,
                sort: sort),
          ],
        ),
      ),
    );
  }
}