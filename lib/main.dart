import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Mi primera app by Axoluchin',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 139, 165, 248)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var liked = false;

  void newWorld() {
    current = WordPair.random();
    liked = false;
    notifyListeners();
  }

  void setLiked() {
    liked = true;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var wordPair = appState.current;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: CartPair(wordPair: wordPair, appState: appState)),
        ],
      ),
    );
  }
}

class CartPair extends StatelessWidget {
  const CartPair({
    super.key,
    required this.wordPair,
    required this.appState,
  });

  final WordPair wordPair;
  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    IconData icon;

    if (appState.liked) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_outline;
    }

    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                wordPair.asPascalCase,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Divider(),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FilledButton(
                        onPressed: () {
                          appState.newWorld();
                        },
                        child: Text('Cambiar palabra')),
                    SizedBox(width: 32),
                    FilledButton.tonalIcon(
                      onPressed: () {
                        appState.setLiked();
                      },
                      icon: Icon(icon, color: Colors.blue),
                      label: Text('Like'),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
