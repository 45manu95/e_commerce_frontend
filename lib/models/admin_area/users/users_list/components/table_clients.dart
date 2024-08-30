import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_commerce_frontend/data/user_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_web_data_table/web_data_table.dart';
import 'package:provider/provider.dart';
import '../../../../../data/cart.dart';
import '../../../order_admin/order_admin.dart';
import '../../../order_return/order_return.dart';
import '../../../../products/product_list/products_area.dart';
import '../../../reviewsArea/reviews_area.dart';

// ignore: must_be_immutable
class TableClients extends StatefulWidget {
  TableClients(
      {required this.pageNumber,
      required this.pageSize,
      required this.filter,
      required this.search,
      required this.sort,
      super.key});

  int pageNumber;
  int pageSize;
  List<String> filter;
  String sort;
  String search;

  @override
  State<TableClients> createState() => _TableClientsState();
}

class _TableClientsState extends State<TableClients> {
  bool loadingAccess = false;
  late UserData cliente;

  List<String> _selectedRowKeys = [];

  final List<String> itemsNumber = [
    '10',
    '20',
    '50',
    '100',
  ];
  String selectedValue = "10";

  int trovaIndice(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, String cf) {
    if (snapshot.hasData) {
      int index = snapshot.data!.indexWhere((row) => row["cf"] == cf);
      return index;
    }
    return -1;
  }

  @override
  void initState() {
    super.initState();
    cliente = Provider.of<UserData>(context, listen: false);
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
      future: UserClient().data(widget.pageNumber, widget.pageSize, widget.filter,
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
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            WebDataTable(
              availableRowsPerPage: const [10, 20, 50, 100],
              rowsPerPage: int.parse(selectedValue),
              header: const Text('Elenco'),
              actions: [
                if (_selectedRowKeys.length == 1)
                  SizedBox(
                    height: 50,
                    width: 125,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.primary)),
                      child: const Text(
                        'Crea Ordine',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        int index =
                            trovaIndice(snapshot, _selectedRowKeys.first);
                        cliente.updateCliente(
                            _selectedRowKeys.first,
                            snapshot.data![index]["name"],
                            snapshot.data![index]["surname"],
                            snapshot.data![index]["city"],
                            snapshot.data![index]["region"],
                            snapshot.data![index]["address"],
                            snapshot.data![index]["cap"],
                            snapshot.data![index]["cellularNumber"],
                            snapshot.data![index]["email"],
                            snapshot.data![index]["username"],
                            CartData(
                                id: snapshot.data![index]["cart"]["id"],
                                totale: snapshot.data![index]["cart"]
                                    ["totalPrice"]));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductsArea(
                                    cfCliente: _selectedRowKeys.first,
                                    search: widget.search,
                                    filter: widget.filter,
                                    pageNumber: widget.pageNumber,
                                    pageSize: widget.pageSize,
                                    sort: "barCode",
                                    seeDeleteProducts: false)));
                      },
                    ),
                  ),
                if (_selectedRowKeys.length == 1)
                  SizedBox(
                    height: 50,
                    width: 175,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.primary)),
                      child: const Text(
                        'Visualizza Ordini',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrdersArea(
                                      cfCliente: _selectedRowKeys.first,
                                      search: "",
                                      filter: const [],
                                      pageNumber: 0,
                                      pageSize: 10,
                                      sort: "id",
                                    )));
                      },
                    ),
                  ),
                if (_selectedRowKeys.length == 1)
                  SizedBox(
                    height: 50,
                    width: 175,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.primary)),
                      child: const Text(
                        'Visualizza Resi',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResiArea(
                                      cfCliente: _selectedRowKeys.first,
                                      pageNumber: widget.pageNumber,
                                      pageSize: widget.pageSize,
                                      sort: "id",
                                    )));
                      },
                    ),
                  ),
                if (_selectedRowKeys.length == 1)
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.primary)),
                      child: const Text(
                        'Visualizza Recensioni',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewsArea(
                                      cfCliente: _selectedRowKeys.first,
                                      pageNumber: widget.pageNumber,
                                      pageSize: widget.pageSize,
                                      sort: "date",
                                      idProduct: "",
                                    )));
                      },
                    ),
                  ),
                if (_selectedRowKeys.isNotEmpty)
                  SizedBox(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.error)),
                      child: const Text(
                        'Elimina',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        showConfirmDialog();
                      },
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  width: 300,
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Ricerca Cliente',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFCCCCCC),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFCCCCCC),
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      widget.search = value;
                      UserClient().searchClient(value, context);
                    },
                  ),
                ),
              ],
              source: WebDataTableSource(
                columns: [
                  WebDataColumn(
                    name: 'cf',
                    label: const Text('C.F.'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'name',
                    label: const Text('Nome'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'surname',
                    label: const Text('Cognome'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'city',
                    label: const Text('Città'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'region',
                    label: const Text('Provincia'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'address',
                    label: const Text('Via'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'cap',
                    label: const Text('Cap'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'cellularNumber',
                    label: const Text('Telefono'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'email',
                    label: const Text('E-Mail'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'username',
                    label: const Text('Username'),
                    dataCell: (value) => DataCell(Text('$value')),
                  )
                ],
                rows: snapshot.data as List<Map<String, dynamic>>,
                selectedRowKeys: _selectedRowKeys,
                onSelectRows: (keys) {
                  setState(() {
                    _selectedRowKeys = keys;
                  });
                },
                primaryKeyName: 'cf',
              ),
              horizontalMargin: 15,
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
                                color:
                                    Theme.of(context).colorScheme.surface),
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
                                color:
                                    Theme.of(context).colorScheme.surface),
                          ))),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
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

  void showConfirmDialog() {
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
                      const Text(
                        "Conferma eliminazione",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Sei sicuro di voler eliminare le informazioni selezionate?",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                loadingAccess = false;
                              });
                              UserClient()
                                  .deleteClients(_selectedRowKeys, context);
                              setState(() {
                                _selectedRowKeys.clear();
                              });
                            },
                            child: Container(
                                width: 50,
                                margin: const EdgeInsets.only(left: 20),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.error,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: (loadingAccess)
                                    ? SpinKitCircle(
                                        size: 20,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return const DecoratedBox(
                                            decoration: BoxDecoration(
                                                color: Colors.white),
                                          );
                                        },
                                      )
                                    : Text(
                                        "SI",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background),
                                      )),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                width: 50,
                                margin: const EdgeInsets.only(right: 20),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Text(
                                  "NO",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          });
        });
  }
}