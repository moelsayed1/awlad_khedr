import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key});

  @override
  State<PaymentForm> createState() => PaymentFormState();
}

class PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم إرسال الطلب بنجاح!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              fontFamily: baseFont,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      fontFamily: baseFont,
    );
    final labelTextStyle = TextStyle(
      color: Colors.grey, // رمادي
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      fontFamily: baseFont,
    );
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            style: inputTextStyle,
            decoration: InputDecoration(
              labelText: 'الاسم',
              labelStyle: labelTextStyle, // <-- رمادي
              border: const OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'يرجى إدخال الاسم' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            style: inputTextStyle,
            decoration: InputDecoration(
              labelText: 'رقم الهاتف',
              labelStyle: labelTextStyle, // <-- رمادي
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value == null || value.isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _addressController,
            style: inputTextStyle,
            decoration: InputDecoration(
              labelText: 'العنوان',
              labelStyle: labelTextStyle, // <-- رمادي
              border: const OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'يرجى إدخال العنوان' : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'تأكيد الدفع',
              style: inputTextStyle.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
