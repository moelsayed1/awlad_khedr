import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/core/custom_button.dart';
import 'package:awlad_khedr/core/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/app_router.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _LoginViewState();
}

class _LoginViewState extends State<RegisterView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordVisible = true;

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
                    const SizedBox(height: 100), // Space at the top
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
                      'سجل الأن',
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
                      'البريد الالكتروني',
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
                      hintText: 'janedoe@gmail.com',
                      inputType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const Text(
                      'كلمة المرور',
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
                      hintText: '********',
                      obscureText: passwordVisible,
                      prefixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(
                            () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          _passwordController;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const Text(
                      'إعادة كتابة كلمة المرور ',
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
                      hintText: '********',
                      obscureText: passwordVisible,
                      prefixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(
                                () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          _passwordController;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 72,
                    ),
                    Center(
                      child: CustomButton(
                        onTap: (){
                          GoRouter.of(context).push(AppRouter.kReservationPage);
                        },
                          text: 'دخول',
                          width: 202,
                          height: 60,
                          color: Colors.black,
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
