import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:appfood2/pages/add_eat_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appfood2/widgets/button_back.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:appfood2/screen_size.dart';

class History {
  const History({
    required this.image,
    required this.unit,
    required this.foodName,
    required this.quantity,
    required this.timestamp,
  });
  final Uint8List image;
  final String unit;
  final String foodName;
  final int quantity;
  final int timestamp;
}

class EatHistoryPage extends StatefulWidget {
  const EatHistoryPage({super.key});

  @override
  State<EatHistoryPage> createState() => _EatHistoryPageState();
}

Future<List<History>> getEatHistoryDataFromLocal() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final historyData = await FirebaseFirestore.instance
      .collection("eatHistory")
      .where("uid", isEqualTo: uid)
      .get();
  List<History> historySlots = [];
  for (var i = 0; i < historyData.docs.length; i++) {
    final history = historyData.docs[i];
    historySlots.add(History(
      image: history["foodPhoto"],
      unit: history["unit"],
      foodName: history["foodName"],
      quantity: history["quantity"],
      timestamp: history["timestamp"],
    ));
  }
  // sort by timestamp
  historySlots.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  return historySlots;
}

class _EatHistoryPageState extends State<EatHistoryPage> {
  // Future<List<History>> _getHistoryData() async {
  //   return await getEatHistoryDataFromLocal();
  // }

  Future<List<History>> _getHistoryDataFromLocal() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyKeys =
        prefs.getStringList("EatHistoryOf-$uid") ?? [];
    List<History> historySlots = [];
    for (var i = 0; i < historyKeys.length; i++) {
      final String? historyRaw = prefs.getString(historyKeys[i]);
      if (historyRaw == null) {
        continue;
      }
      final Map<String, dynamic> history = jsonDecode(historyRaw);
      try {
        historySlots.add(History(
          image: base64Decode(history["foodPhoto"]),
          unit: history["unit"],
          foodName: history["foodName"],
          quantity: history["quantity"],
          timestamp: history["timestamp"],
        ));
      } catch (e) {
        continue;
      }
    }
    // sort by timestamp
    historySlots.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return historySlots;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final screenSizeData = ScreenSizeData(
      screenWidth: mediaQueryData.size.width,
      screenHeight: mediaQueryData.size.height,
    );
    return Scaffold(
      body: Container(
        color: screenSizeData.screenWidth <= screenSizeData.maxWidth
            ? Colors.white
            : Colors.black,
        child: Center(
          child: Container(
            color: Colors.white,
            width: screenSizeData.screenSizeWidth,
            height: screenSizeData.screenHeight,
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return EatHistoryComponent(history: snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error} ?? `ERR`");
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
              future: _getHistoryDataFromLocal(),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectDate extends StatefulWidget {
  const SelectDate({super.key, required this.updateDateInParent});
  final ValueChanged<Map<String, String>> updateDateInParent;
  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  bool buttondate = false;

  List<String> month = [
    "ม.ค.",
    "ก.พ.",
    "มี.ค.",
    "เม.ย.",
    "พ.ค.",
    "มิ.ย.",
    "ก.ค.",
    "ส.ค.",
    "ก.ย.",
    "ต.ค.",
    "พ.ย.",
    "ธ.ค."
  ];
  String _startDate = " ", _endDate = " ";
  final DateRangePickerController _controller = DateRangePickerController();

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate =
          DateFormat('dd MM yyyy').format(args.value.startDate).toString();
      _endDate = DateFormat('dd MM yyyy')
          .format(args.value.endDate ?? args.value.startDate)
          .toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(const Color.fromRGBO(200, 211, 239, 1)),
        ),
        onPressed: () async {
          (buttondate)
              ? setState(() {
                  buttondate = !buttondate;
                  widget.updateDateInParent({
                    "start": " ",
                    "end": " ",
                  });
                })
              : showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        height: MediaQuery.of(context).size.height * 0.65,
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Scaffold(
                            appBar: AppBar(
                              title: const Text('เลือกช่วงเวลา'),
                            ),
                            body: Stack(
                              children: <Widget>[
                                const Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  height: 80,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: SfDateRangePicker(
                                    selectionMode:
                                        DateRangePickerSelectionMode.range,
                                    initialSelectedRange: PickerDateRange(
                                        DateTime.now()
                                            .subtract(const Duration(days: 4)),
                                        DateTime.now()
                                            .add(const Duration(days: 3))),
                                    showActionButtons: true,
                                    controller: _controller,
                                    onSelectionChanged: selectionChanged,
                                    onSubmit: (p0) {
                                      if (p0 != null && p0.toString() != "[]") {
                                        Navigator.pop(context);
                                        setState(() {
                                          buttondate = true;
                                          selectionChanged;
                                          widget.updateDateInParent({
                                            "start": _startDate,
                                            "end": _endDate,
                                          });
                                        });
                                      } else {}
                                    },
                                    onCancel: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                )
                              ],
                            )),
                      )
                    ]));
                  });
        },
        child: (buttondate)
            ? Text(
                (_startDate == " ")
                    ? "กรุณาเลือกช่วงเวลาใหม่อีกครั้ง!"
                    : (_startDate == _endDate)
                        ? '${_startDate[0]}${_startDate[1]} ${(_startDate[3] == '1') ? month[int.parse(_startDate[3]) - 1] : month[int.parse("${_startDate[3]}${_startDate[4]}") - 1]} ${int.parse("${_startDate[6]}${_startDate[7]}${_startDate[8]}${_startDate[9]}") + 543}'
                        : ('${_startDate[0]}${_startDate[1]} ${(_startDate[3] == '1') ? month[int.parse(_startDate[3]) - 1] : month[int.parse("${_startDate[3]}${_startDate[4]}") - 1]} ${int.parse("${_startDate[6]}${_startDate[7]}${_startDate[8]}${_startDate[9]}") + 543} - ${_endDate[0]}${_endDate[1]} ${(_endDate[3] == '1') ? month[int.parse(_endDate[3]) - 1] : month[int.parse("${_endDate[3]}${_endDate[4]}") - 1]} ${int.parse("${_endDate[6]}${_endDate[7]}${_endDate[8]}${_endDate[9]}") + 543}'),
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(52, 52, 52, 1)))
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'เลือกช่วงเวลา',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: 30,
                    color: Colors.black,
                  )
                ],
              ));
  }
}

