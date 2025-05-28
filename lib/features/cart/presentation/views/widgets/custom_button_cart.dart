import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import '../../../../../core/assets.dart';

class CustomButtonCart extends StatefulWidget {
  CustomButtonCart(
      {super.key, required this.count, required this.onOrderConfirmed});
  double count;
  final VoidCallback onOrderConfirmed; // Callback to handle navigation

  @override
  State<CustomButtonCart> createState() => _CustomButtonCartState();
}

class _CustomButtonCartState extends State<CustomButtonCart> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(mainColor),
          ),
          onPressed: () async {
            if (widget.count >= 3000) {
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: Image.asset(
                    AssetsData.bag,
                    width: 100,
                    height: 100,
                  ),
                  content: const Text(
                    textAlign: TextAlign.center,
                    'تم تأكيد طلبك بنجاح',
                    style: TextStyle(
                        fontFamily: baseFont,
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              );
              // After dialog is closed, call the callback to navigate
              widget.onOrderConfirmed();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: darkOrange,
                  content: Text(
                    textAlign: TextAlign.center,
                    'الحد الادني للاوردر 3000 جنيه لاستكمال الطلب',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                ),
              );
            }
          },
          child: const Text(
            'اطلب الان',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: baseFont),
          ),
        ),
      ),
    );
  }
}
