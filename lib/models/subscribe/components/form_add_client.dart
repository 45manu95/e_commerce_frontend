// ignore_for_file: unused_field

import 'package:e_commerce_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../access/access.dart';


class FormAddClient extends StatefulWidget {
  const FormAddClient({super.key});

  @override
  State<FormAddClient> createState() => _FormAddClientState();
}

class _FormAddClientState extends State<FormAddClient> {
  final _formKey = GlobalKey<FormState>();
  bool loadingAccess = false;

  var _codiceFiscale = "default_value";
  var _nome = "default_value";
  var _cognome = "default_value";
  var _telefono = "default_value";
  var _via = "default_value";
  var _cap = "default_value";
  var _citta = "default_value";
  var _provincia = "default_value";
  var _email = "default_value";
  var _username = "default_value";
  var _password = "default_value";
  bool _obscureText = true;

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        loadingAccess = true;
      });
      userData.subscribe(_codiceFiscale, _nome, _cognome, _citta, _via, _provincia,int.parse(_cap), int.parse(_telefono), _email, _username, _password, context).then((value) {
        if(value) {
                Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Access(),
          ),
          (route) => false);
        }
        else {
                setState(() {
        loadingAccess = false;
      });
        }
    });

    }
  }

    void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 16,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 16) {
                    return "Minimo 16 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Codice Fiscale",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _codiceFiscale = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 3) {
                    return "Minimo 3 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _nome = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 3) {
                    return "Minimo 3 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Cognome",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _cognome = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 10,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 10) {
                    return "Minimo 10 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Telefono",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _telefono = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 3) {
                    return "Minimo 3 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Via",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _via = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 5,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 5) {
                    return "Minimo 5 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "CAP",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _cap = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 3) {
                    return "Minimo 3 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Città",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _citta = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 3) {
                    return "Minimo 3 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Provincia",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _provincia = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 3) {
                    return "Minimo 3 caratteri";
                  }
                                    const pattern =
                      r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                  final regex = RegExp(pattern);

                  return value.isNotEmpty && !regex.hasMatch(value)
                      ? 'Email invalida'
                      : null;
                }),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 3) {
                    return "Minimo 3 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Nome utente",
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _username = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLength: 20,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 7) {
                    return "Inserisci almeno 8 caratteri";
                  }

                  return null;
                }),
                decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: GestureDetector(
                      onTap: _toggle,
                      child: Icon(
                        (_obscureText)
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                    )),
                obscureText: _obscureText,
                onSaved: (value) {
                  _password = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  print("ciao");
                  if (!loadingAccess) {
                    _trySubmit();
                  }
                },
                child: Container(
                  width: 90,
                  height: 47,
                  margin: const EdgeInsets.only(left: 30),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
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
                          itemBuilder: (BuildContext context, int index) {
                            return const DecoratedBox(
                              decoration: BoxDecoration(color: Colors.white),
                            );
                          },
                        )
                      : const Text(
                          "Aggiungi",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 20,)
            ],
          ),
        ),
      ],
    );
  }
}