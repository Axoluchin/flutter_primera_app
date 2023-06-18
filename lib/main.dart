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

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  var openNav = false;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = CurrenPage();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    setState(() {
                      openNav = !openNav;
                    });
                  },
                  alignment: Alignment.centerLeft),
              extended: openNav,
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
