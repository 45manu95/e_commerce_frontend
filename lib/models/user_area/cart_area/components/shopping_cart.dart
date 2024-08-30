import 'dart:convert';
import 'package:e_commerce_frontend/data/user_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:provider/provider.dart';
import '../../../../data/composition_cart.dart';

// ignore: must_be_immutable
class ShoppingCart extends StatefulWidget {
  ShoppingCart({required this.cfCliente, super.key});

  String cfCliente;

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  bool loadingAccess = false;
  Map<String, int> selectedQuantities = {};
  late UserData cliente;

  void trySubmitAggiornaQuantita(int id, int quantita) async {
    FocusScope.of(context).unfocus();
    ComposizioneCarrello()
        .aggiornaQuantita(id, quantita, context)
        .then((value) {
      if (value.id == cliente.getCarrello()!.getId()) {
        cliente.updateCarrello(value);
      }
    });
  }

  void deleteProduct(int id) {
    ComposizioneCarrello().removeProdottoCarrello(id, context).then((value) {
      if (value.id == cliente.getCarrello()!.getId()) {
        cliente.updateCarrello(value);
      }
    });
  }

  bool hasItemsInCart() {
    return selectedQuantities.isNotEmpty;
  }

  @override
  void initState() {
    cliente = Provider.of<UserData>(context, listen: false);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ComposizioneCarrello().data(widget.cfCliente),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return noData();
          } else {
            return ShowProductsCarrello(snapshot);
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return loadPage();
      },
    );
  }

  Widget loadPage() {
    return const Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
        ),
        CircularProgressIndicator()
      ],
    ));
  }

  Widget noData() {
    return const Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Carrello vuoto",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ShowProductsCarrello(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final composizione = snapshot.data![index];
        final prodotto = composizione["product"];
        return Card(
          margin: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  prodotto["productImages"].isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 25, horizontal: 67),
                          child: Image.memory(
                            base64Decode(
                                prodotto["productImages"][0]["content"]),
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 25, horizontal: 67),
                          height: 150,
                          width: 150,
                          color: Colors.grey,
                          child: const Center(child: Text("Nessuna immagine")),
                        ),
                ],
              ),
              SizedBox(
                width: 400,
                height: 150,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${prodotto['name']}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(children: [Text('Marca: ${prodotto['brand']}')]),
                      Row(children: [Text('Prezzo: ${prodotto['price']}')]),
                      Row(children: [
                        Text(
                          'Stato: ${prodotto['state']}',
                          style: TextStyle(
                              color: (prodotto['state'] == "Disponibile")
                                  ? Colors.green
                                  : Colors.red),
                        )
                      ])
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  InputQty.int(
                    maxVal: 999,
                    initVal: composizione["quantity"],
                    steps: 1,
                    minVal: 1,
                    onQtyChanged: (value) {
                      setState(() {
                        trySubmitAggiornaQuantita(composizione["id"], value);
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Required field";
                      } else if (value > prodotto["quantity"]) {
                        return "More than available quantity";
                      }
                      return null;
                    },
                  ),
                ],
              ),
              Column(children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      deleteProduct(composizione['id']);
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )
              ]),
              Column(children: [
                Text(
                  'Subtotale: ${composizione['subTotal'].toStringAsFixed(2)}',
                )
              ]),
            ],
          ),
        );
      },
    );
  }
}