import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:foodzaab/model/user_model.dart';
import 'package:foodzaab/utility/my_constant.dart';
import 'package:foodzaab/utility/my_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfoShop extends StatefulWidget {
  @override
  _EditInfoShopState createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  UserModel userModel;
  String nameShop, address, phone, urlPicture;
  Location location = Location();
  double lat, lng;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readCurrentInfo();
    location.onLocationChanged.listen((event) {
      setState(() {
        lat = event.latitude;
        lng = event.longitude;
        print('lat = $lat, lng = $lng');
      });
    });
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString('id');
    //print('idShop ==>> $idShop');
    //http://foodzaab.com/foodzaab/getUserWhereId.php?isAdd=true&id=2
    String url =
        '${MyConstant().domain}/foodzaab/getUserWhereId.php?isAdd=true&id=$idShop';

    Response response = await Dio().get(url);
    //print('response ==>> $response');

    var result = json.decode(response.data);
    //print('result ==>> $result');

    for (var map in result) {
      print('map ==>> $map');
      setState(() {
        userModel = UserModel.fromJson(map);
        nameShop = userModel.nameShop;
        address = userModel.address;
        phone = userModel.phone;
        urlPicture = userModel.urlPicture;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserModel == null ? MyStyle().showProgress() : showContent(),
      appBar: AppBar(
        title: Text('ปรับปรุงรายละเอียดร้าน'),
      ),
    );
  }

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: [
            //nameShopForm(),
            nameShop == null
                ? MyStyle().showProgress()
                : nameShopForm(), //ป้องกันการดึง MySQL ช้า
            //showImage(),
            urlPicture == null ? MyStyle().showProgress() : showImage(),
            //addressForm(),
            address == null ? MyStyle().showProgress() : addressForm(),
            //phoneForm(),
            phone == null ? MyStyle().showProgress() : phoneForm(),
            lat == null ? MyStyle().showProgress() : showMap(),
            editButton()
          ],
        ),
      );

  Widget editButton() => Container(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton.icon(
          color: MyStyle().primaryColor,
          onPressed: () {},
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          label: Text(
            'ปรับปรุงข้อมูล',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  Set<Marker> currentMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('myMarker'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
              title: 'ร้านอยู่ที่นี่', snippet: 'Lat = $lat, Lng = $lng'))
    ].toSet();
  }

  Container showMap() {
    CameraPosition cameraPosition =
        CameraPosition(target: LatLng(lat, lng), zoom: 16.0);
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      height: 250,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: currentMarker(),
      ),
    );
  }

  Widget showImage() => Container(
        margin: EdgeInsetsDirectional.only(top: 16.0),
        //width: 250.0,
        //height: 200.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.add_a_photo), onPressed: null),
            Container(
              width: 250.0,
              height: 250.0,
              child: Image.network(urlPicture),
            ),
            IconButton(icon: Icon(Icons.add_photo_alternate), onPressed: null),
          ],
        ),
      );

  Widget nameShopForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => nameShop = value,
              initialValue: nameShop,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ชื่อร้าน',
              ),
            ),
          ),
        ],
      );
  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => address = value,
              initialValue: address,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ที่อยู่',
              ),
            ),
          ),
        ],
      );
  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => phone = value,
              initialValue: phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'เบอร์โทร',
              ),
            ),
          ),
        ],
      );
}