class EatHistoryComponent extends StatefulWidget {
  const EatHistoryComponent({super.key, required this.history});
  final List<History> history;

  @override
  State<EatHistoryComponent> createState() => _EatHistoryComponentState();
}

class _EatHistoryComponentState extends State<EatHistoryComponent> {
  String _startDate = " ", _endDate = " ";
  late List<HistorySlot> filteredHistorySlots;
  @override
  void initState() {
    super.initState();
    filteredHistorySlots = widget.history.asMap().entries.map((e) {
      return HistorySlot(
          number: e.key,
          image: e.value.image,
          foodName: e.value.foodName,
          quantity: e.value.quantity,
          timestamp: e.value.timestamp,
          unit: e.value.unit,
          oneDay: false);
    }).toList();
  }

  void _updateDate(Map<String, String> interval) {
    setState(() {
      filteredHistorySlots = [];
      _startDate = interval['start']!;
      _endDate = interval['end']!;
      if (_startDate == " ") {
        filteredHistorySlots = widget.history.asMap().entries.map((e) {
          return HistorySlot(
              number: e.key,
              image: e.value.image,
              foodName: e.value.foodName,
              quantity: e.value.quantity,
              timestamp: e.value.timestamp,
              unit: e.value.unit,
              oneDay: false);
        }).toList();
      } else if (_endDate == _startDate) {
        int checkstart = DateTime.parse(
                "${_startDate[6]}${_startDate[7]}${_startDate[8]}${_startDate[9]}-${_startDate[3]}${_startDate[4]}-${_startDate[0]}${_startDate[1]} 00:00:00")
            .millisecondsSinceEpoch;
        int checkend = DateTime.parse(
                "${_startDate[6]}${_startDate[7]}${_startDate[8]}${_startDate[9]}-${_startDate[3]}${_startDate[4]}-${_startDate[0]}${_startDate[1]} 23:59:59")
            .millisecondsSinceEpoch;
        int count = 0;
        for (var i = 0; i < widget.history.length; i++) {
          if ((widget.history[i].timestamp >= checkstart) &&
              (checkend >= widget.history[i].timestamp)) {
            filteredHistorySlots.add(HistorySlot(
                number: count,
                image: widget.history[i].image,
                foodName: widget.history[i].foodName,
                quantity: widget.history[i].quantity,
                timestamp: widget.history[i].timestamp,
                unit: widget.history[i].unit,
                oneDay: true));
            count++;
          }
        }
      } else if (_endDate != _startDate) {
        int checkstart = DateTime.parse(
                "${_startDate[6]}${_startDate[7]}${_startDate[8]}${_startDate[9]}-${_startDate[3]}${_startDate[4]}-${_startDate[0]}${_startDate[1]} 00:00:00")
            .millisecondsSinceEpoch;
        int checkend = DateTime.parse(
                "${_endDate[6]}${_endDate[7]}${_endDate[8]}${_endDate[9]}-${_endDate[3]}${_endDate[4]}-${_endDate[0]}${_endDate[1]} 23:59:59")
            .millisecondsSinceEpoch;
        int count = 0;
        for (var i = 0; i < widget.history.length; i++) {
          if (widget.history[i].timestamp >= checkstart &&
              checkend >= widget.history[i].timestamp) {
            filteredHistorySlots.add(HistorySlot(
                number: count,
                image: widget.history[i].image,
                foodName: widget.history[i].foodName,
                quantity: widget.history[i].quantity,
                timestamp: widget.history[i].timestamp,
                unit: widget.history[i].unit,
                oneDay: false));
            count++;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
          child: SizedBox(
              child: Column(children: [
        SizedBox(
            height: 132,
            width: double.infinity,
            child: DecoratedBox(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 214, 113, 1)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 6),
                          child: Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(18, 109, 104, 1),
                                  shape: BoxShape.circle),
                              child: const ButtonBack(
                                colorCircle: Color.fromRGBO(18, 109, 104, 1),
                                color: Colors.white,
                              )),
                        ),
                        Container(
                            alignment: Alignment.center,
                            width: 109,
                            height: 41,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(125, 144, 243, 1),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "เมนู",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          //alignment: Alignment.center,
                          //width: double.infinity,
                          //height: 47,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0)),
                          child: const Text(
                            "ประวัติการรับประทานอาหาร",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ))),
        SizedBox(
            width: double.infinity,
            height: 100,
            child: DecoratedBox(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(200, 211, 239, 1)),
                child: SelectDate(
                  updateDateInParent: _updateDate,
                ))),
        Column(
          children: [
            ...filteredHistorySlots,
            Container(
              width: double.infinity,
              height: 125,
              color: filteredHistorySlots.length % 2 == 0
                  ? const Color.fromRGBO(134, 251, 166, 0.65)
                  : const Color.fromRGBO(221, 255, 231, 0.65),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Text(
                      (filteredHistorySlots.length + 1).toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => const AddEatHistoryPage()))
                          .then((value) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const EatHistoryPage()));
                      });
                    },
                    child: const Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.plus,
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "เพิ่มข้อมูล",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ]))),
    );
  }
}

