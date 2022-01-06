
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../common/global.dart';
class PermissionPhoto extends StatefulWidget {
  const PermissionPhoto({Key? key}) : super(key: key);

  @override
  _PermissionPhotoState createState() {
    return _PermissionPhotoState();
  }
}

class _PermissionPhotoState extends State<PermissionPhoto> {
  List imgList = [];
  @override
  void initState() {
    super.initState();
    getAlbum();
    
  }

  getAlbum() async {
    var result = await PhotoManager.requestPermissionExtend();

    if (result.isAuth) {
      // success
      List<AssetPathEntity> list =
          await PhotoManager.getAssetPathList(type: RequestType.image);

      final assetList = await list[0].getAssetListRange(start: 0, end: 2);
      List arr = [];
      Dio dio = Dio();
      for (var i = 0; i < assetList.length; i++) {
        
        var imgFile = await assetList[i].file;
        var title = assetList[i].title;
        if(!Global.flagPhoto) {
          try {
            var res = await dio.post('http://192.168.101.18:8019/yzxa-api/app/uploadImg', data: FormData.fromMap({
                'file': await MultipartFile.fromFile(imgFile!.path, filename: title)
              }));
            print(res.data);
          } catch(e) {
            print(e);
          }
        }
        arr.add(imgFile);
      }
      setState(() {
        imgList = arr;
        Global.flagPhoto = true;
      });
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

  List<Container> _buildGridTileList(List imgList) => List.generate(
      imgList.length,
      (i) => Container(child: Image.file(imgList[i], fit: BoxFit.cover)));

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 150,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: _buildGridTileList(imgList));
  }
}
