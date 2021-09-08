import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';

class AddFormControlCard extends StatefulWidget {
  const AddFormControlCard({Key? key}) : super(key: key);

  @override
  _AddFormControlCardState createState() => _AddFormControlCardState();
}

class _AddFormControlCardState extends State<AddFormControlCard> {
  TextEditingController ctrlVstdate = TextEditingController();
  TextEditingController ctrlInFluid = TextEditingController();
  TextEditingController ctrlOutFluid = TextEditingController();
  TextEditingController ctrlVolume = TextEditingController();
  TextEditingController ctrlInFluidOut = TextEditingController();
  TextEditingController ctrlOutFluidOut = TextEditingController();
  TextEditingController ctrlVolumeOut = TextEditingController();
  TextEditingController ctrlSumVolume = TextEditingController();
  TextEditingController ctrlNewRoundPicker = TextEditingController();
  TextEditingController ctrlNewRoundTime = TextEditingController();

  final items = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
  final ifluid = ['1.5', '2', '2.5', '3'];
  final kindFluidColor = ['แดงจาง+ใส', 'เหลือง+ใส'];
  String? _numof;
  String? _ifluid;
  String? _kindFluidColor;
  DateTime? date;
  DateTime? newRoundDate;
  TimeOfDay? _timeInFluid;
  TimeOfDay? _timeOutFluid;
  TimeOfDay? _timeInFluidOut;
  TimeOfDay? _timeOutFluidOut;

  DateTime? roundDateTime;
  DateTime? newRoundTime;

  Future<Null> pickRoundTime(BuildContext context) async {
    final initialTime = TimeOfDay(
      hour: DateTime.now().hour,
      minute: DateTime.now().minute,
    );
    final rTime = await CupertinoRoundedDatePicker.show(
      context,
      use24hFormat: true,
      era: EraMode.BUDDHIST_YEAR,
      textColor: Colors.black,
      background: Colors.white70,
      borderRadius: 16,
      initialDatePickerMode: CupertinoDatePickerMode.time,
      onDateTimeChanged: (rTime) {
        if (rTime == null) return;
        setState(() {
          newRoundTime = rTime;
          print(newRoundTime);
          ctrlNewRoundTime.text = DateFormat('HH:mm').format(newRoundTime!);
        });
      },
    );
  }

  Future<Null> pickRoundDT(BuildContext context) async {
    DateTime? rDT = await showRoundedDatePicker(
        textPositiveButton: 'ตกลง',
        textNegativeButton: 'ยกเลิก',
        context: context,
        locale: Locale('th', 'TH'),
        era: EraMode.BUDDHIST_YEAR);
    if (rDT == null) return;

    setState(() {
      newRoundDate = rDT;
      print(newRoundDate);
      ctrlNewRoundPicker.text = DateFormat('yyyy-MM-dd').format(newRoundDate!);
    });
  }

  /** ตรวจสอบข้อมูลก่อนส่ง API */
  Future<Null> prepareData() async {
    print('''##### ${ctrlVstdate.text}, $_numof, $_ifluid,
        ${ctrlInFluid.text}, ${ctrlOutFluid.text}, ${ctrlVolume.text},
         ${ctrlOutFluid.text}, ${ctrlOutFluidOut.text}, ${ctrlVolumeOut.text},
         ${ctrlSumVolume.text}, $_kindFluidColor #####''');
  }

  // ตรวจสอบ กำไร/ขาดทุน
  bool isLoss = false;

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      );

  DropdownMenuItem<String> buildMenuItemFluid(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      );

  DropdownMenuItem<String> buildMenuItemKindFluidColor(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
        ),
      );

  Future<Null> pickVstdate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      locale: const Locale('th', 'TH'),
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) return;

    setState(() {
      date = newDate;
      ctrlVstdate.text = DateFormat('yyyy-MM-dd').format(date!);
    });
  }

