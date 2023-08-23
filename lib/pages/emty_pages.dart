
import 'package:alataf/pages/utils.dart';
import 'package:flutter/material.dart';



class EmtyPage extends StatelessWidget {
  EmtyPage(
      {Key? key,
        required this.buttonText,
        required this.imagePath,
        required this.whoopsSubtitleText,
        required this.whoopsText})
      : super(key: key);
  static const routeName = "/EmtyPage";
  String imagePath, whoopsText, whoopsSubtitleText, buttonText;

  @override
  Widget build(BuildContext context) {

    final Utilssss utils = Utilssss(context);

    final Size size = Utilssss(context).screenSize;
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: size.height * 0.4,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              whoopsText,
              style: TextStyle(
                  color: Colors.red, fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              whoopsSubtitleText,
              style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        )),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                onPressed: () {
                  // golobalMethod.navigateTo(
                  //     context: context, routeName: FeedInnerPage.routeName);
                },
                child: Text(buttonText))
          ],
        ),
      ),
    );
  }
}
