import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/core/custom_button.dart';
import 'package:awlad_khedr/core/custom_text_field.dart';
import 'package:awlad_khedr/features/auth/ticket_reserve/presentation/views/widgets/custom_add_file.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/app_router.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _LoginViewState();
}

class _LoginViewState extends State<ReservationPage> {
  bool passwordVisible = true;
  bool isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: -130, // Adjust this to move the circle up/down
                right: -70, // Adjust this to move the circle left/right
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: const BoxDecoration(
                    color: mainColor, // Your yellow color
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 80), // Space at the top
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            AssetsData.back,
                            color: Colors.black,
                          ),
                          const Text(
                            'للخلف',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontFamily: baseFont,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'أكمل التسجيل',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                      endIndent: 10,
                      indent: 230,
                      color: Colors.black45,
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                    const Text(
                      'رقم التليفون',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const CustomTextField(
                      hintText: '01022558665',
                      inputType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const Text(
                      'عنوان الماركت',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const CustomTextField(
                      hintText: '',
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const Text(
                      'اسم الماركت ',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const CustomTextField(
                      hintText: '',
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const Text(
                      'سجل التجاري',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                   const SizedBox(
                      height: 14,
                    ),
                    const CustomAddFile(),
                    const SizedBox(
                      height: 22,
                    ),
                    const Text('بطاقة ضربيبة',
                        style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: baseFont),),
                    const SizedBox(
                      height: 14,
                    ),
                    const CustomAddFile(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'أوافُق أن البيانات التي تم إدخالها صحيحة',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        Checkbox(
                          value: isAgreed,
                          onChanged: (value) {
                            setState(() {
                              isAgreed = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                    Center(
                      child: CustomButton(
                          onTap: () {
                            if(isAgreed == true) {
                              GoRouter.of(context).push(
                                  AppRouter.kSuccessScreen);
                            }
                          },
                          text: 'انتهاء',
                          width: 202,
                          height: 60,
                          color: isAgreed ? Colors.black : Colors.grey,
                          textColor: Colors.white,
                          fontSize: 30),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
