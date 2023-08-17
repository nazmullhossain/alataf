import 'dart:io' show Platform;

import 'package:alataf/bloc/CartDetailsBloc.dart';
import 'package:alataf/bloc/HomeBloc.dart';
import 'package:alataf/bloc/MainBloc.dart';
import 'package:alataf/bloc/OfferBloc.dart';
import 'package:alataf/main.dart';
import 'package:alataf/models/AdvertisementData.dart';
import 'package:alataf/models/CartItem.dart';
import 'package:alataf/screens/aboutus_screen.dart';
import 'package:alataf/screens/cart_details_screen.dart';
import 'package:alataf/screens/login_screen.dart';
import 'package:alataf/screens/message_screen.dart';
import 'package:alataf/screens/offer_screen.dart';
import 'package:alataf/screens/order_history_screen.dart';
import 'package:alataf/screens/prescription_upload_screen.dart';
import 'package:alataf/screens/profile_screen.dart';
import 'package:alataf/screens/search_screen.dart';
import 'package:alataf/screens/testimage_upload_page.dart';
import 'package:alataf/screens/upload_prescription_screen.dart';
import 'package:alataf/utilities/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import 'package:url_launcher/url_launcher.dart';

import '../bloc/SearchBloc.dart';
import '../bloc/test_search_block.dart';
import '../models/info_model.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with WidgetsBindingObserver {
  CartDetailsBloc? _cartDetailsBloc;
  HomeBloc _homeBloc = HomeBloc();
  final CarouselController carouselController = CarouselController();
  final _formKey = GlobalKey<FormState>();
  bool isLoggedIn = false;
  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //
  // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  // print('Running on ${androidInfo.model}');  // e.g. "Moto G (4)"
  //
  // IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  // print('Running on ${iosInfo.utsname.machine}');  // e.g. "iPod7,1"
  //
  // WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
  // print('Running on ${webBrowserInfo.userAgent}');
  int currentIndex = 0;
  final List<String> imgList = [
    'assets/images/medicine.jpg',
    'https://images.unsplash.com/photo-1592100231805-768633151f65?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  ];
  var _osVersion = "";
  var _deviceName = "";
  var _model = "";

  Future<void> AndroidDeviceInformation() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      await deviceInfo.androidInfo.then((androidInfo) {
        setState(() {
          _osVersion = androidInfo.version.release ?? "";
          _deviceName = androidInfo.brand ?? "";
          _model = androidInfo.model ?? "";
          print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
          print(
              "types-----------> ${androidInfo.version.release} ${androidInfo.brand} ");
        });
      });
    } catch (e) {
      print(e);
    }
  }

  IosDeviceInformation() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      await deviceInfo.iosInfo.then((iosInfo) {
        _osVersion = iosInfo.systemVersion ?? "";
        _deviceName = iosInfo.name ?? "";
        _model = iosInfo.model ?? "";
        print('Running on ${iosInfo.utsname.machine}');
      });
    } catch (e) {
      print(e);
    }
  }

  static sliderImage(String item, BuildContext context) {
    if (item.contains("http")) {
      print("Remote True");
      return FadeInImage.assetNetwork(
          width: MediaQuery.of(context).size.width * 0.7,
          placeholder: 'assets/images/medicine.jpg',
          image: item,
          fit: BoxFit.fitWidth);
    } else {
      print("Local True");
      return Image.asset(item);
    }
  }

  List<Widget>? _imageSliders;

  Future<void> initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  OfferBloc offerBloc = OfferBloc();
  List<Insertt>? insertData;

  fetchAllProducts() async {
    insertData = await offerBloc.getData(context);
    setState(() {});
  }
  // TestSearch testSearch =TestSearch();
  // SearchBloc searchBloc=SearchBloc();
  @override
  void initState() {
    super.initState();
    print("here");
    fetchAllProducts();



    // testSearch.searchData();
    Platform.isAndroid ? AndroidDeviceInformation() : IosDeviceInformation();
    WidgetsBinding.instance.addObserver(this);
    _cartDetailsBloc = getIt<CartDetailsBloc>();
    _homeBloc.getUserPreference();
    _homeBloc.callAdvertisementAPI("");
    _homeBloc.streamLoginStatus$.listen((data) {
      if (data)
        setState(() {
          isLoggedIn = true;
        });
    });

    _homeBloc.streamAdvertisementData$.listen((data) {
      imgList.clear();
      AdvertisementData advertisementData = data as AdvertisementData;
      for (Insert data in advertisementData.insert!) {
        print(data.imageUrl);
        imgList.add(data.imageUrl ?? "assets/images/medicine.jpg");
      }
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Future.delayed(const Duration(milliseconds: 10000), () async {
              await _cartDetailsBloc?.getProducts();
            }));

    initPackageInfo();
//    Platform.isAndroid ? AndroidDeviceInformation() : IosDeviceInformation();
    //_cartDetailsBloc.getProducts();
  }

  @override
  void dispose() {
    super.dispose();
    _cartDetailsBloc?.getProducts();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _cartDetailsBloc?.getProducts();
      getLoginStatus();
    }
  }

  int getTotalItemQuantity(var data) {
    List<CartItem> cartItems = [];
    cartItems = data as List<CartItem>;
    int totalItem = 0;
    for (CartItem item in cartItems) {
      totalItem += item.quantity ?? 0;
    }
    return totalItem;
  }

  int getTotal(var data) {
    List<CartItem> items = [];
    items = data as List<CartItem>;
    return items.length;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));

    _imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(0.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        sliderImage(item, context),
                        // Positioned(
                        //   bottom: 0.0,
                        //   left: 0.0,
                        //   right: 0.0,
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         // color: Colors.white
                        //         gradient: LinearGradient(
                        //
                        //           // colors: [
                        //           //   Color.fromARGB(1, 0, 0, 0),
                        //           //   Color.fromARGB(0, 0, 0, 0)
                        //           // ],
                        //           begin: Alignment.bottomCenter,
                        //           end: Alignment.topCenter,
                        //         ),
                        //         ),
                        //     padding: EdgeInsets.symmetric(
                        //         vertical: 10.0, horizontal: 10.0),
                        //   ),
                        // ),
                      ],
                    )),
              ),
            ))
        .toList();

    getLoginStatus();

    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: <Widget>[
              Image.asset(
                "assets/images/Transparent PNG.png",width: 100,height: 100,

              ),
              Expanded(child: SizedBox()),
              StreamBuilder(
                  stream: _cartDetailsBloc?.streamProducts$,
                  builder: (context, snapshot) {
                    int totalItemCount = 0;
                    if (snapshot.data != null) {
                      print("${snapshot.data}");
                      totalItemCount = getTotal(snapshot.data);
                    }

                    return GestureDetector(
                        onTap: () {
                          if (totalItemCount == 0) {
                            Fluttertoast.showToast(
                                msg: "Cart is empty",
                                // duration: Toast.LENGTH_SHORT,
                                // gravity: Toast.TOP,
                                backgroundColor: Colors.deepOrangeAccent,
                                textColor: Colors.white);
                            // Fluttertoast.showToast(
                            //     textColor: Colors.white,
                            //     backgroundColor: Colors.deepOrangeAccent,
                            //     msg: "Cart is empty",
                            //     toastLength: Toast.LENGTH_SHORT,
                            //     gravity: ToastGravity.TOP);
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CartDetails(),
                                ));
                          }
                        },
                        child: badges.Badge(
                          showBadge: (totalItemCount == 0) ? false : true,
                          badgeContent: Text(
                            "$totalItemCount",
                            style: TextStyle(color: Colors.white),
                          ),
                          child: Icon(Icons.shopping_basket),
                        ));
                  })
            ],
          ),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/logos/al_ataf_logo.png'),
                            fit: BoxFit.contain,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Al-Ataf Pharma',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ],
                  )),
              decoration: BoxDecoration(
                color: Colors.white70,
              ),
            ),
            isLoggedIn
                ? ListTile(
                    dense: true,
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(),
                          ));
                    },
                  )
                : Container(),
            ListTile(
              dense: true,
              title: Text('Order History'),
              onTap: () {
                if (getIt<MainBloc>().key.toString().trim().length == 0) {
                  Fluttertoast.showToast(
                      msg: "To view order history please login first",
                      // gravity: Toast.CENTER,
                      backgroundColor: Colors.red,
                      textColor: Colors.white);
                  // Fluttertoast.showToast(
                  //     backgroundColor: Colors.red,
                  //     textColor: Colors.white,
                  //     msg: "To view order history please login first",
                  //     gravity: ToastGravity.CENTER);
                  return;
                }
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderHistory(),
                    ));
              },
            ),
            ListTile(
              dense: true,
              title: Text('Share'),
              onTap: () {
                Navigator.pop(context);
                final RenderBox box = context.findRenderObject() as RenderBox;
                Share.share("Share Al-Ataf",
                    subject: "Subject",
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              },
            ),
            ListTile(
              dense: true,
              title: Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
                Uri mailing = Uri(
                    scheme: "mailto",
                    path: "alatafpharma@gmail.com",
                    queryParameters: {
                      'subject':
                          "Feedback%20to%20Al-Ataf%20Pharma%20(${packageInfo.version})",
                      'body':
                          "\n\n\nOS Version: $_osVersion \nBrand:$_deviceName \nModel: $_model"
                    });
                launchUrl(Uri.parse(mailing.toString()));
                // _launchURL(
                //     'mailto:alatafpharma@gmail.com?subject=Feedback%20to%20Al-Ataf%20Pharma%20(${packageInfo.version})&body=\n\n\nOS Version: $_osVersion \nBrand:$_deviceName \nModel: $_model');
              },
            ),
            ListTile(
                dense: true,
                title: Text('Services'),
                onTap: () {
                  Navigator.pop(context);

                  Fluttertoast.showToast(
                      msg: "Coming soon",
                      backgroundColor: Colors.green,
                      textColor: Colors.white
                      // duration: Toast.LENGTH_SHORT);
                      // Fluttertoast.showToast(
                      //   textColor: Colors.white,
                      //   backgroundColor: Colors.green,
                      //   msg: "Coming soon",
                      //   toastLength: Toast.LENGTH_SHORT,
                      // );

                      );
                }),
            ListTile(
              dense: true,
              title: Text('About Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutUs(),
                    ));
              },
            ),
            ListTile(
              dense: true,
              title: Text('Like us on facebook'),
              onTap: () {
                Navigator.pop(context);
                _launchURL('https://m.facebook.com/alatafpharma');
              },
            ),
            ListTile(
              dense: true,
              title: Text('Report or Complain'),
              onTap: () {
                Navigator.pop(context);
                Uri mailing = Uri(
                    scheme: "mailto",
                    path: "alc041214@gmail.com",
                    queryParameters: {
                      'subject': "App complain",
                      'body':
                          "Note:%20The%20below%20information%20helps%20us%20to%20understand%20your%20problem%20better.\n\n\n\nVersion: ${packageInfo.version}"
                    });
                launch(mailing.toString());
                // _launchURL(
                //     'mailto:alc041214@gmail.com?subject=App complain&body=Note:%20The%20below%20information%20helps%20us%20to%20understand%20your%20problem%20better.'
                //     ''
                //     ''
                //     ''
                //     '\n'
                //     '\n'
                //     '\n'
                //     'Version: ${packageInfo.version}');
              },
            ),
            ListTile(
              dense: true,
              title: (isLoggedIn) ? Text('Sign Out') : Text('Sign In'),
              onTap: () {
                if (isLoggedIn) {
                  setState(() {
                    isLoggedIn = !isLoggedIn;
                  });
                  getIt<MainBloc>().key = "";
                  _homeBloc.saveUserPreference("");
                } else {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                }
              },
            )
          ],
        ),
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                searchView(context),
                SizedBox(height: 16),
                Text("Category", style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    buttonOrder(context),
                    SizedBox(width: 16),
                    buttonHistory(context),
                    SizedBox(width: 16),
                    buttonNotification(context),
                    SizedBox(width: 16),
                    buttonOffers(context),
                  ],
                ),
                SizedBox(height: 16),
                // sliderView(_imageSliders!),

                //slider image get from api
                insertData == null
                    ? sliderView(_imageSliders!)
                    : CarouselSlider(
                        items: insertData!
                            .map(
                              (item) => Image.network(
                                item.imageUrl.toString(),
                                fit: BoxFit.cover,
                                height: 144,
                              ),
                            )
                            .toList(),
                        carouselController: carouselController,
                        options: CarouselOptions(
                          height: 144,
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlay: true,
                          aspectRatio: 2,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index - 1;
                            });
                          },
                        ),
                      ),

                SizedBox(height: 20),
                prescriptionUploadView(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getLoginStatus() {
    if (getIt<MainBloc>().key.length > 0) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget buttonHistory(BuildContext context) {
  return Expanded(
    flex: 2,
    child: Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.20,
          height: MediaQuery.of(context).size.width * 0.20,
          child: ElevatedButton(
              onPressed: () {
                if (getIt<MainBloc>().key.toString().trim().length == 0) {
                  Fluttertoast.showToast(
                      msg: "To view order history please login first",
                      // gravity: Toast.CENTER,
                      backgroundColor: Colors.red,
                      textColor: Colors.white);
                  // Fluttertoast.showToast(
                  //     backgroundColor: Colors.red,
                  //     textColor: Colors.white,
                  //     msg: "To view order history please login first",
                  //     gravity: ToastGravity.CENTER);
                  return;
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderHistory(),
                    ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFEEE6),
              ),
              child: Icon(Icons.history, size: 40, color: Colors.black54)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "History",
            style: TextStyle(fontSize: 13),
          ),
        )
      ],
    ),
  );
}

