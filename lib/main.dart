import 'package:flutter/material.dart';
import './routes/photo.dart';
import './routes/contact.dart';
import './routes/socket.dart';

void main() {
  // runApp(const MyApp());
  runApp(const MaterialApp(
    title: 'test flutter',
    routes: {
      // "page_photo": (context) =>  const PermissionPhoto(),
      // "page_contact": (context) =>  const FlutterContactsExample(),
      // "page_socket": (context) =>  const SocketPage()
    },
    home: MyStatefulWidget()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key ? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Center (
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: style,
                  onPressed: () {
                    Navigator.pushNamed(context, "page_photo");
                  },
                  child: const Text('去主页'),
                ),
                // const SizedBox(height: 30),
                // ElevatedButton(
                //   style: style,
                //   onPressed: () {
                //     Navigator.pushNamed(context, "page_contact");
                //   },
                //   child: const Text('获取通讯录'),
                // ),
                // const SizedBox(height: 30),
                // ElevatedButton(
                //   style: style,
                //   onPressed: () {
                //     Navigator.pushNamed(context, "page_socket");
                //   },
                //   child: const Text('socket'),
                // ),
              ],
            )
          );

  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({ Key? key }) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List _widgetOptions = [
    // 'page_photo','page_contact','page_socket'
    const PermissionPhoto(),
    const FlutterContactsExample(),
    // const SocketPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigator.pushNamed(context, _widgetOptions[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FlutterDemo')),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      )
    );
  }
}