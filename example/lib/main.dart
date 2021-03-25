import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:showcased/showcase.dart';
import 'package:showcased/showcase_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onStart: (index, key) {
        print('onStart: $index, $key');
      },
      onComplete: (index, key) {
        print('onComplete: $index, $key');
      },
      builder: Builder(builder: (context) => MainPage()),
      autoPlay: false,
      autoPlayDelay: Duration(seconds: 3),
      autoPlayLockEnable: false,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  GlobalKey _one = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ShowCaseWidget.of(context)!.startShowCase([_one]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 5,
        children: List.generate(
          50,
          (index) {
            var card = Card(
              child: Center(child: Text('LOL')),
            );
            return index == 49
                ? Showcase(
                    key: _one,
                    title: 'Menu',
                    description: 'Click here to see menu options' * 3,
                    child: card,
                  )
                : card;
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
