import 'package:flutter/material.dart';

class FoodDetailPage extends StatelessWidget {
  const FoodDetailPage({super.key, required this.detail});
  final FoodNutritionDetail detail;
  Color _getGIColor(num giIndex) {
    if (giIndex < 55) {
      return Colors.green.shade100;
    } else if (giIndex < 70 && giIndex >= 55) {
      return Colors.yellow.shade100;
    } else {
      return Colors.red.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FoodDetailPage"),
      ),
      backgroundColor: _getGIColor(detail.giIndex),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Text(
                detail.name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              )),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox.fromSize(
              size: const Size.fromRadius(48 * 3),
              child: Image.asset(
                detail.realImageAssetPath ?? "assets/cameraFrame.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          ChemicalDetail(
              power: detail.power, fiber: detail.fiber, sugar: detail.sugar),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "ประโยชน์",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(detail.benefit),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: const Column(
              children: [
                Text(
                  "กดที่นี่",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text("เพื่อดูข้อมูลทางโภชนาการเพิ่มเติม",
                    style: TextStyle(fontSize: 20))
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class ChemicalDetail extends StatelessWidget {
  const ChemicalDetail({
    super.key,
    required this.power,
    required this.fiber,
    required this.sugar,
  });
  final num power;
  final num fiber;
  final num sugar;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8 ,horizontal: 12),
          child: Container(
            //padding: const EdgeInsets.all(30),
            
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("พลังงาน"),
                Text(
                  "$power",
                  style: const TextStyle(
                      color: Color.fromRGBO(9, 183, 173, 1), fontWeight: FontWeight.w900),
                ),
                const Text("กโลแคลอรี่"),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8 ,horizontal: 12),
          child: Container(
            //padding: const EdgeInsets.all(30),
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("ใยอาหาร"),
                Text(
                  "$fiber",
                  style: const TextStyle(
                      color: Color.fromRGBO(9, 183, 173, 1), fontWeight: FontWeight.w900),
                ),
                const Text("กรัม"),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8 ,horizontal: 12),
          child: Container(
            //padding: const EdgeInsets.all(30),
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("น้ำตาล"),
                Text(
                  "$sugar",
                  style: const TextStyle(
                      color: Color.fromRGBO(255, 141, 35, 1), fontWeight: FontWeight.w900),
                ),
                const Text("กรัม"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FoodNutritionDetail {
  const FoodNutritionDetail(
      {required this.name,
      required this.giIndex,
      this.realImageAssetPath,
      required this.benefit,
      required this.power,
      required this.fiber,
      required this.sugar});
  final String name;
  final String? realImageAssetPath;
  final num giIndex;
  final String benefit;
  final num power;
  final num fiber;
  final num sugar;
}