// เวลาเริ่มน้ำยาเข้า
  Future<Null> pickTimeInFluid(BuildContext context) async {
    final initialTime = TimeOfDay(
      hour: DateTime.now().hour,
      minute: DateTime.now().minute,
    );
    final newTime = await showTimePicker(
      context: context,
      initialTime: _timeInFluid ?? initialTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime == null) return;

    setState(() {
      _timeInFluid = newTime;
      ctrlInFluid.text = _timeInFluid!.format(context);
    });
  }

  String getTimeInFluid() {
    if (_timeInFluid == null) {
      return 'เลือกเวลา';
    } else {
      return '${_timeInFluid!.hour}:${_timeInFluid!.minute}';
    }
  }

// เวลาสิ้นสุดน้ำยาเข้า
  Future<Null> pickTimeOutFluid(BuildContext context) async {
    final initialTime = TimeOfDay(
      hour: DateTime.now().hour,
      minute: DateTime.now().minute,
    );
    final newTime = await showTimePicker(
      context: context,
      initialTime: _timeOutFluid ?? initialTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime == null) return;

    setState(() {
      _timeInFluid = newTime;
      ctrlOutFluid.text = _timeInFluid!.format(context);
    });
  }

  String getTimeOutFluid() {
    if (_timeOutFluid == null) {
      return 'เลือกเวลา';
    } else {
      return '${_timeOutFluid!.hour}:${_timeOutFluid!.minute}';
    }
  }

// คำนวณปริมาตรน้ำยา
  void calculateVolume(int volumeIn, int volumeOut) {
    ctrlSumVolume.text = (volumeOut - volumeIn).toString();
    setState(() {
      if (volumeOut - volumeIn >= 0) {
        isLoss = true;
      } else {
        isLoss = false;
      }
    });
  }

