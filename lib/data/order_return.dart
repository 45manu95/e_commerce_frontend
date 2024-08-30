import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/admin_area/order_return/order_return.dart';
import '../models/user_area/oder_area/order_area.dart';
import '../models/user_area/user_order_return/user_order_return.dart';
import 'order.dart';
import 'user_client.dart';
import 'user_type.dart';

class Reso {
  int pageNumber = 0;
  int pageSize = 10;
  String sort = "id";
  late Uri url;
  String cfCliente = "";

  Future<List<Map<String, dynamic>>> data(
      int pageNumber, int pageSize, String sort, String cliente) async {
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.sort = sort.trim();
    cfCliente = cliente;
    var list = await getData().then((value) {
      return value.map((row) => row.toJson()).toList();
    });
    return list;
  }

  Future<List<Map<String, dynamic>>> dataResiCliente(
      int pageNumber, int pageSize, String sort, String cliente) async {
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.sort = sort.trim();
    cfCliente = cliente;
    var list = await getAllResiCliente(cliente).then((value) {
      return value.map((row) => row.toJson()).toList();
    });
    return list;
  }

  Future<List<ResoData>> getData() async {
    List<ResoData> results = [];

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

    url = Uri.parse(
        "http://localhost:8080/orderReturn/all?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");

    try {
      final request = await http.get(url, headers: headers);
      if (request.statusCode == 200) {
        final List<dynamic> resi = json.decode(request.body);
        for (var reso in resi) {
          results.add(ResoData.fromJson(reso));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return results;
  }

  Future<bool> addReso(
      cliente, ordine, motivazione, BuildContext context) async {
    String accessToken = userData.accessToken;
    UserType role = userData.getType();
    String cfCliente = userData.getCodiceFiscale();
    String cfDaInserire = (role == UserType.user) ? cfCliente : cliente;
    try {
      var request = await http.post(
        Uri.parse("http://localhost:8080/orderReturn/add"),
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Accept': '*/*',
          'Cache-Control': 'no-cache'
        },
        body: json.encode({
          'userOrderReturn': {'cf': cfDaInserire.trim()},
          'descriptionReturn': motivazione.trim(),
          'order': {'id': ordine}
        }),
      );

      if (request.statusCode == 200) {
        // ignore: use_build_context_synchronously
        showResultDialog(request.body, context);
        return true;
      } else {
        // ignore: use_build_context_synchronously
        showResultDialog(request.body, context);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void deleteReso(List<String> resi, BuildContext context) async {
    String accessToken = userData.accessToken;
    List<String> selectedRowKeys = [];

    for (int i = 0; i < resi.length; i++) {
      selectedRowKeys.add(resi[i]);
    }
    try {
      for (int k = 0; k < selectedRowKeys.length; k++) {
        var request = await http.delete(
          Uri.parse("http://localhost:8080/orderReturn/remove/${selectedRowKeys[k]}"),
          headers: {
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Accept': '*/*'
          },
        );

        if (request.statusCode != 200) {
          // ignore: use_build_context_synchronously
          var snackBar = SnackBar(
            content: Text(request.body),
          );
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          return;
        }
      }
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      showDeleteResultDialog("Eliminazione effettuata con successo!", context);
    } catch (e) {
      showDeleteResultDialog("Connessione internet assente", context);
    }
  }

  Future<List<ResoData>> getAllResiCliente(String cfCliente) async {
    List<ResoData> results = [];
    await Future.delayed(const Duration(milliseconds: 500));

    String accessToken = userData.accessToken;
    try {
      var request = await http.get(
        Uri.parse(
            "http://localhost:8080/orderReturn/$cfCliente/all?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort"),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Accept': '*/*'
        },
      );

      if (request.statusCode == 200) {
        final List<dynamic> resi = json.decode(request.body);
        for (var reso in resi) {
          results.add(ResoData.fromJson(reso));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return results;
  }

  showResultDialog(String message, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(message),
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // ignore: use_build_context_synchronously
    if (userData.userType == UserType.admin) {
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ResiArea(
                  cfCliente: "",
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  sort: sort)));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyOrdersScreen(
                  cfCliente: userData.codiceFiscale,
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  filter: const [],
                  search: "",
                  sort: sort)));
    }
  }

  showDeleteResultDialog(String message, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(message),
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // ignore: use_build_context_synchronously
    // ignore: use_build_context_synchronously
    if (userData.userType == UserType.admin) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ResiArea(
                  cfCliente: "",
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  sort: sort)));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyResoScreen(
                  cfCliente: userData.codiceFiscale,
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  filter: const [],
                  search: "",
                  sort: sort)));
    }
  }
}

class ResoData {
  final double id;
  final String motivazione;
  final OrdineData ordine;
  final UserData cliente;

  ResoData(
      {required this.id,
      required this.ordine,
      required this.cliente,
      required this.motivazione});

  factory ResoData.fromJson(Map<String, dynamic> json) {
    return ResoData(
        id: json["id"],
        motivazione: json["descriptionReturn"],
        ordine: OrdineData.fromJson(json["order"]),
        cliente: UserData.fromJson(json["userOrderReturn"]));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descriptionReturn': motivazione,
      'order': ordine.toJson(),
      'userOrderReturn': cliente.cf
    };
  }
}