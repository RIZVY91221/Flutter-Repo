import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crud/models/product.dart';
import 'package:flutter_crud/page/Details.dart';
import 'package:http/http.dart' as http;

void main() async {
  runApp(MaterialApp(
    home: Scaffold(

      body: Home(),
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> item;

  final controlItemCode= TextEditingController();
  final controlItemName= TextEditingController();
  final controlItemPrice= TextEditingController();
  final controlItemStock= TextEditingController();
  Future<List> getData() async {
    final respond =
        await http.get("http://10.0.3.2/product_store/getdata.php");
    //List rowData=
    //debugPrint(rowData.toString());
    return json.decode(respond.body);
  }
  void handleItemStore(String itemcode,String itemname,String price,String stock)async{
    var url="http://10.0.3.2/product_store/adddata.php";

    http.post(url,body: {
      "item_code":itemcode,
      "item_name":itemname,
      "price" :price,
      "stock" :stock
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Crud"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>_ShowFromDialog(context),
      ),
      body: new FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            print(snapshot.data.toString());
            return snapshot.hasData
                ? ItemList(
                    list: snapshot.data,
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );

          }),
    );

  }
  void _ShowFromDialog(BuildContext context) {
    var alert = new AlertDialog(
      content: new Column(
        children: <Widget>[
          Expanded(
                child:TextField(
                controller: controlItemCode,
                autocorrect: true,
                cursorColor: Colors.red,
                decoration: new InputDecoration(
                  hintText: "Code",
                  labelText: "Item Code:",
                  icon: new Icon(Icons.code),
                ),
              )),
          Expanded(
              child:TextField(
                controller: controlItemName,
                autocorrect: true,
                cursorColor: Colors.red,
                decoration: new InputDecoration(
                  hintText: "Name",
                  labelText: "Item Name:",
                  icon: new Icon(Icons.note),
                ),
              )),
          Expanded(
              child:TextField(
                controller: controlItemPrice,
                autocorrect: true,
                cursorColor: Colors.red,
                decoration: new InputDecoration(
                  hintText: "Price",
                  labelText: "Item Price:",
                  icon: new Icon(Icons.attach_money),
                ),
              )),
          Expanded(
              child:TextField(
                controller: controlItemStock,
                autocorrect: true,
                cursorColor: Colors.red,
                decoration: new InputDecoration(
                  hintText: "Stock",
                  labelText: "Total Stock:",
                  icon: new Icon(Icons.store),
                ),
              )),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
               handleItemStore(controlItemCode.text, controlItemName.text, controlItemPrice.text, controlItemStock.text);
               controlItemCode.clear();
               controlItemName.clear();
               controlItemPrice.clear();
               controlItemStock.clear();
              Navigator.pop(context);
            },
            child: new Text("Save")),
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: new Text(
              "Cancel",
              style: new TextStyle(color: Colors.red),
            ))
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }


}

class ItemList extends StatelessWidget {
  List list;

  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return Container(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Details(list: list, index: i,)));
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(list[i]['item_name']),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: new Text(
                          list[i]["item_code"][0].toString().toUpperCase(),
                          style: new TextStyle(
                              fontSize: 16.7,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      subtitle: Text("Stock:${list[i]['stock']}"),
                    ),

                  )));
        });
  }

}