Widget buttonOrder(BuildContext context) {
  return Expanded(
    flex: 2,
    child: Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.20,
          height: MediaQuery.of(context).size.width * 0.20,
          child: ElevatedButton(
              onPressed: () {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Search(),
                        )));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFEEE6),
              ),
              child: FaIcon(FontAwesomeIcons.search,
                  size: 30, color: Colors.black54)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Order", style: TextStyle(fontSize: 13)),
        )
      ],
    ),
  );
}

Widget buttonNotification(BuildContext context) {
  return Expanded(
    flex: 2,
    child: Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.20,
          height: MediaQuery.of(context).size.width * 0.20,
          child: ElevatedButton(
              onPressed: () {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Message(),
                        )));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFEEE6),
              ),
              child: badges.Badge(
                showBadge: false,
                badgeContent:
                    Text('0', style: TextStyle(color: Colors.white70)),
                child: Icon(Icons.message, size: 40, color: Colors.black54),
              )),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: AutoSizeText(
              'Messages',
              style: TextStyle(fontSize: 13.0),
              maxLines: 1,
            ))
      ],
    ),
  );
}

//Icon(Icons.notifications, size: 40, color: Colors.black54)

Widget buttonOffers(BuildContext context) {
  return Expanded(
    flex: 2,
    child: Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.20,
          height: MediaQuery.of(context).size.width * 0.20,
          child: ElevatedButton(
              onPressed: () {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Offer(),
                        )));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFEEE6),
              ),
              child: Icon(Icons.local_offer, size: 40, color: Colors.black54)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Offers", style: TextStyle(fontSize: 13)),
        )
      ],
    ),
  );
}

