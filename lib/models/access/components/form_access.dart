import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../main.dart';
import '../../home/home.dart';
import '../../subscribe/subscribe.dart';


class FormAccess extends StatefulWidget {
  const FormAccess({super.key});

  @override
  State<FormAccess> createState() => _FormAccessState();
}

class _FormAccessState extends State<FormAccess> {
  final _formKey = GlobalKey<FormState>();

  var _username = "default value";
  var _userPassword = "default value";
  bool _obscureText = true;
  bool loadingAccess = false;

  int pageNumber = 0;
  int pageSize = 10;
  List<String> filter = [
    "",
    "",
    "",
  ];
  String sort = "barCode";
  String search = "";
  late Uri url;
  String idProduct = "";


  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        loadingAccess = true;
      });
      userData.setParam(_username, _userPassword);
      userData.getAccess(context).then((value) {
        if (value == true) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>  HomePage(userData: userData, pageNumber: pageNumber, pageSize: pageSize, search: search, sort: sort, filter: filter, ),
              ),
              (route) => false);
        } else {
          setState(() {
            loadingAccess = false;
          });
        }
      });
    }
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
                maxLength: 50,
                validator: ((value) {
                  if (value!.isEmpty || value.length < 3) {
                    return "Minimo 3 caratteri";
                  }
                  return null;
                }),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  icon: Icon(Icons.account_circle),
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
                    icon: const Icon(Icons.password),
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
                  _userPassword = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (!loadingAccess) {
                    _trySubmit();
                  }
                },
                child: Container(
                  width: 90,
                  height: 45,
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
                          "Accedi",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
                            const SizedBox(height: 20,),
              Container(margin: const EdgeInsets.only(left: 25), child: const Text("oppure")),
              const SizedBox(height: 20,),
                     GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Subscribe()));
                },
                child: Container(
                  width: 100,
                  height: 50,
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
                  child:const Text(
                          "Registrati",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}