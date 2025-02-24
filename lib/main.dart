import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(
        Rect.fromCenter(
          center: screen!.frame.center,
          width: windowWidth,
          height: windowHeight,
        ),
      );
    });
  }
}

class Counter with ChangeNotifier {
  int _value = 0;

  int get value => _value;

  void increment() {
    _value += 1;
    notifyListeners();
  }

  void decrement() {
    _value -= 1;
    notifyListeners();
  }

  void setValue(double newValue) {
    _value = newValue.toInt();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  static List<String> milestones = [
    "Baby",
    "Child",
    "Teenager",
    "The Dark Ages",
    "About time for Fatherhood",
    "Unc",
    "Retirement",
    "How Old am I?",
  ];
  String findMilestones(int value) {
    if (value < 20) {
      return milestones[((7 + value) ~/ 10).clamp(0, 2)];
    } else {
      return milestones[min(milestones.length - 1, (value ~/ 10) + 1)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Age counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<Counter>(
              builder:
                  (context, counter, child) =>
                      Text(findMilestones(counter.value)),
            ),
            Consumer<Counter>(
              builder:
                  (context, counter, child) => Text(
                    ' I am ${counter.value} years old',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
            ),
            Consumer<Counter>(
              builder:
                  (context, counter, child) => Slider(
                    min: 0,
                    max: 100,
                    value: counter.value.toDouble(),
                    onChanged: (value) {
                      counter.setValue(value);
                    },
                  ),
            ),
            ElevatedButton(
              onPressed: () {
                var counter = context.read<Counter>();
                counter.increment();
              },
              child: Text('Increase Age'),
            ),
            ElevatedButton(
              onPressed: () {
                var counter = context.read<Counter>();
                counter.decrement();
              },
              child: Text('Reduce Age'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var counter = context.read<Counter>();
          counter.increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
