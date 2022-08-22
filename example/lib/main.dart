import 'package:flutter/material.dart';
import 'package:imagewidget/imagewidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: const MyHomePage(title: 'Image Widget Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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

  final linkCtr = TextEditingController(
      text:
          'https://images.unsplash.com/photo-1661041524618-220a2a2b8b74?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=986&q=81');

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> images = <String>[
      'https://photo.tuchong.com/14649482/f/601672690.jpg',
      'https://photo.tuchong.com/17325605/f/641585173.jpg',
      'https://photo.tuchong.com/3541468/f/256561232.jpg',
      'https://photo.tuchong.com/16709139/f/278778447.jpg',
      'This is an video',
      'https://photo.tuchong.com/5040418/f/43305517.jpg',
      'https://photo.tuchong.com/3019649/f/302699092.jpg'
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          TextFormField(
            controller: linkCtr,
            onChanged: (value) {
              setState(() {});
            },
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headline4,
          ),
          if (linkCtr.text.isNotEmpty)
            ImageWidget(
              linkCtr.text,
              width: 400,
              height: 300,
            ),
          Expanded(
            child: GridView.builder(
              primary: false,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                final String url = images[index];
                return GestureDetector(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Hero(
                      tag: url,
                      child: url == 'This is an video'
                          ? Container(
                              alignment: Alignment.center,
                              child: const Text('This is an video'),
                            )
                          : ImageWidget(
                              url,
                              width: 300,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        barrierColor: Colors.transparent,
                        barrierDismissible: true,
                        pageBuilder: (c, a1, a2) => SlidePage(
                          url: url,
                        ),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: const Duration(milliseconds: 200),
                      ),
                    );
                  },
                );
              },
              itemCount: images.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