class HistorySlot extends StatefulWidget {
  const HistorySlot(
      {super.key,
      required this.number,
      required this.image,
      required this.foodName,
      required this.quantity,
      required this.timestamp,
      required this.unit,
      required this.oneDay});
  final int number;
  final Uint8List image;
  final String foodName;
  final int quantity;
  final int timestamp;
  final String unit;
  final bool oneDay;

  @override
  State<HistorySlot> createState() => _HistorySlotState();
}

class _HistorySlotState extends State<HistorySlot> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 125,
      color: widget.number % 2 == 0
          ? const Color.fromRGBO(134, 251, 166, 0.65)
          : const Color.fromRGBO(221, 255, 231, 0.65),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Text(
              (widget.number + 1).toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox.fromSize(
              size: const Size.fromRadius(15 * 3),
              child: Image(
                image: Image(image: MemoryImage(widget.image)).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.foodName} ${widget.quantity} ${widget.unit}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                    widget.oneDay
                        ? "เวลา ${DateTime.fromMillisecondsSinceEpoch(widget.timestamp).hour}:${DateTime.fromMillisecondsSinceEpoch(widget.timestamp).minute}น."
                        : "วันที่ ${DateTime.fromMillisecondsSinceEpoch(widget.timestamp).day}/${DateTime.fromMillisecondsSinceEpoch(widget.timestamp).month}/${DateTime.fromMillisecondsSinceEpoch(widget.timestamp).year + 543} ${DateTime.fromMillisecondsSinceEpoch(widget.timestamp).hour}:${DateTime.fromMillisecondsSinceEpoch(widget.timestamp).minute}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                    overflow: TextOverflow.ellipsis)
              ],
            ),
          )
        ],
      ),
    );
  }
}
