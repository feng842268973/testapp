
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
// 引入Socket.io
class SocketPage extends StatefulWidget {
    const SocketPage({Key ? key}) : super(key: key);
    @override
    _SocketPageState createState() => _SocketPageState();
}

class _SocketPageState extends State<SocketPage> {

    final ScrollController _scrollController = ScrollController();
    List messageList=[];

    @override
    void initState() {
        print(111);
        super.initState();
        var channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.101.69:8000'));

        channel.stream.listen((message) {
          print(message);
          print('---------');
          channel.sink.add('received!');
          channel.sink.close(status.goingAway);
        });


    }


    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Socket.io演示"),
            ),
            body: ListView.builder(
                // 滚动控制器
                controller: _scrollController,
                itemCount: messageList.length,
                itemBuilder: (context,index){
                    return ListTile(
                        title: Text("${messageList[index]}"),
                    );
                },
            ),
        );
    }
}