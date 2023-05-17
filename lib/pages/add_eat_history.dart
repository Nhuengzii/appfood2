import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:appfood2/pages/camera.dart';
import 'package:appfood2/pages/eat_confirm.dart';
import 'package:image_picker/image_picker.dart';

class AddEatHistoryPage extends StatefulWidget {
  const AddEatHistoryPage({super.key});

  @override
  State<AddEatHistoryPage> createState() => _AddEatHistoryPageState();
}

class _AddEatHistoryPageState extends State<AddEatHistoryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String _unit = "1";
  final List<String> _radioValues = ["1", "2", "3", "4"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade50,
      appBar: AppBar(
        title: const Text("Add eat history page"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.lightBlue.shade100,
                    borderRadius: BorderRadius.circular(20)),
                child: const Column(
                  children: [
                    Text(
                      "เพิ่มประวัติการ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "รับประทานอาหาร",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Form(
              child: Column(
                children: [
                  const Text("ชื่ออาหาร"),
                  TextFormField(
                    controller: _foodNameController,
                  ),
                  const Text("ปริมาณ"),
                  TextFormField(
                    controller: _quantityController,
                  ),
                  Column(
                    children: [
                      ListTile(
                        title: const Text("ผล"),
                        leading: Radio(
                            value: _radioValues[0],
                            groupValue: _unit,
                            onChanged: (value) {
                              setState(() {
                                _unit = value.toString();
                              });
                            }),
                      ),
                      ListTile(
                        title: const Text("ส่วน"),
                        leading: Radio(
                            value: _radioValues[1],
                            groupValue: _unit,
                            onChanged: (value) {
                              setState(() {
                                _unit = value.toString();
                              });
                            }),
                      ),
                      ListTile(
                        title: const Text("กรัม"),
                        leading: Radio(
                            value: _radioValues[2],
                            groupValue: _unit,
                            onChanged: (value) {
                              setState(() {
                                _unit = value.toString();
                              });
                            }),
                      ),
                      ListTile(
                        title: const Text("ขนาดพอคำ"),
                        leading: Radio(
                            value: _radioValues[3],
                            groupValue: _unit,
                            onChanged: (value) {
                              setState(() {
                                _unit = value.toString();
                              });
                            }),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 800,
                    maxHeight: 800,
                  );
                  if (image == null) {
                    return;
                  }
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EatConfirmPage(image: image)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red.shade200,
                      borderRadius: BorderRadius.circular(30)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(FontAwesomeIcons.arrowDown),
                      SizedBox(
                        width: 10,
                      ),
                      Text("นำเข้ารูปภาพ")
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.orange, shape: BoxShape.circle),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const CameraPage(replaceWhenNavigate: true)));
                },
                icon: const Icon(Icons.camera_alt, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}