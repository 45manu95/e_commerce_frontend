import 'package:flutter/material.dart';

import '../../other/super_components/app_bar.dart';
import 'components/table_deleted_products.dart';
import 'components/table_products.dart';

class ProductsArea extends StatelessWidget {
  const ProductsArea(
      {required this.seeDeleteProducts,
      required this.cfCliente,
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
  final bool seeDeleteProducts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (!seeDeleteProducts)
          ? SuperAppBar(
              area: "management_products",
              search: "",
            )
          : SuperAppBar(
              area: "management_delete_products",
              search: "",
            ),
      body: Center(
        child: Stack(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                child: (!seeDeleteProducts)
                    ? const Text(
                        "Prodotti",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    : const Text(
                        "Prodotti Eliminati",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
            (!seeDeleteProducts)
                ? TableProducts(
                    cfCliente: cfCliente,
                    pageNumber: pageNumber,
                    pageSize: pageSize,
                    search: search,
                    filter: filter,
                    sort: sort)
                : TableDeleteProducts(
                    cfCliente: cfCliente,
                    pageNumber: pageNumber,
                    pageSize: pageSize,
                    search: search,
                    sort: sort)
          ],
        ),
      ),
    );
  }
}