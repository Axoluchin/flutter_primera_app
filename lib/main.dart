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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random().asPascalCase;
  List<String> likedMessage = [];

  void newWorld() {
    current = WordPair.random().asPascalCase;
    notifyListeners();
  }

  void setLiked() {
    likedMessage.add(current);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = CurrenPage();
        break;
      case 1:
        page = FavoritePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 700,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite_outline),
                    selectedIcon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class CurrenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var wordPair = appState.current;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: CartPair(wordPair: wordPair, appState: appState)),
      ],
    );
  }
}

class CartPair extends StatelessWidget {
  const CartPair({
    super.key,
    required this.wordPair,
    required this.appState,
  });

  final String wordPair;
  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    IconData icon;

    if (appState.likedMessage.contains(wordPair)) {
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
                wordPair,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
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

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var listWords = appState.likedMessage;

    return ListView(
      children: [
        Text(
          "Favoritos",
          style: TextStyle(
              color: Colors.blue, fontSize: 32, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          "Total: ${listWords.length}",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        for (var word in listWords)
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(word)
            ],
          ),
      ],
    );
  }
}
