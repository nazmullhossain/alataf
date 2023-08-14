import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  @override
  AboutUsState createState() {
    return AboutUsState();
  }
}

class AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              closeButton(context),
              SizedBox(height: 16),
              Icon(LineAwesomeIcons.info_circle,
                  size: 40, color: Colors.black54),
              SizedBox(height: 8),
              Text("Al-Ataf",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Row(
                children: <Widget>[
                  Text("Online medicine delivery shop",
                      style: TextStyle(fontSize: 18)),
                ],
              ),
              SizedBox(height: 40),
              Text("Address",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.my_location,
                      size: 20,
                      color: Colors.grey[700],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                          "Progati Subas, 5th Floor, Ka-11/5, Progati Sarani, Dhaka-1229",
                          style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text("Email",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.email,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("alatafpharma@gmail.com",
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _launchURL(
                        'mailto:alatafpharma@gmail.com?subject=&body='),
                    icon: FaIcon(
                      Icons.send,
                      color: Colors.red[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

Widget closeButton(BuildContext context) {
  return Container(
    alignment: Alignment.topRight,
    child: TextButton(
      onPressed: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          SystemNavigator.pop();
        }
      },
      child: Icon(
        Icons.close,
        size: 35,
        color: Colors.grey,
      ),
    ),
  );
}
