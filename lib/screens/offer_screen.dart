import 'package:alataf/bloc/OfferBloc.dart';
import 'package:alataf/models/AdvertisementData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final spinLoader = SpinKitCircle(
  color: Colors.orange,
  size: 50.0,
);

class Offer extends StatefulWidget {
  @override
  OfferState createState() {
    return OfferState();
  }
}

class OfferState extends State<Offer> {
  OfferBloc _offerBloc = OfferBloc();

  @override
  void initState() {
    super.initState();
    _offerBloc.callAdvertisementAPI("");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Offers", style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: StreamBuilder(
              stream: _offerBloc.streamAdvertisementData$,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: listItemView(snapshot.data[index]),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  );
                } else {
                  return StreamBuilder(
                      stream: _offerBloc.streamLoader$,
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          if (!snapshot.data) {
                            return Container(
                              child: Center(
                                  child: Text("Offer is not available now")),
                            );
                          } else {
                            return Center(child: spinLoader);
                          }
                        } else
                          return Center(
                            child: spinLoader,
                          );
                      });
                }
              }),
        ),
      ),
    );
  }

  Widget listItemView(Insert product) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              print(product.url);
            },
            child: FadeInImage.assetNetwork(
                height: 150,
                width: double.infinity,
                placeholder: 'assets/images/medicine.jpg',
                image: product.imageUrl ?? "assets/images/medicine.jpg",
                fit: BoxFit.contain),
          ),
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              Text(product.name ?? "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              Expanded(child: SizedBox()),
            ],
          ),
          SizedBox(height: 8),
          Divider(
            color: Colors.black87,
          ),
        ],
      ),
    );
  }

  Widget closeButton(BuildContext context, int productId) {
    return CircleAvatar(
      backgroundColor: Colors.black12,
      radius: 16,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.delete,
          size: 20,
          color: Colors.black54,
        ),
        color: Colors.black87,
        onPressed: () {},
      ),
    );
  }
}
