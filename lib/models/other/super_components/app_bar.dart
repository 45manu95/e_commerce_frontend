// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce_frontend/data/product.dart';
import 'package:e_commerce_frontend/data/user_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/cart.dart';
import '../../../data/category.dart';
import '../../../data/order.dart';
import '../../../data/user_type.dart';
import '../../../main.dart';
import '../../admin_area/category/add_category/add_category.dart';
import '../../admin_area/order_admin/filters/order_filter.dart';
import '../../admin_area/users/filters/user_filter.dart';
import '../../admin_area/users/users_list/users_list.dart';
import '../../home/home.dart';
import '../../products/add_product/add_product.dart';
import '../../products/filters/product_filter.dart';
import '../../products/product_list/products_area.dart';
import '../../user_area/cart_area/cart_area.dart';
import '../../user_area/profile/profile.dart';

// ignore: must_be_immutable
class SuperAppBar extends StatefulWidget implements PreferredSizeWidget {
  SuperAppBar({required this.area, required this.search, super.key});

  final String area;
  String search;

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    if (area == "home_user") {
      return _SuperAppBarUserState();
    } else if (area == "home_admin") {
      return _SuperAppBarAdminState();
    } else {
      return _SuperAppBarProductsState(area: area);
    }
  }
}

class _SuperAppBarUserState extends State<SuperAppBar> {
  late UserData cliente;

  List<String> categories = ["Tutte le Categorie"];
  String selectedCategory = "Tutte le Categorie";

  Future<void> showCategories() async {
    List<Map<String, dynamic>> categorie =
        await Category().data(0, 100000, "name", "");
    for (var categoria in categorie) {
      categories.add(categoria["name"]);
    }
  }

  void showProfileMenu(BuildContext context) {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000.0, 0.0, 0.0, 0.0),
      items: (userData.getType() == UserType.user)
          ? [
              const PopupMenuItem<String>(
                value: "Il mio Account",
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Il mio Account"),
                ),
              ),
              const PopupMenuItem<String>(
                value: "Esci",
                child: ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red),
                  title: Text("Esci", style: TextStyle(color: Colors.red)),
                ),
              ),
            ]
          : [
              const PopupMenuItem<String>(
                value: "Esci",
                child: ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red),
                  title: Text("Esci", style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
    ).then((value) {
      if (value == "Il mio Account") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProfileClientScreen()));
      } else if (value == "Esci") {
        userData.logOut(context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showCategories();
      setState(() {
        // Aggiornamento dello stato dopo che le categorie sono state caricate
      });
    });
    cliente = Provider.of<UserData>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      title: Row(
        children: [
          const Text('E-Commerce',
              style: TextStyle(color: Colors.white, fontSize: 16.0)),
          const SizedBox(width: 120.0),
          (UserType.admin != userData.getType()) ?
          DropdownButton(
            value: selectedCategory,
            onChanged: (String? value) {
              setState(() {
                selectedCategory = value!;
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            (selectedCategory != "Tutte le Categorie")
                                ? HomePage(
                                    userData: userData,
                                    pageNumber: 0,
                                    pageSize: 10,
                                    search: "",
                                    sort: "id",
                                    filter: ["", "", selectedCategory])
                                : HomePage(
                                    userData: userData,
                                    pageNumber: 0,
                                    pageSize: 10,
                                    search: "",
                                    sort: "id",
                                    filter: const [])));
              });
            },
            items: categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(
                  category,
                  style: TextStyle(
                    color: category == selectedCategory
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              );
            }).toList(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            elevation: 0,
            underline: Container(),
          ) : Container(),
          const SizedBox(width: 10),
                    (UserType.admin != userData.getType()) ?
          SizedBox(
            width: 500,
            child: TextField(
              cursorColor: Colors.black,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                hintText: 'Cerca il prodotto, brand...',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              onSubmitted: (value) {
                widget.search = value;
                Product().searchProduct(value, context);
              },
            ),
          ) : Container(),
        ],
      ),
      actions: [
        (userData.getType() == UserType.user)
            ? IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () async {
                  UserData client = await UserClient()
                      .getCliente(userData.codiceFiscale, context);
                  client.cf = userData.codiceFiscale;
                  if (client.cf == null) {
                    var snackBar = const SnackBar(
                      content: Text("Errore. Prova ad aggiornare la pagina"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    cliente.updateCliente(
                        client.cf!,
                        client.nome!,
                        client.cognome!,
                        client.citta!,
                        client.provincia!,
                        client.via!,
                        client.cap!,
                        client.telefono!,
                        client.email!,
                        client.username!,
                        CartData(
                            id: client.carrello!.id,
                            totale: client.carrello!.totale));
                    String cf = cliente.cf ?? "";
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CarrelloArea(cfCliente: cf)));
                  }
                },
              )
            : Container(),
        IconButton(
          icon: const Icon(
            Icons.account_circle_sharp,
            color: Colors.white,
          ),
          onPressed: () {
            showProfileMenu(context);
          },
        ),
      ],
    );
  }
}