Widget searchView(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Search(),
          ));
    },
    child: Container(
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
          child: Container(
              child: Row(
            children: <Widget>[
              Icon(
                Icons.search,
                color: Colors.black54,
              ),
              SizedBox(width: 8),
              Text(
                "Search by generic or medicine name",
                style: TextStyle(color: Colors.black54),
              )
            ],
          ))),
    ),
  );
}

Widget sliderView(List<Widget> imageSliders) {
  return CarouselSlider(
    options: CarouselOptions(
      aspectRatio: 2.0,
      //viewportFraction: 0.8,
      autoPlay: true,
      enlargeCenterPage: false,
    ),
    items: imageSliders,
  );
}

Widget prescriptionUploadView(BuildContext context) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 16.0),
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    decoration: kBoxDecorationStyle,
    child: Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text("Order Quickly",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 16.0),
        Text(
            "To get your medicine quickly at your door stop upload your prescription",
            style: TextStyle(fontSize: 16)),
        Align(
          alignment: Alignment.bottomRight,
          child: GestureDetector(
            onTap: () {
              if (getIt<MainBloc>().key.length > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(

                      builder: (context) => TestImagePage(),
                    ));
              } else {
                /*Fluttertoast.showToast(
                  textColor: Colors.white,
                  backgroundColor: Colors.red,
                  msg: "To upload prescription please login first",
                  toastLength: Toast.LENGTH_SHORT,
                );*/
                _showLoginConfirmDialog(context);
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 4.0),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              decoration: buttonBoxDecorationStyle,
              child: Text("UPLOAD",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
        )
      ],
    ),
  );
}

void _showLoginConfirmDialog(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
          content: Container(
              height: 150.0,
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.perm_device_information,
                    color: Colors.red,
                    size: 50.0,
                  ),
                  SizedBox(height: 8),
                  Text("Login required",
                      style: TextStyle(fontSize: 24, color: Colors.red)),
                  SizedBox(height: 20),
                  Text("To checkout please login first.",
                      style: TextStyle(fontSize: 18, color: Colors.black87)),
                ],
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new TextButton(
              child: new Text(
                "CANCEL",
                style: TextStyle(color: Colors.black87),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text(
                "LOGIN",
                style: TextStyle(color: Colors.black87),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
                //Navigator.pop(context);
              },
            ),
          ]);
    },
  );
}
