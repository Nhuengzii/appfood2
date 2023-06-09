import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:appfood2/pages/add_eat_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appfood2/widgets/button_back.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class History {
  const History({
    required this.image,
    required this.unit,
    required this.foodName,
    required this.quantity,
    required this.timestamp,
  });
  final String image;
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

class _EatHistoryPageState extends State<EatHistoryPage> {
  Future<List<History>> _getHistoryData() async {
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
    return historySlots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return EatHistoryComponent(history: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error} ?? `ERR`");
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        future: _getHistoryData(),
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

  List<String> mont = [
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
                        ? '${_startDate[0]}${_startDate[1]} ${(_startDate[3] == '1') ? mont[int.parse(_startDate[3])] : mont[int.parse("${_startDate[3]}${_startDate[4]}")]} ${int.parse("${_startDate[6]}${_startDate[7]}${_startDate[8]}${_startDate[9]}") + 543}'
                        : ('${_startDate[0]}${_startDate[1]} ${(_startDate[3] == '1') ? mont[int.parse(_startDate[3])] : mont[int.parse("${_startDate[3]}${_startDate[4]}")]} ${int.parse("${_startDate[6]}${_startDate[7]}${_startDate[8]}${_startDate[9]}") + 543} - ${_endDate[0]}${_endDate[1]} ${(_endDate[3] == '1') ? mont[int.parse(_endDate[3])] : mont[int.parse("${_endDate[3]}${_endDate[4]}")]} ${int.parse("${_endDate[6]}${_endDate[7]}${_endDate[8]}${_endDate[9]}") + 543}'),
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
          unit: e.value.unit);
    }).toList();
  }

  void _updateDate(Map<String, String> interval) {
    setState(() {
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
              unit: e.value.unit);
        }).toList();
      } else if (_endDate == _startDate) {
        filteredHistorySlots = [];
        int checkstart = DateTime.parse(
                "${_startDate[6]}${_startDate[7]}${_startDate[8]}${_startDate[9]}-${_startDate[3]}${_startDate[4]}-${_startDate[0]}${_startDate[1]} 00:00:00")
            .millisecondsSinceEpoch;
        int checkend = DateTime.parse(
                "${_startDate[6]}${_startDate[7]}${_startDate[8]}${_startDate[9]}-${_startDate[3]}${_startDate[4]}-${_startDate[0]}${_startDate[1]} 12:00:00Z")
            .millisecondsSinceEpoch;
        for (var i = 0; i < widget.history.length; i++) {
          if (widget.history[i].timestamp >= checkstart &&
              checkend >= widget.history[i].timestamp) {
            filteredHistorySlots.add(HistorySlot(
              number: i,
              image: widget.history[i].unit,
              foodName: widget.history[i].foodName,
              quantity: widget.history[i].quantity,
              timestamp: widget.history[i].timestamp,
              unit: widget.history[i].unit,
            ));
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
            height: 122,
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
                      padding:
                          const EdgeInsets.only(left: 44, right: 35, top: 10),
                      child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 47,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0)),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "ประวัติการรับประทานอาหาร",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddEatHistoryPage()));
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
      required this.unit});
  final int number;
  final String image;
  final String foodName;
  final int quantity;
  final int timestamp;
  final String unit;

  @override
  State<HistorySlot> createState() => _HistorySlotState();
}

class _HistorySlotState extends State<HistorySlot> {
  late String showTime;

  @override
  void initState() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(widget.timestamp);
    showTime = "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, "0")}";
    super.initState();
  }

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
                image: NetworkImage(widget.image),
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
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "เวลา $showTime น.",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
