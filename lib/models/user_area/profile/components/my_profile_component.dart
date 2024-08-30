import 'package:e_commerce_frontend/data/user_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../other/super_components/app_bar.dart';

class MyUserProfileScreen extends StatefulWidget {
  final UserData cliente;

  const MyUserProfileScreen({super.key, required this.cliente});

  @override
  // ignore: library_private_types_in_public_api
  _MyUserProfileScreenState createState() => _MyUserProfileScreenState();
}

class _MyUserProfileScreenState extends State<MyUserProfileScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _cognomeController;
  late TextEditingController _cittaController;
  late TextEditingController _provinciaController;
  late TextEditingController _viaController;
  late TextEditingController _capController;
  late TextEditingController _telefonoController;
  final _formKey = GlobalKey<FormState>();
  bool loadingAccess = false;

  void _tryUpdateClient() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        loadingAccess = true;
      });

      UserClient()
          .updateClient(
              widget.cliente.cf,
              _nomeController.text,
              _cognomeController.text,
              _cittaController.text,
              _provinciaController.text,
              _viaController.text,
              _capController.text,
              _telefonoController.text,
              widget.cliente.email,
              widget.cliente.username,
              widget.cliente.password,
              context)
          .then((value) {
        if (value == true) {
          setState(() {
            loadingAccess = true;
          });
          Navigator.pop(context);
          widget.cliente.updateCliente(
            widget.cliente.cf!,
            _nomeController.text,
            _cognomeController.text,
            _cittaController.text,
            _provinciaController.text,
            _viaController.text,
            int.parse(_capController.text),
            int.parse(_telefonoController.text),
            widget.cliente.email!,
            widget.cliente.username!,
            widget.cliente.carrello!,
          );
        } else {
          setState(() {
            loadingAccess = false;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.cliente.nome);
    _cognomeController = TextEditingController(text: widget.cliente.cognome);
    _cittaController = TextEditingController(text: widget.cliente.citta);
    _provinciaController =
        TextEditingController(text: widget.cliente.provincia);
    _viaController = TextEditingController(text: widget.cliente.via);
    _capController = TextEditingController(text: widget.cliente.cap.toString());
    _telefonoController =
        TextEditingController(text: widget.cliente.telefono.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SuperAppBar(
        area: "home_user",
        search: "",
      ),
      body: Center(
        child: SizedBox(
          width: 360,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    maxLength: 20,
                    controller: _nomeController,
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Campo Obbligatorio";
                      }
                      return null;
                    }),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Nome",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _cognomeController,
                    maxLength: 20,
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Campo Obbligatorio";
                      }
                      return null;
                    }),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Cognome",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    controller: _cittaController,
                    maxLength: 20,
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Campo Obbligatorio";
                      }
                      return null;
                    }),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Città",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _provinciaController,
                    maxLength: 15,
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Campo Obbligatorio";
                      }
                      return null;
                    }),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Provincia",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    controller: _viaController,
                    maxLength: 25,
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Campo Obbligatorio";
                      }
                      return null;
                    }),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Via",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _capController,
                    maxLength: 5,
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Campo Obbligatorio";
                      }
                      if (int.tryParse(value) == null) {
                        return "Inserire solo numeri";
                      }
                      if (value.length < 5) {
                        return "CAP errato";
                      }
                      return null;
                    }),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "CAP",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _telefonoController,
                    maxLength: 10,
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Campo Obbligatorio";
                      }
                      if (int.tryParse(value) == null) {
                        return "Inserire solo numeri";
                      }
                      if (value.length < 10) {
                        return "Numero telefonico errato";
                      }
                      return null;
                    }),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Telefono",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (!loadingAccess) {
                            _tryUpdateClient();
                          }
                        },
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.shadow,
                                offset: const Offset(0.0, 1.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: (loadingAccess)
                              ? SpinKitCircle(
                                  size: 20,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return const DecoratedBox(
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                    );
                                  },
                                )
                              : const Text(
                                  "Salva Modifiche",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                          height: 50,
                          width: 150,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      Theme.of(context).colorScheme.error)),
                              onPressed: () {
                                List<String> clients = [];
                                clients.add(widget.cliente.cf!);
                                UserClient().deleteClients(clients, context);
                              },
                              child: const Text(
                                "Elimina Account",
                                style: TextStyle(color: Colors.white),
                              )))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cognomeController.dispose();
    _cittaController.dispose();
    _provinciaController.dispose();
    _viaController.dispose();
    _capController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }
}