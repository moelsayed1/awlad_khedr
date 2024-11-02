import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';

class CustomButtonReceipt extends StatelessWidget {
  const CustomButtonReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(mainColor),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const ReceiptOrderDetails();
              },
            );
          },
          child: const Text(
            'فاتورة الطلب',
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

class ReceiptOrderDetails extends StatelessWidget {
  const ReceiptOrderDetails({super.key});

  Widget _buildOrderItem(String name, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8 , vertical:4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Column(
              children: [
                Text(
                  'فاتورة  الطلب ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: baseFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Divider(thickness: 2,color: darkOrange,indent: 100,endIndent: 100,),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '3000 ج,م',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'اجمالي الفاتورة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

              ],
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                _buildOrderItem('خصم', '0.00 ج,م',),
                _buildOrderItem('مجموع السعر', '2.924.39 ج,م', ),
                _buildOrderItem('مجموع السعر', '30.71 ج,م',),
                _buildOrderItem('طريقة الدفع', 'دفع الاجل',),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
