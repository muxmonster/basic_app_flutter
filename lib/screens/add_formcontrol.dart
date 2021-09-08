import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

class AddFormControl extends StatefulWidget {
  const AddFormControl({Key? key}) : super(key: key);

  @override
  _AddFormControlState createState() => _AddFormControlState();
}

class _AddFormControlState extends State<AddFormControl> {
  DateTime? date;
  TimeOfDay? time;
  TextEditingController ctrlTime = TextEditingController();

  String getText() {
    if (date == null) {
      return 'Select Date';
    } else {
      //return '${date!.day}/${date!.month}/${date!.year}';
      return DateFormat('yyyy-MM-dd').format(date!);
    }
  }

  String getTime() {
    if (time == null) {
      return 'เลือกเวลา';
    } else {
      return '${time!.hour}:${time!.minute}';
    }
  }

  Future<Null> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) return;

    setState(() {
      date = newDate;
    });
  }

  Future<Null> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(
      hour: DateTime.now().hour,
      minute: DateTime.now().minute,
    );
    final newTime = await showTimePicker(
      context: context,
      initialTime: time ?? initialTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime == null) return;

    setState(() {
      time = newTime;
      ctrlTime.text = '${time!.hour}:${time!.minute}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Form Control'),
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: ElevatedButton.icon(
                  onPressed: () {
                    pickDate(context);
                  },
                  icon: const Icon(Icons.schedule),
                  label: Text(
                    'เลือกวันที่ : ${getText()}',
                  ),
                ),
              ),
              Container(
                child: ElevatedButton.icon(
                  onPressed: () {
                    pickTime(context);
                  },
                  icon: const Icon(Icons.timelapse),
                  label: Text(
                    'เลือกเวลา : ${getTime()}',
                  ),
                ),
              ),
              Container(
                child: TextFormField(controller: ctrlTime),
              )
            ],
          ),
        ],
      ),
    );
  }
}
