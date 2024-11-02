import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../constant.dart';
import '../../provider/counter_provider.dart';

class CounterVertical extends StatefulWidget {
  const CounterVertical({
    super.key,
  });

  @override
  State<CounterVertical> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterVertical> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CounterProvider>(
        builder: (context, CounterProvider counterProvider, child) {
      return Row(
        children: [
          InkWell(
            onTap: counterProvider.incrementCounter,
            child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: .5,
                      blurRadius: .5,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: const Icon(
                  Icons.add,
                  color: darkOrange,
                )),
          ),
          const SizedBox(
            width: 12,
          ),
          Text('${counterProvider.counterCount}',
              style: const TextStyle(fontSize: 18, color: Colors.black)),
          const SizedBox(
            width: 12,
          ),
          InkWell(
            onTap: counterProvider.decrementCounter,
            child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: .5,
                      blurRadius: .5,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: const Icon(
                  Icons.remove,
                  color: brownDark,
                )),
          ),
        ],
      );
    });
  }
}