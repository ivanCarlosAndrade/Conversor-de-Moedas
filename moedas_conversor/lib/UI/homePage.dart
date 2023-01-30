import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String request =
      'https://api.hgbrasil.com/finance?format=json-cors&key=4bf040e0';

  Future<Map> getData() async {
    http.Response response = await http.get(Uri.parse(request));
    return json.decode(response.body);
  }

  late double dolar;
  late double euro;
  final realController = TextEditingController();
  final escudoController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }
  _realchanged(String txt) {
    if(txt.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(txt);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    escudoController.text = (real * 110.2 / euro).toStringAsFixed(2);
  }

  _escudochanged(String txt) {
    if(txt.isEmpty) {
      _clearAll();
      return;
    }
    double escudo = double.parse(txt);
    realController.text = (escudo / 110.2 * this.euro).toStringAsFixed(4);
    euroController.text = (escudo / 110.2).toStringAsFixed(4);
    dolarController.text = (escudo*this.euro/(110*this.dolar)).toStringAsFixed(4);
  }

  _eurochanged(String txt) {
    if(txt.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(txt);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    escudoController.text = (110.2).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  _dolarchanged(String txt) {
    if(txt.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(txt);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    escudoController.text =
        (dolar * this.dolar * 110.2 / euro).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversor de moedas'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: Text(
                  'Carregando os dados..',
                  style: TextStyle(fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Carregando os dados..',
                    style: TextStyle(fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data?["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data?["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.green,
                      ),
                      Divider(),
                      buildTextField("Escudos Cabo Verdianos ", "\$00",
                          escudoController, _escudochanged),
                      Divider(),
                      buildTextField(
                          "Reais ", "R\$", realController, _realchanged),
                      Divider(),
                      buildTextField(
                          "Dolar ", "\$", dolarController, _dolarchanged),
                      Divider(),
                      buildTextField(
                          "Euros ", "\€", euroController, _eurochanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
    ;
  }
}

late Function funcao;
buildTextField(
    String label, String prefix, TextEditingController controlle, funcao) {
  return TextField(
    controller: controlle,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.green),
      border: OutlineInputBorder(),
      suffixText: prefix,
    ),
    onChanged: funcao,
    keyboardType: TextInputType.number,
  );
}
