import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;

class Details extends StatefulWidget {
  List list;
  int index;


  Details({this.list, this.index});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  TextEditingController controlItemCode;
  TextEditingController controlItemName;
  TextEditingController controlPrice;
  TextEditingController controlStock;
  @override
  void initState() {
    controlItemCode=TextEditingController(text: widget.list[widget.index]['item_code']);
    controlItemName=TextEditingController(text: widget.list[widget.index]['item_name']);
    controlPrice=TextEditingController(text: widget.list[widget.index]['price']);
    controlStock=TextEditingController(text: widget.list[widget.index]['stock']);

    super.initState();
  }
  void editData(String itemCode,String itemName,String price,String stock )async{
    var url="http://10.0.3.2/product_store/editdata.php";
    http.post(url,body: {
      "id":widget.list[widget.index]['id'],
      "item_code":itemCode,
      "item_name":itemName,
      "price" :price,
      "stock" :stock
    });
  }
  void deleteData()async{
    var url="http://10.0.3.2/product_store/deleteData.php";
      http.post(url,body:{
      "id" : widget.list[widget.index]['id'],
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.list[widget.index]["item_code"]}"),
      ),
      body: Container(
        height: 270.0,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Card(
          elevation: 5.5,
          child:Center(
            child:Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.edit),onPressed: (){
                         _ShowFromDialog(context);

                      },)
                    ],
                  ),
                  Text(widget.list[widget.index]["item_name"],style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
                  Text("Code:  ${widget.list[widget.index]["item_code"]}",style: TextStyle(fontSize: 18.0),),
                  Text("price:  ${widget.list[widget.index]["price"]}",style: TextStyle(fontSize: 18.0),),
                  Text("Stock:  ${widget.list[widget.index]["stock"]}",style: TextStyle(fontSize: 18.0),),
                  Padding(padding: const EdgeInsets.only(top: 20.0),),

                  FlatButton(onPressed: ()=>confirmDelete(context),
                    color: Colors.red,
                  child: Text("Delete Item",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),)


                ],
              ),
          )
        ),
      ),
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
                controller: controlPrice,
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
                controller:controlStock,
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
            onPressed: () async {
              editData(controlItemCode.text, controlItemName.text, controlPrice.text, controlStock.text);
              controlItemCode.clear();
              controlItemName.clear();
              controlPrice.clear();
              controlStock.clear();
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>Home()));

            },
            child: new Text("Update")),
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

  void confirmDelete(BuildContext context){
    var alert=new AlertDialog(
      content: Text("Are You want to Delete ${widget.list[widget.index]['item_name']} ?"),

      actions: <Widget>[
        FlatButton(
          onPressed: (){
            deleteData();
            Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (BuildContext context)=> new Home(),
                ));
          },
          child: Text("Delete",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
        ),
        FlatButton(
          onPressed: ()=>Navigator.pop(context),
          child: Text("Cancel",style: TextStyle(color: Colors.lightGreen,fontWeight: FontWeight.bold),),
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context)=>alert);
  }
}
