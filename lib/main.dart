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
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final ValueNotifier<List<String>> _valueNotifier = ValueNotifier([]);
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
            itemCount: value.length + 1,
            itemBuilder: (context, index) {
              return index == value.length
                  ? ListTile(
                      title: TextFormField(
                        autofocus: true,
                        onFieldSubmitted: (value) {
                          _valueNotifier.value = [
                            ..._valueNotifier.value,
                            value
                          ];
                        },
                      ),
                    )
                  : ListTile(
                      title: TextFormField(
                        initialValue: value[index],
                        onFieldSubmitted: (value) {
                          _valueNotifier.value = [
                            ..._valueNotifier.value.sublist(0, index),
                            value,
                            ..._valueNotifier.value.sublist(index + 1)
                          ];
                        },
                      ),
                    );
            },
          );
        },
      ),
    );
  }
}
