import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ValueNotifier<List<String>> _valueNotifier = ValueNotifier([" "]);
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _valueNotifier,
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              return index == value.length - 1
                  ? ListTile(
                      title: TextFormField(
                        autofocus: true,
                        controller: _controller,
                        onFieldSubmitted: (value) {
                          _valueNotifier.value = [
                            ..._valueNotifier.value,
                            value
                          ];
                        },
                        onEditingComplete: () {
                          if (validateCode(_controller.text)) {
                            _valueNotifier.value = [
                              ..._valueNotifier.value,
                              _controller.text,
                              " "
                            ];
                            _controller.clear();
                          } else {}
                        },
                        onChanged: (value) {
                          if (validateCode(value)) {
                            insertNewCode(value);
                          }
                        },
                      ),
                    )
                  : ListTile(
                      title: TextFormField(
                        initialValue: value[index],
                        readOnly: true,
                        onFieldSubmitted: (value) {
                          // _valueNotifier.value = [
                          //   ..._valueNotifier.value.sublist(0, index),
                          //   value,
                          //   ..._valueNotifier.value.sublist(index + 1)
                          // ];
                        },
                      ),
                    );
            },
          );
        },
      ),
    );
  }

  Timer? _timer;

  void insertNewCode(String newCode) {
    final codes = [..._valueNotifier.value];
    final previousCodes = codes.last;
    //replace the last code if have identical code with prefix newCode
    //else add newCode to the end of the list
    if (newCode.startsWith(previousCodes)) {
      _timer?.cancel();
      _timer = null;
      codes[codes.indexOf(previousCodes)] = newCode;
      _timer = Timer(const Duration(milliseconds: 500), () {
        codes.add(" ");
        _timer = null;
      });
    } else {
      codes.add(newCode);
    }
  }
}

bool validateCode(String code) {
  // example of code : 2212T00252K-AMB2311-10329
  // example of code : 2212T00269K-AMB2311-07693
  // using regex to validate squence of code with minium length is 15
  // and 2 chars at first is digit of year and next 2 chars is digit of month
  // and contains one K- and next of K- is 3 chars is capital letter

  RegExp regExp = RegExp(r"^\d{2}\d{2}T\d{5}K-[A-Z]{3}\d{4}");

  return regExp.hasMatch(code);
}
