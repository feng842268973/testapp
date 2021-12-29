import 'package:flutter/material.dart';
import './routes/photo.dart';
import './routes/contact.dart';
import './routes/settings.dart';
import 'package:web_socket_channel/io.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() {
  // runApp(const MyApp());
  runApp(const MaterialApp(
      title: 'test flutter',
      routes: {
        // "page_photo": (context) =>  const PermissionPhoto(),
        // "page_contact": (context) =>  const FlutterContactsExample(),
        // "page_socket": (context) =>  const SocketPage()
      },
      home: MyStatefulWidget()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Center(
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
    ));
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  var _imgPath;
  final List _widgetOptions = [
    const PermissionPhoto(),
    const FlutterContactsExample(),
    const SettingsPage(),
    // const SocketPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigator.pushNamed(context, _widgetOptions[index]);
    });
  }

  @override
  void initState() {
    super.initState();
    var channel =
        IOWebSocketChannel.connect(Uri.parse('ws://192.168.101.69:8000'));

    channel.stream.listen((message) {
      print(message);
      _takePhoto();
      print('---------');
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
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Camera',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ));
  }
  _takePhoto() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _imgPath = image;
    });
  }
}
