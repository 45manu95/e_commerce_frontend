// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/admin_area/category/category_area.dart';

class Category {
  int pageNumber = 0;
  int pageSize = 10;
  String sort = "name";
  String search = "";
  late Uri url;

  Future<List<Map<String, dynamic>>> data(
      int pageNumber, int pageSize, String sort, String search) async {
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.search = search;
    this.sort = sort.trim();

    var list = await getData().then((value) {
      return value.map((row) => row.toJson()).toList();
    });
    return list;
  }

  Future<List<CategoryData>> getData() async {
    List<CategoryData> results = [];

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
          "http://localhost:8080/category/search/$search?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    } else {
      url = Uri.parse(
          "http://localhost:8080/category/all?pageNumber=$pageNumber&pageSize=$pageSize&sortBy=$sort");
    }

    try {
      final request = await http.get(url, headers: headers);
      if (request.statusCode == 200) {
        final List<dynamic> categorie = json.decode(request.body);
        for (var categoria in categorie) {
          results.add(CategoryData.fromJson(categoria));
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return results;
  }

  Future<bool> addCategoria(name, BuildContext context) async {
    String accessToken = userData.accessToken;
    try {
      var request =
          await http.post(Uri.parse("http://localhost:8080/category/add"),
              headers: {
                'Access-Control-Allow-Origin': '*',
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $accessToken',
                'Accept': '*/*',
                'Cache-Control': 'no-cache'
              },
              body: json.encode({
                'name': name.trim(),
              }));
      if (request.statusCode == 200) {
        return true;
      } else {
        print(request.statusCode);
        showResultDialog(request.body, context);
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void deleteCategories(List<String> category, BuildContext context) async {
    String accessToken = userData.accessToken;
    List<String> selectedRowKeys = [];

    for (int i = 0; i < category.length; i++) {
      selectedRowKeys.add(category[i]);
    }
    try {
      for (int k = 0; k < selectedRowKeys.length; k++) {
        String cat = selectedRowKeys.elementAt(k);
        var request = await http.delete(
          Uri.parse("http://localhost:8080/category/remove/${cat}"),
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
      print(e);
      showDeleteResultDialog("Connessione internet assente", context);
    }
  }

  void searchCategory(search, BuildContext context) {
    this.search = search.trim();
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategoryArea(
                pageNumber: pageNumber,
                pageSize: pageSize,
                search: search,
                sort: sort)));
  }

  showResultDialog(String message, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CategoryArea(
                pageNumber: pageNumber,
                pageSize: pageSize,
                search: search,
                sort: sort)));
  }

  showDeleteResultDialog(String message, BuildContext context) {
    var snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CategoryArea(
                pageNumber: pageNumber,
                pageSize: pageSize,
                search: search,
                sort: sort)));
  }
}

class CategoryData {
  final String nome;

  CategoryData({required this.nome});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      nome: json["name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': nome};
  }

  String getNome() {
    return nome;
  }

  @override
  String toString() {
    return nome;
  }
}