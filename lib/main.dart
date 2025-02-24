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
    _value = min(100, _value + 1);
    notifyListeners();
  }

  void decrement() {
    _value = max(0, _value - 1);
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
    return MaterialApp(title: 'Flutter Demo', home: const MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Color getBackgroundColor(int age) {
    if (age >= 0 && age <= 12) {
      return Colors.lightBlue;
    } else if (age >= 13 && age <= 19) {
      return Colors.lightGreen;
    } else if (age >= 20 && age <= 30) {
      return Colors.limeAccent;
    } else if (age >= 31 && age <= 50) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  String getMessage(int age) {
    if (age >= 0 && age <= 12) {
      return "child";
    } else if (age >= 13 && age <= 19) {
      return "teenager";
    } else if (age >= 20 && age <= 30) {
      return "the dark age";
    } else if (age >= 31 && age <= 50) {
      return "unc";
    } else {
      return "how old am i?";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        return Scaffold(
          backgroundColor: getBackgroundColor(counter.value),
          appBar: AppBar(title: const Text('Age Counter')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getMessage(counter.value),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'I am ${counter.value} years old',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Slider(
                  min: 0,
                  max: 100,
                  value: counter.value.toDouble(),
                  onChanged: (value) {
                    counter.setValue(value);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    counter.increment();
                  },
                  child: Text('Increase Age'),
                ),
                ElevatedButton(
                  onPressed: () {
                    counter.decrement();
                  },
                  child: Text('Reduce Age'),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              counter.increment();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
