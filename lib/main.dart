import 'package:flutter/material.dart';

void main() {
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
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(PixelArtCanvas());
// }

// class PixelArtCanvas extends StatelessWidget {
//   const PixelArtCanvas({super.key});
//   @override
//   Widget build(BuildContext context) {
//     // return MaterialApp(
//     //   title: 'Pixel Art Canvas',
//     //   home: Scaffold(
//     //     appBar: AppBar(title: Text('Pixel Art Canvas')),
//     //     body: PixelCanvas(),
//     //   ),
//     // );
//     return MaterialApp(
//       title: 'Pixel Art Canvas',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Pixel Art Canvas'),
//     );
//   }
// }

// class PixelCanvas extends StatefulWidget {
//   const PixelCanvas({super.key});

//   @override
//   _PixelCanvasState createState() => _PixelCanvasState();
// }

// class _PixelCanvasState extends State<PixelCanvas> {
//   static const int gridSize = 16; // Grid dimensions (16x16)
//   List<Color> pixels = List<Color>.filled(gridSize * gridSize, Colors.white);

//   Color selectedColor = Colors.black; // Default drawing color

//   void updatePixel(int index) {
//     setState(() {
//       pixels[index] = selectedColor;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: gridSize,
//             ),
//             itemCount: pixels.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () => updatePixel(index),
//                 child: Container(
//                   color: pixels[index],
//                   margin: EdgeInsets.all(1.0),
//                 ),
//               );
//             },
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ColorSelector(
//               color: Colors.black,
//               isSelected: selectedColor == Colors.black,
//               onTap: () => setState(() => selectedColor = Colors.black),
//             ),
//             ColorSelector(
//               color: Colors.red,
//               isSelected: selectedColor == Colors.red,
//               onTap: () => setState(() => selectedColor = Colors.red),
//             ),
//             ColorSelector(
//               color: Colors.green,
//               isSelected: selectedColor == Colors.green,
//               onTap: () => setState(() => selectedColor = Colors.green),
//             ),
//             ColorSelector(
//               color: Colors.blue,
//               isSelected: selectedColor == Colors.blue,
//               onTap: () => setState(() => selectedColor = Colors.blue),
//             ),
//             // Add more colors as needed
//           ],
//         ),
//       ],
//     );
//   }
// }

// class ColorSelector extends StatelessWidget {
//   final Color color;
//   final bool isSelected;
//   final VoidCallback onTap;

//   ColorSelector({
//     required this.color,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.all(4.0),
//         decoration: BoxDecoration(
//           color: color,
//           shape: BoxShape.circle,
//           border: isSelected
//               ? Border.all(color: Colors.white, width: 2.0)
//               : null,
//         ),
//         width: 30,
//         height: 30,
//       ),
//     );
//   }
// }
