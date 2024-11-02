

import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/app_router.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,

          leading: IconButton(
            icon: const Icon(Icons.arrow_back , color: Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Back button

              const SizedBox(height: 16),
              // Title text
              const Center(
                child: Text(
                  'استعادة كلمة المرور',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: baseFont
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle text
              const Center(
                child: Text(
                  'الرجاء إدخال رقم هاتفك لإعادة تعيين كلمة المرور',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                      fontFamily: baseFont
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              // Phone number label
              const Text(
                'رقم هاتفك',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: baseFont
                ),
              ),
              const SizedBox(height: 10),
              // Phone number text field
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 24),
              // Reset password button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).push(AppRouter.kVerificationScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brownDark, // Button color
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'إعادة تعيين كلمة المرور',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
