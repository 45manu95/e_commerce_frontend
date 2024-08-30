import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/order.dart';
import '../../../main.dart';
import '../../admin_area/order_admin/show_products/show_products.dart';
import '../../admin_area/order_return/add_order_return/add_order_return.dart';
import '../../other/super_components/app_bar.dart';

// ignore: must_be_immutable
class MyOrdersScreen extends StatefulWidget {
  MyOrdersScreen(
      {required this.cfCliente,
      required this.filter,
      required this.pageNumber,
      required this.pageSize,
      required this.sort,
      required this.search,
      super.key});

  String cfCliente;
  int pageNumber;
  int pageSize;
  List<String> filter;
  String sort;
  String search;

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool loadingAccess = false;
  final List<String> itemsNumber = [
    '10',
    '20',
    '50',
    '100',
  ];

  String selectedValue = "10";
  String selectedYear = "";
  List<String> years = [];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
    int currentYear = DateTime.now().year;
    for (int i = 0; i < 10; i++) {
      years.add((currentYear - i).toString());
    }
    selectedYear = (widget.filter.isEmpty || widget.filter[1] == "")
        ? currentYear.toString()
        : widget.filter[1];
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
      future: Ordine().dataClientOrders(widget.cfCliente, widget.pageNumber,
          widget.pageSize, widget.filter, widget.sort, widget.search),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return Scaffold(
                appBar: SuperAppBar(area: "home_user", search: ""),
                body: Column(children: [
                  const SizedBox(height: 20),
                  Row(children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      width: 300,
                      child: TextField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.grey,
                          prefixIcon: Icon(Icons.search, color: Colors.blue),
                          hintText: 'Ricerca Ordine',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        onSubmitted: (value) {
                          widget.search = value;
                          Ordine().searchOrder(value, context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 100,
                      child: DropdownButton<String>(
                        hint: const Text('Anno'),
                        value: selectedYear,
                        onChanged: (String? value) {
                          setState(() {
                            selectedYear = value!;
                            Ordine()
                                .showFilterDialog("", selectedYear, context);
                          });
                        },
                        items:
                            years.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 40),
                  Expanded(child: noData())
                ]));
          } else {
            return Scaffold(
              appBar: SuperAppBar(area: "home_user", search: ""),
              body: Column(children: [
                const SizedBox(height: 20),
                Row(children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: 300,
                    child: TextField(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.grey,
                        prefixIcon: Icon(Icons.search, color: Colors.blue),
                        hintText: 'Ricerca Ordine',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      onSubmitted: (value) {
                        widget.search = value;
                        Ordine().searchOrder(value, context);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: DropdownButton<String>(
                      hint: const Text('Anno'),
                      value: selectedYear,
                      onChanged: (String? value) {
                        setState(() {
                          selectedYear = value!;
                          Ordine().showFilterDialog("", selectedYear, context);
                        });
                      },
                      items:
                          years.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ]),
                const SizedBox(height: 40),
                Expanded(child: hasData(snapshot)),
                Align(
                  alignment: Alignment.bottomRight,
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
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Text(
                              "Numero Elementi",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.surface),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Text(
                                "Pagina indietro",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface),
                              ))),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                          onTap: () {
                            if ((int.parse(selectedValue) -
                                        snapshot.data!.length ==
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Text(
                                "Pagina avanti",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface),
                              ))),
                    ],
                  ),
                ),
              ]),
            );
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return loadPage();
      },
    );
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
          "Nessun Risultato",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Widget hasData(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final ordine = snapshot.data![index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text("ORDINATO IL:"),
                    Text("${ordine["purchaseDate"]}")
                  ],
                ),
                Column(
                  children: [
                    const Text("TOTALE:"),
                    Text("${ordine["totalPrice"].toStringAsFixed(2)}")
                  ],
                ),
                Tooltip(
                  message: 'Informazioni su Consegna',
                  child: Column(children: [
                    const Text("INVIA A"),
                    TextButton(
                      onPressed: () {
                        showCustomerDetailsDialog(ordine["userOrder"]);
                      },
                      child: Text(
                        "${ordine["userOrder"]["name"]}  ${ordine["userOrder"]["surname"]}",
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Text("#${ordine["id"]}"),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowProducts(
                                        idOrder: ordine["id"],
                                      )));
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue),
                        child: const Text("Visualizza Dettagli Ordine"),
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddReso(
                                  numeroOrdine: ordine["id"],
                                  cfCliente: userData.codiceFiscale)));
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue),
                    child: const Text("Richiedi Reso")),
              ],
            ),
          );
        },
      ),
    );
  }

  void showCustomerDetailsDialog(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${customer["name"]} ${customer["surname"]}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${customer["address"]}'),
              Text('${customer["city"]}, ${customer["region"]}'),
              Text('${customer["cap"]}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Chiudi'),
            ),
          ],
        );
      },
    );
  }
}