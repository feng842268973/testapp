import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';



class PermissionDemo extends StatefulWidget {
  const PermissionDemo({Key ? key}) : super(key: key);

  @override
  _PermissionDemoState createState() {
    return _PermissionDemoState();
  }
}

class _PermissionDemoState extends State<PermissionDemo> {
  @override
  void initState () {
    
    var image = getAlbum();
    
    print(image);
    print(111111);
    super.initState();
  }

  getAlbum() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
        // success
        
    } else {
        // fail
        /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }
  @override
  void dispose() {
    super.dispose();
  }

  void checkPermission() async {
    Permission permission = Permission.storage;
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

  void checkPermission2() async {
    requestPermissions();
  }

  void requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();
    print('位置权限：${statuses[Permission.location]}');
    print('存储权限：${statuses[Permission.storage]}');

  }
  
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('FlutterDemo')),
          body: Center(
            child: Column(
              children: <Widget>[
                OutlinedButton(onPressed: () {
                  checkPermission();
                }, child: const Text('申请权限存储权限')),
                OutlinedButton(onPressed: () {
                  checkPermission2();
                }, child: const Text('多权限申请'))
              ],
            ),
          )
        ));
  }
}