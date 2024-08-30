// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/order.dart';
import '../../../data/user_client.dart';
import '../../../data/user_type.dart';
import '../../../main.dart';
import '../../admin_area/order_admin/order_admin.dart';
import '../../other/super_components/app_bar.dart';
import '../oder_area/order_area.dart';
import 'components/shopping_cart.dart';


// ignore: must_be_immutable
class CarrelloArea extends StatelessWidget {
  CarrelloArea({required this.cfCliente, Key? key}) : super(key: key);

  final String cfCliente;
  int pageNumber = 0;
  int pageSize = 10;
  String search = "";
  String sort = "id";

  void _trySubmitOrder(BuildContext context) async {
    Ordine().createOrder("0", cfCliente, context).then((value) {
      if (value == true) {
        const snackBar = SnackBar(
          content: Text("Ordine effettuato con successo!"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        if (userData.userType == UserType.admin) {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => OrdersArea(
                        cfCliente: cfCliente,
                        pageNumber: pageNumber,
                        pageSize: pageSize,
                        filter: const [],
                        search: search,
                        sort: sort,
                      )));
        } else {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MyOrdersScreen(
                        cfCliente: cfCliente,
                        pageNumber: pageNumber,
                        pageSize: pageSize,
                        filter: const [],
                        search: search,
                        sort: sort,
                      )));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SuperAppBar(
        area: "management_cart",
        search: "",
      ),
      body: Column(
        children: [
          Expanded(
            child: ShoppingCart(cfCliente: cfCliente),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer<UserData>(
                  builder: (context, cliente, _) {
                    if (cliente.getCarrello()!.getTotale() <= 0) {
                      return Container();
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Totale: ${cliente.getCarrello()?.getTotale().toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _trySubmitOrder(context);
                            },
                            child: const Text('Effettua ordine'),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}