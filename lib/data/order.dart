// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/admin_area/order_admin/order_admin.dart';
import '../models/user_area/oder_area/order_area.dart';
import 'user_client.dart';
import 'user_type.dart';

class Ordine {
  int pageNumber = 0;
  int pageSize = 10;
  List<String> filter = ["", ""];
  String sort = "id";
  String search = "";
  late Uri url;
  String idOrder = "";
  String cfCliente = "";

  Future<List<Map<String, dynamic>>> dataClientOrders(String cf, int pageNumber,
      int pageSize, List<String> filter, String sort, String search) async {
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.sort = sort;
    this.search = search;
    cfCliente = cf;
    for (int k = 0; k < filter.length; k++) {
      this.filter[k] = filter[k].trim();
    }
    var list = await getAllOrdineCliente(cf).then((value) {
      return value.map((row) => row.toJson()).toList();
    });
    return list;
  }

  Future<List<Map<String, dynamic>>> data(int pageNumber, int pageSize,
      List<String> filter, String sort, String search) async {
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.sort = sort;
    this.search = search;
    for (int k = 0; k < filter.length; k++) {
      this.filter[k] = filter[k].trim();
    }
    var list = await getData().then((value) {
      return value.map((row) => row.toJson()).toList();
    });
    return list;
  }

