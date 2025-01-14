import 'package:flutter/material.dart';
import 'package:appfood2/screen_size.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    required this.maxWidth,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double maxWidth;
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      //alignment: Alignment.center,
      children: [
        Positioned(
          top: 40,
          left: screenWidth * 0.5 - 200 / 2 + 30,
          child: const SizedBox(
            width: 200,
            child: Text(
              "กินดี",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 60,
                color: Color.fromRGBO(71, 116, 70, 1),
              ),
            ),
          ),
        ),
        Positioned(
            top: 110,
            left: screenWidth * 0.5 - 155 / 2,
            child: Container(
              width: 155,
              alignment: Alignment.center,
              child: const Divider(
                thickness: 3,
                color: Colors.black,
              ),
            )),
        Positioned(
          top: 100,
          left: screenWidth * 0.5 - 200 / 2 + 60 + 70,
          child: const SizedBox(
            width: 200,
            child: Text(
              "อยู่ดี",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                  color: Color.fromRGBO(250, 184, 124, 1)),
            ),
          ),
        ),
      ],
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final screenSizeData = ScreenSizeData(
      screenWidth: mediaQueryData.size.width,
      screenHeight: mediaQueryData.size.height,
    );

    return Scaffold(
        //backgroundColor: const Color.fromRGBO(240, 255, 231, 1),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
      return SafeArea(
        child: Container(
          color: screenSizeData.screenWidth <= screenSizeData.maxWidth
              ? Colors.white
              : Colors.black,
          child: Center(
            child: Container(
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(240, 255, 231, 1)),
              width: screenSizeData.screenSizeWidth,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  const Expanded(
                    flex: 33,
                    child: Center(child: ImageLogo()),
                  ),
                  Expanded(
                    flex: 34,
                    child: Align(
                        alignment: Alignment.center,
                        child: AppLogo(
                          maxWidth: screenSizeData.maxWidth,
                          screenHeight: screenSizeData.screenHeight,
                          screenWidth: screenSizeData.screenSizeWidth,
                        )),
                  ),
                  const Expanded(
                    flex: 34,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Align(
                          alignment: Alignment.topCenter, child: ButtonStart()),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }));
  }
}

class ButtonStart extends StatelessWidget {
  const ButtonStart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color.fromRGBO(156, 211, 101, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(156, 98),
            topRight: Radius.elliptical(165, 85),
            bottomLeft: Radius.elliptical(156, 98),
            bottomRight: Radius.elliptical(165, 85),
          )),
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed("/landing");
        },
        child: const Text(
          "เริ่มต้นใช้งาน",
          style: TextStyle(
              fontSize: 32, color: Colors.black, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ImageLogo extends StatelessWidget {
  const ImageLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Image.asset(
            "assets/images/logo_NRCT.jpg",
            width: 70,
            height: 70,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25, left: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/ku.png",
                width: 60,
                height: 60,
              ),
              Image.asset(
                "assets/images/kku.png",
                width: 60,
                height: 60,
              ),
              Image.asset(
                "assets/images/mahidol.png",
                width: 90,
                height: 90,
              )
            ],
          ),
        )
      ],
    );
  }
}
