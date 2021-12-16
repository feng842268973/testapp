import 'package:flutter/material.dart';


// 引入Socket.io
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class SocketPage extends StatefulWidget {
    const SocketPage({Key ? key}) : super(key: key);
    @override
    _SocketPageState createState() => _SocketPageState();
}

class _SocketPageState extends State<SocketPage> {

    final ScrollController _scrollController = ScrollController();
    late IO.Socket socket;
    List messageList=[];

    @override
    void initState() {
        print(111);
        super.initState();
      //   IO.Socket socket = IO.io('http://localhost:3000',
      //   OptionBuilder()
      // .setTransports(['websocket']).setExtraHeaders({'foo': 'bar'}) // optional
      // .build());
      //   socket.onConnect((_) {
      //     print('connect');
      //     socket.emit('msg', 'test');
      //   });
      //   socket.on('event', (data) => print(data));
      //   socket.onDisconnect((_) => print('disconnect'));
      //   socket.on('fromServer', (_) => print(_));
    }


    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Socket.io演示"),
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: (){
                    // 发送数据到服务端
                    socket.emit('toServer',{
                        "username":'aiguangyuan',
                        "age":18
                    });
                },
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