  Future<List<OrdineData>> getData() async {
    List<OrdineData> results = [];

    await Future.delayed(const Duration(milliseconds: 500));

    var contentType = "application/json;charset=utf-8";
    String accessToken = userData.accessToken;
    Map<String, String> headers = {};
    headers[HttpHeaders.contentTypeHeader] = contentType;
    headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    headers[HttpHeaders.acceptHeader] = "application/json";
    headers[HttpHeaders.accessControlAllowOriginHeader] = "*";
    headers[HttpHeaders.accessControlAllowMethodsHeader] = "POST, GET, DELETE";
    headers[HttpHeaders.accessControlAllowHeadersHeader] = "Content-Type";

    if (search != "" && search != "default_search") {
      url = Uri.parse(
          "http://localhost:8080/order/search/$search?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    } else if (filter[0] != "" || filter[1] != "") {
      url = Uri.parse(
          "http://localhost:8080/order/filter?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort&state=${filter[0]}&year=${filter[1]}");
    } else {
      url = Uri.parse(
          "http://localhost:8080/order/all?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    }

    try {
      final request = await http.get(url, headers: headers);
      if (request.statusCode == 200) {
        final List<dynamic> ordini = json.decode(request.body);
        for (var ordine in ordini) {
          results.add(OrdineData.fromJson(ordine));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return results;
  }

  Future<bool> createOrder(
      scontoApplicato, cliente, BuildContext context) async {
    String accessToken = userData.accessToken;
    UserType role = userData.getType();
    String cfCliente = userData.getCodiceFiscale();
    String cfDaInserire = (role == UserType.user) ? cfCliente : cliente;
    try {
      var request =
          await http.post(Uri.parse("http://localhost:8080/order/add"),
              headers: {
                'Access-Control-Allow-Origin': '*',
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $accessToken',
                'Accept': '*/*',
                'Cache-Control': 'no-cache'
              },
              body: json.encode({
                'userOrder': {'cf': cfDaInserire.trim()},
              }));
      if (request.statusCode == 200) {
        return true;
      } else {
        showResultDialog(request.body, context);
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  void deleteOrders(List<String> orders, BuildContext context) async {
    String accessToken = userData.accessToken;
    List<String> selectedRowKeys = [];

    for (int i = 0; i < orders.length; i++) {
      selectedRowKeys.add(orders[i]);
    }
    try {
      for (int k = 0; k < selectedRowKeys.length; k++) {
        var request = await http.delete(
          Uri.parse(
              "http://localhost:8080/order/remove/${selectedRowKeys[k]}"),
          headers: {
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Accept': '*/*'
          },
        );

        if (request.statusCode != 200) {
          var snackBar = SnackBar(
            content: Text(request.body),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
          return;
        }
      }
      Navigator.pop(context);
      showDeleteResultDialog("Eliminazione effettuata con successo!", context);
    } catch (e) {
      showDeleteResultDialog("Connessione internet assente", context);
    }
  }

  Future<bool> aggiornaStato(
      String orderID, String stato, BuildContext context) async {
    String accessToken = userData.accessToken;
    try {
      var request = await http.put(
        Uri.parse(
            "http://localhost:8080/order/updateState?id=$orderID&state=$stato"),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Accept': '*/*'
        },
      );
      if (request.statusCode == 400) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<OrdineData>> getAllOrdineCliente(String cliente) async {
    List<OrdineData> results = [];
    UserType role = userData.getType();
    String cfCliente = userData.getCodiceFiscale();
    String cfDaInserire = (role == UserType.user) ? cfCliente : cliente;

    await Future.delayed(const Duration(milliseconds: 500));

    String accessToken = userData.accessToken;
    try {
      var request = await http.get(
        (filter[0] != "" || filter[1] != "")
            ? Uri.parse(
                "http://localhost:8080/order/filter/$cfDaInserire?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort&state=${filter[0]}&year=${filter[1]}")
            : (search != "" && search != "default_search")
                ? Uri.parse(
                    "http://localhost:8080/order/search/$search/${userData.codiceFiscale}?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort")
                : Uri.parse(
                    "http://localhost:8080/order/all/$cfDaInserire?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort"),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Accept': '*/*'
        },
      );

      if (request.statusCode == 200) {
        final List<dynamic> ordini = json.decode(request.body);
        for (var ordine in ordini) {
          results.add(OrdineData.fromJson(ordine));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return results;
  }

  void searchOrder(search, BuildContext context) {
    this.search = search.trim();
    if (userData.userType == UserType.admin) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrdersArea(
                  cfCliente: cfCliente,
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  search: search,
                  filter: filter,
                  sort: sort)));
    } else {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyOrdersScreen(
                  cfCliente: cfCliente,
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  search: search,
                  filter: filter,
                  sort: sort)));
    }
  }

  showResultDialog(String message, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(message),
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
                  search: search,
                  filter: filter,
                  sort: sort)));
    }
  }

  showDeleteResultDialog(String message, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => OrdersArea(
                cfCliente: cfCliente,
                pageNumber: pageNumber,
                pageSize: pageSize,
                search: search,
                filter: filter,
                sort: sort)));
  }

  showFilterDialog(String stato, String anno, BuildContext context) {
    List<String> filterParameters = [stato.toString(), anno.trim()];
    if (userData.userType == UserType.admin) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrdersArea(
                  cfCliente: cfCliente,
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  search: search,
                  filter: filterParameters,
                  sort: sort)));
    } else {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyOrdersScreen(
                  cfCliente: cfCliente,
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  search: search,
                  filter: filterParameters,
                  sort: sort)));
    }
  }

  showSortDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) {
          return SimpleDialog(
            children: [
              const Text(
                "ORDINAMENTO",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 50, right: 50),
                child: ElevatedButton(
                    onPressed: () {
                      sort = "purchaseDate";
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrdersArea(
                                  cfCliente: cfCliente,
                                  pageNumber: pageNumber,
                                  pageSize: pageSize,
                                  search: search,
                                  filter: filter,
                                  sort: sort)));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    child: Text(
                      "Data Acquisto",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        }));
  }
}

class OrdineData {
  final String stato;
  final String data;
  final UserData cliente;
  final double totale;
  final double id;

  OrdineData(
      {
      required this.stato,
      required this.data,
      required this.cliente,
      required this.totale,
      required this.id});

  factory OrdineData.fromJson(Map<String, dynamic> json) {
    return OrdineData(
        id: json["id"],
        stato: json["state"],
        data: json["purchaseDate"],
        cliente: UserData.fromJson(json["userOrder"]),
        totale: json["totalPrice"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state': stato,
      'purchaseDate': data,
      'userOrder': cliente.toJson(),
      'totalPrice': totale
    };
  }
}