import 'package:cronolab/modules/cronolab/desktop/widgets/deveresController.dart';
import 'package:cronolab/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _dateTime;
  late DateTime hoje;
  late DateTime dia1;
  late DateTime ultimoDia;
  late DeveresController calendar;
  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    hoje = DateTime(_dateTime.year, _dateTime.month, _dateTime.day);
    dia1 = DateTime(_dateTime.year, _dateTime.month, 1);
    ultimoDia = DateTime(_dateTime.year, _dateTime.month + 1, 0);

    calendar = GetIt.I.get<DeveresController>();
    calendar.buildCalendar(DateTime.now(), context);
    print("Hoje: $hoje | ${hoje.weekday}");
    print("Dia 1: $dia1 | ${dia1.weekday}");
    print("Ultimo dia: $ultimoDia | ${ultimoDia.weekday}");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: calendar.week[0].map((d) {
        return SizedBox(
            width: (MediaQuery.of(context).size.width - 40) / 7,
            height: (MediaQuery.of(context).size.width - 40) / 7,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: d?.data.isAtSameMomentAs(hoje) ?? false
                        ? primaryDark
                        : null,
                    shape: BoxShape.circle),
                child: Text(d?.data.day.toString() ?? "")));
      }).toList(),
    );

    /*return Container(
        child: Column(
            children: calendar.weeks
                .map((e) => Row(
                      children: e.map((d) {
                        print(d?.data);
                        return SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 7,
                            height:
                                (MediaQuery.of(context).size.width - 40) / 7,
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color:
                                        d?.data.isAtSameMomentAs(hoje) ?? false
                                            ? primaryDark
                                            : null,
                                    shape: BoxShape.circle),
                                child: Text(d?.data.day.toString() ?? "")));
                      }).toList(),
                    ))
                .toList()));*/
  }
}
