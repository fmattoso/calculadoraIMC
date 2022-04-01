import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora IMC',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.indigo,
      ),
      home: const MyFormPage(title: 'Calculadora IMC'),
    );
  }
}

class MyFormPage extends StatefulWidget {
  const MyFormPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyFormPage> createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = 'Informe os seus dados...';
  String _imcText = 'IMC: ----';

  void _reset() {
    weightController.clear();
    heightController.clear();
    setState(() {
      _infoText = 'Informe os seus dados...';
      _imcText = 'IMC: ----';
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text) / 100.0;
    double imc = weight / (height * height);
    setState(() {
      _imcText = 'IMC: ${imc.toStringAsPrecision(4)}';
      if (imc < 18.6) {
        _infoText = 'Abaixo do Peso';
      } else if (imc >= 18.6 && imc < 24.9) {
        _infoText = 'Peso Ideal';
      } else if (imc >= 24.9 && imc < 29.9) {
        _infoText = 'Levemente Acima do Peso';
      } else if (imc >= 29.9 && imc < 34.9) {
        _infoText = 'Obesidade Grau I';
      } else if (imc >= 34.9 && imc < 39.9) {
        _infoText = 'Obesidade Grau II';
      } else if (imc >= 40) {
        _infoText = 'Obesidade Grau III';
      }
    });
  }

  String? _validForm(String? value, String msg) {
    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return msg;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _reset();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.person_outline,
                  size: 120.0,
                  color: Theme.of(context).textTheme.headline4?.color ??
                      Colors.green,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Peso (kg)',
                    suffixText: 'kg',
                  ),
                  controller: weightController,
                  style: const TextStyle(fontSize: 24.0),
                  validator: (value) {
                    return _validForm(value, 'Insira o seu Peso');
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Altura (cm)',
                    suffixText: 'cm',
                  ),
                  controller: heightController,
                  style: const TextStyle(fontSize: 24.0),
                  validator: (value) {
                    return _validForm(value, 'Insira a sua Altura!');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    _imcText,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Text(
                  _infoText,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _calculate();
          }
        },
        tooltip: 'Calcular',
        child: const Icon(Icons.calculate_outlined),
      ),
    );
  }
}
