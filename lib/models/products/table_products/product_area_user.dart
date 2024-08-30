import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_commerce_frontend/data/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/product_detail.dart';

// ignore: must_be_immutable
class ProductsAreaUser extends StatefulWidget {
  ProductsAreaUser({
    super.key,
    required this.pageNumber,
    required this.pageSize,
    required this.search,
    required this.filter,
    required this.sort,
  });

  int pageNumber;
  int pageSize;
  String search;
  List<String> filter;
  String sort;

  @override
  // ignore: library_private_types_in_public_api
  _ProductsAreaUserState createState() => _ProductsAreaUserState();
}

class _ProductsAreaUserState extends State<ProductsAreaUser> {
  final List<String> itemsNumber = [
    '10',
    '20',
    '50',
    '100',
  ];
  String selectedValue = "10";

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Product().data(widget.pageNumber, widget.pageSize, widget.filter,
          widget.sort, widget.search),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return noData();
          } else {
            return hasData(snapshot);
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

  Widget hasData(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Stack(children: [
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  showDetailProduct(snapshot.data![index]);
                },
                child: Card(
                  child: Column(
                    children: [
                      snapshot.data![index]["productImages"].isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 67),
                              child: Image.memory(
                                base64Decode(snapshot.data![index]
                                    ["productImages"][0]["content"]),
                                height: 100,
                                width: 100,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 67),
                              height: 150,
                              width: 150,
                              color: Colors.grey,
                              child: const Center(
                                  child: Text("Nessuna immagine")),
                            ),
                  
                      Text(snapshot.data![index]["name"]),
                      Text('€${snapshot.data![index]["price"]}'),
                      Text(snapshot.data![index]["state"],
                          style: TextStyle(
                              color: (snapshot.data![index]["state"] ==
                                      "Disponibile")
                                  ? Colors.green
                                  : Colors.red))
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            right: 5,
            bottom: 8,
            width: 850,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    showPageSizeDialog();
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        "Numero Elementi",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.surface),
                      )),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                    onTap: () {
                      if (widget.pageNumber != 0) {
                        setState(() {
                          widget.pageNumber--;
                        });
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: (widget.pageNumber != 0)
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          "Pagina indietro",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface),
                        ))),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                    onTap: () {
                      if ((int.parse(selectedValue) - snapshot.data!.length ==
                              0) ||
                          snapshot.data!.isEmpty) {
                        setState(() {
                          widget.pageNumber++;
                        });
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: ((int.parse(selectedValue) -
                                            snapshot.data!.length ==
                                        0) ||
                                    snapshot.data!.isEmpty)
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          "Pagina avanti",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface),
                        ))),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void showDetailProduct(Map<String, dynamic> product) {
    SampleDataRow prodotto = SampleDataRow.fromJson(product);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductDetails(prodotto: prodotto)));
  }

  void showPageSizeDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Numero di elementi visualizzabili"),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Seleziona numero',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: itemsNumber
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value!;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            width: 190,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            elevation: 2,
                          ),
                          iconStyleData: IconStyleData(
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            iconSize: 14,
                            iconEnabledColor:
                                Theme.of(context).colorScheme.surface,
                            iconDisabledColor: Colors.grey,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: WidgetStateProperty.all(6),
                              thumbVisibility: WidgetStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 14, right: 14),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            stateNumRows();
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Text(
                                "CONFERMA",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface),
                              ))),
                    ],
                  ),
                )
              ],
            );
          });
        });
  }

  void stateNumRows() {
    setState(() {
      widget.pageSize = int.parse(selectedValue);
    });
  }

  Widget noData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Nessun Risultato",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          (widget.pageNumber != 0)
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.pageNumber--;
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        "Pagina indietro",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.surface),
                      )))
              : Container(),
        ],
      ),
    );
  }
}