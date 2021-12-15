import 'package:flutter/material.dart';
import './routes/photo.dart';
void main() {
  // runApp(const MyApp());
  runApp(MaterialApp(
    title: 'test flutter',
    routes: {
      "page_photo": (context) =>  const PermissionDemo()
    },
    home: Scaffold(
      appBar: AppBar(title: const Text('FlutterDemo')),
        body: const MyApp()
    )
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
                  child: const Text('获取相册'),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: style,
                  onPressed: () {

                  },
                  child: const Text('获取通讯录'),
                ),
              ],
            )
          );

  }
}
