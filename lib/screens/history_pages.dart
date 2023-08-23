import 'package:alataf/provider/imge_provider.dart';
import 'package:alataf/screens/product_details_screen.dart';
import 'package:alataf/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/hitory_database.dart';
import '../models/Products.dart';

class HitoryPage extends StatefulWidget {
  const HitoryPage({super.key});

  @override
  State<HitoryPage> createState() => _HitoryPageState();
}

class _HitoryPageState extends State<HitoryPage> {





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Order Histroy"),
          centerTitle: true,

          actions: [
          Consumer<RecipeClass>(

            builder: (BuildContext context, provider, Widget? child) {
              return IconButton(onPressed: (){
                provider.deleteAll();


              }, icon: Icon(Icons.delete));
            }
          )
          ],
        ),
        body: Consumer<RecipeClass>(

          builder: (BuildContext context, provider, Widget? child) {
            return SingleChildScrollView(
              child: Column(
                children: [



                  SizedBox(
                height: 600
                ,child:ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.allRecipes.length,

                      itemBuilder: (context,index){
                        final dataa=provider.allRecipes[index];
                    return  ListTile(
                      title: listItem(context, dataa),


                      onTap: (){

                        setState(() {

                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetails(),
                                settings: RouteSettings(
                                  arguments: dataa,
                                )));
                      },

                    );
                  }),)

                ],
              ),
            );
          }
        )


    );
  }
}

Widget listItem(BuildContext context, ProductItem productItem) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10,),
        Text(productItem.productName ?? "",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(productItem.genericName ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,

                style: TextStyle(fontSize: 10, color: Colors.black87)),
            SizedBox(width: 4),
            Flexible(
              child: Text(productItem.strength ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: <Widget>[
            textViewCategory(context, productItem.categoryName ?? ""),
            Expanded(child: SizedBox()),
            textViewPrice(context, productItem.price),
          ],
        ),
        SizedBox(height: 4),
        Divider(color: Colors.grey),
        SizedBox(
          height: 1,
        )
      ],
    ),
  );
}
