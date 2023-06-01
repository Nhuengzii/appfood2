import 'dart:io';
import 'package:appfood2/pages/all_food.dart';
import 'package:appfood2/pages/food_detailed.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appfood2/pages/ai_output.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EatConfirmPage extends StatelessWidget {
  const EatConfirmPage(
      {super.key, required this.image, this.name, this.unit, this.quantity});
  final XFile? image;
  final String? name, unit;
  final int? quantity;

  Future<void> _saveEatHistory() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final nowTimestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = "history/$uid/$nowTimestamp";
    final storageRef = FirebaseStorage.instance.ref().child(filePath);
    await storageRef.putFile(File(image!.path));
    final String downloadUrl = await storageRef.getDownloadURL();
    await FirebaseFirestore.instance.collection("eatHistory").add({
      "uid": uid,
      "timestamp": nowTimestamp,
      "foodName": name ?? "ไม่มีชื่อ",
      "quantity": quantity ?? 0,
      "unit": unit ?? "ไร้หน่วย",
      "foodPhoto": downloadUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 340,
            width: 340,
            child: Image.file(
              File(image!.path),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Text(
              "คุณต้องการรับประทาน\n        อาหารชนิดนี้?",
              style: TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await _saveEatHistory();
                  // ignore: use_build_context_synchronously

                  final Food resultFood = Food(
                      name: "test",
                      type: "Fruit",
                      imageAssetPath: "",
                      detail: FoodNutritionDetail(
                          name: "test test",
                          giIndex: 45.1,
                          benefit: "Nice it is very nice",
                          power: 333,
                          fiber: 333,
                          sugar: 333,
                          protein: 333,
                          fat: 333,
                          carbo: 333,
                          nutrition: "test 1 grams"));

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => AIOutputPage(
                            foodImage: image,
                            food: resultFood,
                          )));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(177, 254, 150, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: 70,
                  height: 53,
                  child: const Text(
                    "ใช่",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(250, 138, 138, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: 70,
                  height: 53,
                  child: const Text(
                    "ไม่",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
