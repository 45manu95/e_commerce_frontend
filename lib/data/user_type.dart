// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:core';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/access/access.dart';

enum UserType { admin, user, defaultUser }

class User {
  late String username, password, codiceFiscale;
  UserType userType = UserType.defaultUser;
  String accessToken = "";
  String refreshToken = "";

  void setParam(String username, String password) {
    this.username = username.trim();
    this.password = password.trim();
  }

  String getCodiceFiscale() {
    return codiceFiscale;
  }

  UserType getType() {
    return userType;
  }

  Future<bool> getAccess(BuildContext context) async {
    try {
      final check = await http.get(
        Uri.parse('http://localhost:8080/user/checkVisible/$username'),
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Cache-Control': 'no-cache'
        },
      );
      bool isValid = json.decode(check.body);
      if (!isValid && username != "admin") {
        const snackBar = SnackBar(
          backgroundColor: Colors.blue,
          content: Text('Utente non registrato'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
      final request = await http.post(
        Uri.parse(
            'http://localhost:8081/realms/eCommerce/protocol/openid-connect/token'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'cache-control': 'no-cache',
          'Access-Control-Allow-Origin': '*',
          'Accept': '*/*',
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
        },
        body: <String, String>{
          'grant_type': 'password',
          'client_id': 'eCommerce_login',
          'username': username,
          'password': password,
        },
      );
      if (request.statusCode == 200) {
        Map dataResponse = json.decode(request.body);
        accessToken = dataResponse["access_token"];
        refreshToken = dataResponse["refresh_token"];
        final jwt = JWT.decode(accessToken);
        dynamic payload = jwt.payload;
        if (payload.containsKey("resource_access") &&
            payload["resource_access"].containsKey("eCommerce_login")) {
          List<dynamic> roles =
              payload["resource_access"]["eCommerce_login"]["roles"];
          if (roles.contains("role_admin")) {
            userType = UserType.admin;
          } else {
            userType = UserType.user;
          }
        }
        if (payload.containsKey("cf")) {
          codiceFiscale = payload["cf"];
        }
        return true;
      } else if (request.statusCode == 403 || request.statusCode == 401) {
        if (!context.mounted) {
          return false;
        }
        const snackBar = SnackBar(
          backgroundColor: Colors.blue,
          content: Text('Utente non registrato'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('Errore Connessione'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }

    return false;
  }

  Future<bool> subscribe(cf, name, surname, city, address, region, cap,
      cellularNumber, email, username, password, BuildContext context) async {
    try {
      var request =
          await http.post(Uri.parse("http://localhost:8080/auth/subscribe"),
              headers: {
                'Access-Control-Allow-Origin': '*',
                'Content-Type': 'application/json',
                'Accept': '*/*',
                'Cache-Control': 'no-cache'
              },
              body: json.encode({
                'cf': cf.trim(),
                'name': name.trim(),
                'surname': surname.trim(),
                'city': city.trim(),
                'address': address.trim(),
                'region': region.trim(),
                'cap': cap,
                'cellularNumber': cellularNumber,
                'email': email.trim(),
                'username': username.trim(),
                'password': password.trim()
              }));
      if (request.statusCode == 200) {
        return true;
      } else {
        const snackBar = SnackBar(
          content: Text('Errore Connessione'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      return false;
    } catch (e) {
      const snackBar = SnackBar(
          content: Text('Errore Generico'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
    }
  }


  void logOut(BuildContext context) async {
    try {
      final request = await http.post(
          Uri.parse(
              'http://localhost:8081/realms/eCommerce/protocol/openid-connect/logout'),
             headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'cache-control': 'no-cache',
          'Access-Control-Allow-Origin': '*',
          'Accept': '*/*',
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
        },
          body: <String, String>{
            'client_id': 'eCommerce_login',
            'refresh_token': refreshToken,
          });
      if (request.statusCode == 200 || request.statusCode == 204) {
        username = "";
        password = "";
        accessToken = "";
        refreshToken = "";
        codiceFiscale = "";
        userType = UserType.defaultUser;
        const snackBar = SnackBar(
          content: Text('Uscita effettuata con successo'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Access()),
            (route) => false);
      }
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('Errore Connessione'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

}