class _SuperAppBarAdminState extends State<SuperAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          PopupMenuButton(onSelected: (result) {
            if (result == 0) {
              userData.logOut(context);
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem(value: 0, child: Text("Log out")),
            ];
          })
        ],
        actionsIconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.surface));
  }
}

class _SuperAppBarProductsState extends State<SuperAppBar> {
  _SuperAppBarProductsState({required this.area});

  @override
  void initState() {
    super.initState();
    cliente = Provider.of<UserData>(context, listen: false);
  }

  late UserData cliente;
  final String area;
  Color color = Colors.red;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          if (area == 'management_products')
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductsArea(
                              cfCliente: "",
                              filter: [],
                              pageNumber: 0,
                              pageSize: 10,
                              search: "",
                              sort: "barCode",
                              seeDeleteProducts: true)));
                },
                icon: const Icon(Icons.restore_from_trash)),
          if (area == 'management_clients')
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ClientsArea(
                              filter: [],
                              pageNumber: 0,
                              pageSize: 10,
                              search: "",
                              sort: "id",
                              seeDeleteProducts: true)));
                },
                icon: const Icon(Icons.restore_from_trash)),
          if (area == 'management_products')
            IconButton(
                onPressed: () {
                  Product().showSortDialog(context);
                },
                icon: const Icon(Icons.sort)),
          if (area == 'management_clients')
            IconButton(
                onPressed: () {
                  UserClient().showSortDialog(context);
                },
                icon: const Icon(Icons.sort)),
          if (area == 'management_orders')
            IconButton(
                onPressed: () {
                  Ordine().showSortDialog(context);
                },
                icon: const Icon(Icons.sort)),
          if (area == 'management_products')
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FilterProducts()));
              },
              icon: const Icon(Icons.filter_alt),
            ),
          if (area == 'management_clients')
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FilterClients()));
              },
              icon: const Icon(Icons.filter_alt),
            ),
          if (area == 'management_orders')
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FilterOrders()));
              },
              icon: const Icon(Icons.filter_alt),
            ),
          if ((area == 'management_products' &&
                  cliente.cf != null &&
                  userData.getType() == UserType.user) ||
              area == "management_cart")
            IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  String cf = cliente.cf ?? "";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CarrelloArea(cfCliente: cf)));
                }),
          PopupMenuButton(onSelected: (result) {
            if (result == 0) {
              userData.logOut(context);
            }
            if (result == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddProduct()));
            }
            if (result == 4) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddCategory()));
            }
          }, itemBuilder: (context) {
            return [
              if (area == "management_products" &&
                  (userData.getType() == UserType.admin))
                const PopupMenuItem(value: 1, child: Text("Aggiungi prodotto")),
              if (area == "management_category" &&
                  (userData.getType() == UserType.admin))
                const PopupMenuItem(
                    value: 4, child: Text("Aggiungi categoria")),
              if (userData.getType() != UserType.defaultUser)
                const PopupMenuItem(value: 0, child: Text("Log out")),
            ];
          })
        ],
        actionsIconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.surface));
  }
}
