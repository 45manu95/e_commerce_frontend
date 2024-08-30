import 'package:e_commerce_frontend/models/products/table_products/table_products.dart';
import 'package:flutter/material.dart';
import '../../../../data/user_type.dart';
import '../../../../main.dart';
import '../../../other/super_components/app_bar.dart';
import '../order_details/order_details.dart';

class ShowProducts extends StatelessWidget {
  const ShowProducts({required this.idOrder, super.key});

  final int idOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SuperAppBar(
        area: "none",
        search: "",
      ),
      body: Center(
        child: Stack(children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: double.infinity,
            child: Text(
              "Dettaglio ordine #$idOrder",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                (userData.userType == UserType.admin)
                    ? TableProducts(
                        idOrder: idOrder,
                      )
                    : OrderDetailScreen(idOrder: idOrder),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}