import 'package:flutter/material.dart';

class CustomAddFile extends StatefulWidget {
  const CustomAddFile({super.key});

  @override
  State<CustomAddFile> createState() => _CustomAddFileState();
}

class _CustomAddFileState extends State<CustomAddFile> {
  @override
  Widget build(BuildContext context) {
    return   Container(
      height: 30,
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'photo.jpg',
            style: TextStyle(fontSize: 14 , color: Colors.black),
          ),
          const Spacer(),
          ElevatedButton(

            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Color(0xffBF964A)),
            ),
            onPressed: () {
              // Add your file picker logic here
            },
            child: const Text(
              'إرفاق الملف',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