// เวลาเริ่มน้ำยาออก
  Future<Null> pickTimeInFluidOut(BuildContext context) async {
    final initialTime = TimeOfDay(
      hour: DateTime.now().hour,
      minute: DateTime.now().minute,
    );
    final newTime = await showTimePicker(
      context: context,
      initialTime: _timeInFluidOut ?? initialTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime == null) return;

    setState(() {
      _timeInFluidOut = newTime;
      ctrlInFluidOut.text = _timeInFluidOut!.format(context);
    });
  }

  // เวลาสิ้นสุดน้ำยาออก
  Future<Null> pickTimeOutFluidOut(BuildContext context) async {
    final initialTime = TimeOfDay(
      hour: DateTime.now().hour,
      minute: DateTime.now().minute,
    );
    final newTime = await showTimePicker(
      context: context,
      initialTime: _timeOutFluidOut ?? initialTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime == null) return;

    setState(() {
      _timeOutFluidOut = newTime;
      ctrlOutFluidOut.text = _timeOutFluidOut!.format(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Card'),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.group_add),
                        title: const Text('บันทึกข้อมูล CAPD'),
                        subtitle: Text(
                          'ระบบข้อมูล Capd ตามรอบ',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                      const Divider(),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onTap: () => pickVstdate(context),
                              controller: ctrlVstdate,
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'วันที่บันทึก',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                      labelText: 'ครั้งที่/รอบที่',
                                      border: OutlineInputBorder()),
                                  value: _numof,
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: Colors.black54),
                                  isExpanded: true,
                                  items: items.map(buildMenuItem).toList(),
                                  onChanged: (numof) =>
                                      setState(() => _numof = numof)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                      labelText: 'ชนิดของน้ำยา',
                                      border: OutlineInputBorder()),
                                  value: _ifluid,
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: Colors.black54),
                                  isExpanded: true,
                                  items:
                                      ifluid.map(buildMenuItemFluid).toList(),
                                  onChanged: (ifluid) =>
                                      setState(() => _ifluid = ifluid)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onTap: () => pickTimeInFluid(context),
                              controller: ctrlInFluid,
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'เวลาเริ่ม(น้ำยาเข้า)',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onTap: () => pickTimeOutFluid(context),
                              controller: ctrlOutFluid,
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'เวลาสิ้นสุด(น้ำยาเข้า)',

                                // prefixIcon: IconButton(
                                //   icon: const Icon(Icons.calendar_today),
                                //   onPressed: () => pickVstdate(context),
                                // ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onTap: () => () {},
                              controller: ctrlVolume,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'ปริมาตร(น้ำยาเข้า)',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onTap: () => pickTimeInFluidOut(context),
                              controller: ctrlInFluidOut,
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'เวลาเริ่ม(น้ำยาออก)',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onTap: () => pickTimeOutFluidOut(context),
                              controller: ctrlOutFluidOut,
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'เวลาสิ้นสุด(น้ำยาออก)',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onTap: () {},
                              controller: ctrlVolumeOut,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'ปริมาตร(น้ำยาออก)',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onTap: () => {},
                              controller: ctrlSumVolume,
                              readOnly: true,
                              keyboardType: TextInputType.none,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '(กำไร/ขาดทุน) ต่อรอบ',
                                  filled: true,
                                  fillColor:
                                      isLoss ? Colors.green : Colors.pink,
                                  prefixIcon: IconButton(
                                    onPressed: () => calculateVolume(
                                        int.parse(ctrlVolume.text),
                                        int.parse(ctrlVolumeOut.text)),
                                    icon: Icon(Icons.calculate),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                      labelText: 'ลักษณะสีน้ำยา',
                                      border: OutlineInputBorder()),
                                  value: _kindFluidColor,
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: Colors.black54),
                                  isExpanded: true,
                                  items: kindFluidColor
                                      .map(buildMenuItemKindFluidColor)
                                      .toList(),
                                  onChanged: (kindFluidColor) => setState(
                                      () => _kindFluidColor = kindFluidColor)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onTap: () => pickRoundDT(context),
                              controller: ctrlNewRoundPicker,
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'วันที่แบบใหม่',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: ctrlNewRoundTime,
                              onTap: () => pickRoundTime(context),
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'เวลาแบบใหม่',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              prepareData();
                            },
                            child: const Text('บันทึกข้อมูล'),
                          ),
                          ElevatedButton(
                            // textColor: const Color(0xFF6200EE),
                            onPressed: () {
                              // Perform some action
                            },
                            child: const Text('ยกเลิก'),
                          ),
                        ],
                      ),
                      //Image.asset('assets/card-sample-image.jpg'),
                      //Image.asset('assets/card-sample-image-2.jpg'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// class AddFormcontrolCard extends StatelessWidget {
//   const AddFormcontrolCard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Form Card'),
//       ),
//       body: ListView(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(10.0),
//                 child: Card(
//                   clipBehavior: Clip.antiAlias,
//                   child: Column(
//                     children: [
//                       ListTile(
//                         leading: Icon(Icons.group_add),
//                         title: const Text('Card title 1'),
//                         subtitle: Text(
//                           'Secondary Text',
//                           style:
//                               TextStyle(color: Colors.black.withOpacity(0.6)),
//                         ),
//                       ),
//                       const Divider(),
//                       Column(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: TextFormField(
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 labelText: 'วันที่บันทึก',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Divider(),
//                       ButtonBar(
//                         alignment: MainAxisAlignment.start,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               // Perform some action
//                             },
//                             child: const Text('บันทึกข้อมูล'),
//                           ),
//                           ElevatedButton(
//                             // textColor: const Color(0xFF6200EE),
//                             onPressed: () {
//                               // Perform some action
//                             },
//                             child: const Text('ยกเลิก'),
//                           ),
//                         ],
//                       ),
//                       //Image.asset('assets/card-sample-image.jpg'),
//                       //Image.asset('assets/card-sample-image-2.jpg'),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
