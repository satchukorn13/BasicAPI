import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:layout/pages/detail.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class HomePage extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sport News"),

        // icon ด้านบน ลุงไม่ได้สอน
        actions: [
          Icon(Icons.refresh),
          SizedBox(width: 15),
          Icon(Icons.menu),
          SizedBox(width: 15),
        ],
        backgroundColor: Colors.red,
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder(
            builder: (context, AsyncSnapshot snapshot) {
              //var data = json.decode(snapshot.data.toString());
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return MyBox(
                      snapshot.data[index]['title'],
                      snapshot.data[index]['subtitle'],
                      snapshot.data[index]['image_url'],
                      snapshot.data[index]['detail']);
                },
                itemCount: snapshot.data.length,
              );
            },
            future: getData(),
            //future: DefaultAssetBundle.of(context).loadString('assets/data.json'),
          )),

      ////////////ปุ่มกดด้านล่าง//////////////
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "หน้าแรก"),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: "คำนวณ"),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: "ติดต่อเรา"),
        ],
      ),
      /////////////////////////////////////////
    );
  }

  Widget MyBox(String title, String subtitle, String image_url, String detail) {
    var v1, v2, v3, v4;
    v1 = title;
    v2 = subtitle;
    v3 = image_url;
    v4 = detail;
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(25),
      height: 210,
      decoration: BoxDecoration(
          //พิ้นที่สำหรับแต่งแตก
          borderRadius: BorderRadius.circular(20),
          // ใส่รูปภาพ
          image: DecorationImage(
            image: NetworkImage(
              image_url,
            ),
            fit: BoxFit.cover, //ทำให้ภาพเท่ากับ box ที่เรากำหนดใน container
            //เป็นการปรับแต่งสี
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.50), BlendMode.darken),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              offset: Offset(3, 3),
              blurRadius: 3,
              spreadRadius: 0,
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          SizedBox(height: 10),
          TextButton(
              onPressed: () {
                print("Next Page >>>");
                //ให้ไปยังหน้าถัดไป
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(v1, v2, v3, v4)));
              },
              child: Text("อ่านต่อ..."))
        ],
      ),
    );
  }

  // เป็นฟังก์ชั่นในการดาวโหลดข้อมูล
  Future getData() async {
    var url = Uri.https(
        'raw.githubusercontent.com', '/satchukorn13/BasicAPI/main/data.json');
    var response = await http.get(url);
    var result = json.decode(response.body);
    return result;
  }
}
