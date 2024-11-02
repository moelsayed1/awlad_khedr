import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/app_router.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                mainColor,
                Colors.white,
              ],
            )),
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Center(
                  child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Image.asset(
                    AssetsData.logoPng,
                    width: 106,
                    height: 116,
                  ),
                ),
                const SizedBox(
                  height: 140,
                ),
                const Center(
                  child: Text(
                    'أبدأ معنا تجارتك الأن',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 45,
                        fontFamily: 'GE Dinar One',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  'أولاد خضر للتجارة والتوزيع نحن نسعي لإرضاء عملائنا الكرام وتوفير كل إحتياجاتهم',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'GE Dinar One',
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*.4,                      height: 60,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: InkWell(
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kLoginView);
                        },
                        child: const Center(
                            child: Text(
                          'الدخول',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: baseFont),
                        )),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*.4,
                      height: 60,
                      decoration: const BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: InkWell(
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kRegisterView);
                        },
                        child: const Center(
                          child: Text(
                            'سجل الأن',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: baseFont,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ])),
            ),
          ),
        ),
      ),
    );
  }
}
