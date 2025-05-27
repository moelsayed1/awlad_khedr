
import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/core/custom_button.dart';
import 'package:awlad_khedr/core/custom_text_field.dart';
import 'package:awlad_khedr/features/auth/ticket_reserve/presentation/views/widgets/custom_add_file.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/app_router.dart';
import '../../../register/data/provider/register_provider.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _marketNameController = TextEditingController();
  bool isAgreed = false;

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: -130,
                right: -70,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: const BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 80),
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
                    CustomTextField(
                      controller: _phoneController,
                      hintText: '0102******',
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
                    CustomTextField(
                      controller: _addressController,
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
                    CustomTextField(
                      controller: _marketNameController,
                      hintText: '',
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const Text(
                      'صورة الماركت',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    CustomAddFile(
                      onFilePicked: (file) {
                        registerProvider.saveFiles(marketImage: file);
                      },
                    ),
                    const SizedBox(
                      height: 22,
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
                    CustomAddFile(
                      onFilePicked: (file) {
                        registerProvider.saveFiles(commercialRegister: file);
                      },
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    const Text(
                      'بطاقة ضربيبة',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    CustomAddFile(
                      onFilePicked: (file) {
                        registerProvider.saveFiles(taxCard: file);
                      },
                    ),

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
                          onTap: isAgreed
                              ? () async {
                                  await registerProvider.register({
                                    "mobile": _phoneController.text.trim(),
                                    "address_line_1":
                                        _addressController.text.trim(),
                                    "supplier_business_name":
                                        _marketNameController.text.trim(),
                                  });
                                  if (registerProvider.message != null) {
                                    GoRouter.of(context)
                                        .push(AppRouter.kSuccessScreen);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text(registerProvider.message!)),
                                    );
                                  }
                                }
                              : null,
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
