import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tf_async_progress_dialog/tf_async_progress_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final result = await showAsyncProgressDialog(
                context: context,
                dialog: TfAsyncProgressDialog<bool>(
                  demoProcess,
                  message: const Text('In progress...'),
                ),
              );
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Success: $result')));
            } catch (e) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Failed: $e')));
            }
          },
          child: const Text('Proceed'),
        ),
      ),
    );
  }

  Future<bool> demoProcess() async {
    final task = Future.delayed(const Duration(seconds: 2));
    await task;
    // for exception handling demo
    final shouldThrowError = Random().nextInt(3) == 0;
    if (shouldThrowError) {
      throw "demo error";
    }
    return true;
  }
}
