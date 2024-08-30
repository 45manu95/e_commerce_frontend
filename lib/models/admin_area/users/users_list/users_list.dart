import 'package:e_commerce_frontend/models/admin_area/users/users_list/components/table_clients.dart';
import 'package:flutter/material.dart';

import '../../../other/super_components/app_bar.dart';
import 'components/table_deleted_clients.dart';

class ClientsArea extends StatelessWidget {
  const ClientsArea(
      {required this.seeDeleteProducts,
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
  final bool seeDeleteProducts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (!seeDeleteProducts)
          ? SuperAppBar(
              area: "management_clients",
              search: "",
            )
          : SuperAppBar(
              area: "management_delete_clients",
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
                        "Clienti",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    : const Text(
                        "Clienti Eliminati",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
            (!seeDeleteProducts)
                ? TableClients(
                    pageNumber: pageNumber,
                    pageSize: pageSize,
                    search: search,
                    filter: filter,
                    sort: sort)
                : TableDeleteClients(
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