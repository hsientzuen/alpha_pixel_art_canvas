import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();

  Future<void> _checkUsername() async {
    final String username = _usernameController.text;

    if (username.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your username.')),
        );
      }
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8201/check-username'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      );

      if (mounted) {
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final userId = data['userId'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                  title: 'Pixel Art Canvas',
                  username: username,
                  userId: userId),
            ),
          );
        } else if (response.statusCode == 400) {
          final error = jsonDecode(response.body)['error'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('An error occurred. Please try again.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to check username.')),
        );
      }
    }
  }

  Future<void> _login() async {
    final String username = _usernameController.text;

    if (username.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your username.')),
        );
      }
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8201/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      );

      if (mounted) {
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final userId = data['userId'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                title: 'Pixel Art Canvas',
                username: username,
                userId: userId,
              ),
            ),
          );
        } else if (response.statusCode == 400) {
          final error = jsonDecode(response.body)['error'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('An error occurred. Please try again.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to check username.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixel Art Canvas - Login'),
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _checkUsername,
                    child: const Text('Register'),
                  ),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final String username;
  final int userId;

  const MyHomePage({
    super.key,
    required this.title,
    required this.username,
    required this.userId,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int gridSize = 5;
  List<Color> pixels = List<Color>.filled(gridSize * gridSize, Colors.white);

  Color selectedColor = Colors.black;
  bool isDragging = false;
  void updatePixel(int index) {
    setState(() {
      pixels[index] = selectedColor;
    });
  }

  Future<void> _saveCanvas() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();

        return AlertDialog(
          title: const Text('Save Canvas'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Enter canvas name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String canvasName = nameController.text.trim();
                if (canvasName.isNotEmpty) {
                  String canvasData =
                      jsonEncode(pixels.map((color) => color.value).toList());
                  final response = await http.post(
                    Uri.parse('http://localhost:8201/save-canvas'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({
                      'name': canvasName,
                      'data': canvasData,
                      'user_id': widget.userId
                    }),
                  );

                  if (response.statusCode == 200) {
                    print('Grid saved successfully.');
                  } else {
                    print('Error saving grid.');
                  }
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadCanvas() async {
    final response = await http.get(
        Uri.parse('http://localhost:8201/get-canvas-list/${widget.userId}'));

    if (response.statusCode == 200) {
      List<dynamic> canvases = jsonDecode(response.body);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Load canvases'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                children: canvases.map((canvas) {
                  return ListTile(
                    title: Text(canvas['canvas_name']),
                    onTap: () async {
                      final canvasResponse = await http.get(Uri.parse(
                          'http://localhost:8201/canvas/${canvas['id']}'));

                      if (canvasResponse.statusCode == 200) {
                      // Decode the response as a Map<String, dynamic>
    final Map<String, dynamic> responseBody = jsonDecode(response.body);

    // Get the stringified list from the 'data' field
    String colorData = responseBody['data'];

    // Decode the stringified list into a List<int>
    List<int> colorList = List<int>.from(jsonDecode(colorData));

    setState(() {
      // Map the List<int> to List<Color>
      pixels = colorList.map((color) => Color(color)).toList();
    });
                      }
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    } else {
      print('Error loading grids.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Listener(onPointerDown: (details) {
                  setState(() {
                    isDragging = true;
                    _updatePixelFromPosition(details.localPosition);
                  });
                }, onPointerMove: (details) {
                  if (isDragging) {
                    _updatePixelFromPosition(details.localPosition);
                  }
                }, onPointerUp: (details) {
                  setState(() {
                    isDragging = false;
                  });
                }, child: LayoutBuilder(builder: (context, constraints) {
                  final double gridWidth = constraints.maxWidth / gridSize;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                      crossAxisSpacing: 0.1,
                      mainAxisSpacing: 0.1,
                    ),
                    itemCount: gridSize * (constraints.maxHeight ~/ gridWidth),
                    //itemCount: pixels.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => updatePixel(index),
                        child: Container(
                          color: pixels[index],
                          margin: EdgeInsets.all(0.1),
                        ),
                      );
                    },
                  );
                })),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ElevatedButton(
                      onPressed: _saveCanvas,
                      child: const Text('Save'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ElevatedButton(
                      onPressed: _loadCanvas,
                      child: const Text('Load'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          for (int i = 0; i < pixels.length; i++) {
                            pixels[i] = Colors.white;
                          }
                        });
                      },
                      child: const Text('Clear'),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorSelector(
                    color: Colors.black,
                    isSelected: selectedColor == Colors.black,
                    onTap: () => setState(() => selectedColor = Colors.black),
                  ),
                  ColorSelector(
                    color: Colors.red,
                    isSelected: selectedColor == Colors.red,
                    onTap: () => setState(() => selectedColor = Colors.red),
                  ),
                  ColorSelector(
                    color: Colors.green,
                    isSelected: selectedColor == Colors.green,
                    onTap: () => setState(() => selectedColor = Colors.green),
                  ),
                  ColorSelector(
                    color: Colors.blue,
                    isSelected: selectedColor == Colors.blue,
                    onTap: () => setState(() => selectedColor = Colors.blue),
                  ),
                  // Add more colors as needed
                ],
              ),
            ],
          ),
        ));
  }

  void _updatePixelFromPosition(Offset position) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final size = box.size;
    final gridWidth = size.width;
    final cellSize = gridWidth / gridSize;

    final int x = (position.dx / cellSize).floor();
    final int y = (position.dy / cellSize).floor();

    if (x >= 0 && x < gridSize && y >= 0 && y < gridSize) {
      final index = y * gridSize + x;
      if (index >= 0 && index < pixels.length) {
        updatePixel(index);
      }
    }
  }
}

class ColorSelector extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorSelector({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border:
              isSelected ? Border.all(color: Colors.white, width: 2.0) : null,
        ),
        width: 30,
        height: 30,
      ),
    );
  }
}
