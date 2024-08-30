import 'dart:convert';
import 'dart:io';
import 'package:e_commerce_frontend/data/product.dart';
import 'package:e_commerce_frontend/data/user_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/admin_area/reviewsArea/reviews_area.dart';
import '../models/user_area/user_reviews/user_reviews.dart';
import 'user_type.dart';

class Review {
  int pageNumber = 0;
  int pageSize = 10;
  String sort = "date";
  late Uri url;
  String cfCliente = "";

  Future<List<Map<String, dynamic>>> dataClientReviews(
      int pageNumber, int pageSize, String sort, String cliente) async {
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.sort = sort.trim();
    cfCliente = cliente;
    var list = await getAllRecensioniCliente(cliente).then((value) {
      return value.map((row) => row.toJson()).toList();
    });
    return list;
  }

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

  Future<List<ReviewData>> getData() async {
    List<ReviewData> results = [];

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
        "http://localhost:8080/review/all?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");

    try {
      final request = await http.get(url, headers: headers);
      if (request.statusCode == 200) {
        final List<dynamic> recensioni = json.decode(request.body);
        for (var recensione in recensioni) {
          results.add(ReviewData.fromJson(recensione));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return results;
  }

  Future<bool> addRecensione(
      testo, valutazione, cliente, prodotto, BuildContext context) async {
    String accessToken = userData.accessToken;
    String cfCliente = userData.getCodiceFiscale();
    try {
      var request = await http.post(
        Uri.parse("http://localhost:8080/review/add"),
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Accept': '*/*',
          'Cache-Control': 'no-cache'
        },
        body: json.encode({
          'description': testo,
          'stars': valutazione,
          'userReview': {'cf': cfCliente.trim()},
          'reviewedProduct': {'barCode': prodotto.trim()}
        }),
      );

      if (request.statusCode == 200) {
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

  void deleteRecensione(List<String> recensioni, BuildContext context) async {
    String accessToken = userData.accessToken;
    List<String> selectedRowKeys = [];

    for (int i = 0; i < recensioni.length; i++) {
      selectedRowKeys.add(recensioni[i]);
    }
    try {
      for (int k = 0; k < selectedRowKeys.length; k++) {
        var request = await http.delete(
          Uri.parse(
              "http://localhost:8080/review/remove/${selectedRowKeys[k]}"),
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

  Future<List<ReviewData>> getAllRecensioniCliente(String cliente) async {
    List<ReviewData> results = [];
    UserType role = userData.getType();
    String cfCliente = userData.getCodiceFiscale();
    String cfDaInserire = (role == UserType.user) ? cfCliente : cliente;

    await Future.delayed(const Duration(milliseconds: 500));

    String accessToken = userData.accessToken;
    try {
      var request = await http.get(
        Uri.parse(
            "http://localhost:8080/review/user/$cfDaInserire?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort"),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Accept': '*/*'
        },
      );

      if (request.statusCode == 200) {
        final List<dynamic> recensioni = json.decode(request.body);
        for (var recensione in recensioni) {
          results.add(ReviewData.fromJson(recensione));
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
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ReviewsArea(
                    cfCliente: "",
                    pageNumber: pageNumber,
                    pageSize: pageSize,
                    sort: sort,
                    idProduct: "",
                  )));
    } else {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyReviewsScreen(
                    cfCliente: "",
                    pageNumber: pageNumber,
                    pageSize: pageSize,
                    sort: sort,
                  )));
    }
  }

  showDeleteResultDialog(String message, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(message),
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // ignore: use_build_context_synchronously
    if (userData.userType == UserType.admin) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ReviewsArea(
                  cfCliente: "",
                  pageNumber: pageNumber,
                  pageSize: pageSize,
                  sort: sort,
                  idProduct: "")));
    } else {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyReviewsScreen(
                    cfCliente: "",
                    pageNumber: pageNumber,
                    pageSize: pageSize,
                    sort: sort,
                  )));
    }
  }
}

class ReviewData {
  final double id;
  final String testo;
  final int valutazione;
  final String data;
  final UserData cliente;
  final SampleDataRow prodotto;

  ReviewData(
      {required this.id,
      required this.testo,
      required this.valutazione,
      required this.data,
      required this.cliente,
      required this.prodotto});

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
        id: json["id"],
        testo: json["description"],
        valutazione: json["stars"],
        data: json["date"],
        cliente: UserData.fromJson(json["userReview"]),
        prodotto: SampleDataRow.fromJson(json["reviewedProduct"]));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': testo,
      'stars': valutazione,
      'date': data,
      'userReview': cliente.toJson(),
      'reviewedProduct': prodotto.nome
    };
  }
}