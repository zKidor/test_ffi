import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:testffi/platform.dart';
import '';
import 'generated_bindings.dart';

void main() {
  //FFIPlatform.ffi_Dart_InitializeApiDL();
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  FFIPlatform platform = FFIPlatform();

  @override
  void initState() {
    // TODO: implement initState
    // lib = NativeLibrary(Platform.isAndroid
    //     ? DynamicLibrary.open('libnative_add.so')
    //     : DynamicLibrary.process());

    platform.init(ffiCallback);
    super.initState();
  }

  Future<ByteData> ffiCallback(ByteData? data) async {
    print('ffiCallback');
    if (data != null) {
      print('res ${utf8.decode(data.buffer.asUint8List())}');
    }

    return ByteData(0);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Text(
                'FFI:',
              ),
              TextButton(
                onPressed: () async {
                  var start = DateTime.now().millisecondsSinceEpoch;
                  _counter = FFIPlatform.lib.native_add(1, 2);
                  print(DateTime.now().millisecondsSinceEpoch - start);
                  print('native add $_counter');
                  setState(() {});
                },
                child: Text('native add'),
              ),
              TextButton(
                onPressed: () async {
                  var res = FFIPlatform.lib.create_coordinate(100, 200);
                  print('native struct ${res.ref}');
                },
                child: Text('native struct'),
              ),
              TextButton(
                onPressed: () async {
                  var res = FFIPlatform.lib.getText(100);
                  print('native struct ${res}');
                },
                child: Text('native class'),
              ),
              const Text(
                'Method channel:',
              ),
              TextButton(
                onPressed: () async {
                  platform.setJniRef();
                  print('setJniRef');
                },
                child: Text('setJniRef'),
              ),
              TextButton(
                onPressed: () async {
                  platform.emitMsg(_counter);
                  print('emitMsg');
                },
                child: Text('emitMsg'),
              ),
              TextButton(
                onPressed: () async {
                  var start = DateTime.now().millisecondsSinceEpoch;
                  int res = await platform.nativeAddMethodChanel(100, 201);
                  print(DateTime.now().millisecondsSinceEpoch - start);
                  print('native add method channel res $res');
                },
                child: Text('native add method channel'),
              ),
              const Text(
                'FFI isolate:',
              ),
              TextButton(
                onPressed: () async {
                  var start = DateTime.now().millisecondsSinceEpoch;
                  var res =
                      await compute(FFIPlatform.nativeAdd, Point(100, 201));
                  print(DateTime.now().millisecondsSinceEpoch - start);
                  print('compute res $res');
                },
                child: Text('compute'),
              ),
              TextButton(
                onPressed: () async {
                  var start = DateTime.now().millisecondsSinceEpoch;
                  final lb = await loadBalancer;
                  int res = await lb.run<int, Point<int>>(
                      FFIPlatform.nativeAdd, Point(101, 201));
                  print(DateTime.now().millisecondsSinceEpoch - start);
                  print('loader balance res $res');
                },
                child: Text('loader balance'),
              ),
              TextButton(
                onPressed: () async {
                  var start = DateTime.now().millisecondsSinceEpoch;
                  int res = await FFIPlatform.nativeAddCallback(11, 22, Pointer.fromFunction<Void Function(Int)>(call));
                  print(DateTime.now().millisecondsSinceEpoch - start);
                  print('c callback dart res $res');
                },
                child: Text('c callback dart'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  static void call(int res){
    print("dart callback $res ");
  }
}
