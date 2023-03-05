import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_widget/image_widget.dart';

const _imgTest =
    'https://images.unsplash.com/photo-1661041524618-220a2a2b8b74?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=986&q=81';

void main() {
  ImageWidget.errorWidgetBuilder = () => const ImageWidget(_imgTest);

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Image Widget Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final linkCtr = TextEditingController(text: _imgTest);

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final images = <String>[
      'https://photo.tuchong.com/14649482/f/601672690.jpg',
      'https://photo.tuchong.com/17325605/f/641585173.jpg',
      'https://photo.tuchong.com/3541468/f/256561232.jpg',
      'https://photo.tuchong.com/16709139/f/278778447.jpg',
      'This is an video',
      'https://photo.tuchong.com/5040418/f/43305517.jpg',
      'https://photo.tuchong.com/3019649/f/302699092.jpg',
    ];

    final widgetOptions = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          const ImageWidget(
            'https://images.unsplash.com/photo-1661041524618-220a2a2b8b7.png',
            width: 100,
            height: 50,
          ),
          CupertinoTextField(
            clearButtonMode: OverlayVisibilityMode.editing,
            controller: linkCtr,
            onChanged: (value) {
              if (value.isEmpty || !value.contains('http')) {
                return;
              }

              setState(() {});
            },
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (linkCtr.text.isNotEmpty)
            ImageWidget(
              '${linkCtr.text}v=${DateTime.now().microsecondsSinceEpoch}',
              width: 400,
              height: 300,
            ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ImageListsWidget(
            images: [
              ImageInfoData(
                'https://photo.tuchong.com/5040418/f/43305517.jpg?v=2',
                1,
                'caption',
                'image',
              ),
            ],
            aspectRatio: 376 / 252,
          ),
          Expanded(
            child: ImageListsWidget(
              images: images
                  .map((e) => ImageInfoData(e, null, 'caption', 'image'))
                  .toList(),
              isShowTitle: true,
            ),
          ),
        ],
      ),
      CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.amber,
            title: Text('sliverlist'),
            expandedHeight: 30,
            collapsedHeight: 150,
          ),
          const SliverAppBar(
            backgroundColor: Colors.green,
            title: Text('Have a nice day'),
            floating: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == 0) {
                  return ImageListsWidget(
                    images: images
                        .map((e) => ImageInfoData(e, null, 'cap', 'image'))
                        .toList(),
                  );
                }
                return Card(
                  margin: const EdgeInsets.all(15),
                  child: Container(
                    color: Colors.blue[100 * (index % 9 + 1)],
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      'Item $index',
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                );
              },
              childCount: 1000, // 1000 list items
            ),
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Image Widget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Image list',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'SliverList',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
