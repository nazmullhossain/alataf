import 'package:flutter/material.dart';

import 'home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1350),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  initState(){
    super.initState();
    _initilizeData();
  }



  Future<void> _initilizeData()async {
    Future.delayed(Duration(seconds: 3)).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>Home())));
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

          return Scaffold(
            backgroundColor: const Color(0xffF7F7F7),
            body: Center(
              child: FadeTransition(
                opacity: _animation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/Transparent PNG.png',
                        width: 200,

                        fit: BoxFit.cover),
                    // RichText(
                    //   textAlign: TextAlign.center,
                    //   text: TextSpan(
                    //     style: TextStyle(color: const Color(0xffFF002D),fontSize: 20,fontWeight: FontWeight.w900),
                    //     children: const <TextSpan>[
                    //       TextSpan(text: 'Al'),
                    //         TextSpan(text: '-Ataf', style: TextStyle(color: Colors.purple)),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          );
        }

  }
