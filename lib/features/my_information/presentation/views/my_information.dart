import 'package:awlad_khedr/core/custom_text_field.dart';
import 'package:awlad_khedr/core/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../constant.dart';
import '../../../../core/assets.dart';
import '../../../../core/custom_button.dart';

class MyInformation extends StatelessWidget {
  const MyInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading:InkWell(
            onTap: (){GoRouter.of(context).pop();},
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
          ) ,
          leadingWidth: 100,
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text('بيانات الاساسية' , style: TextStyle(fontSize: 20,color: Colors.black,  fontWeight: FontWeight.bold, fontFamily: baseFont),),
            )
          ],
        ),
        body:  Padding(
          padding:  const EdgeInsets.all(18.0),
          child:  SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('الاسم'
                ,style: TextStyle(
                    fontSize: 18,
                    fontFamily: baseFont,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8,),
                const CustomTextField(
                  hintText: 'محمد عبدالعالي',
                 prefixIcon: Icon(Icons.edit),
                  radius: 10,
                ),
                const SizedBox(height: 16,),
                const Text('رقم التليفون',style: TextStyle(
                  fontSize: 18,
                  fontFamily: baseFont,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),),
                const SizedBox(height: 8,),
                const CustomTextField(
                  hintText: '+20 010 16 087 103',
                  prefixIcon: Icon(Icons.edit),
                  radius: 10,
                ),
                const SizedBox(height: 16,),
                const Text('البريد الالكتروني',style: TextStyle(
                  fontSize: 18,
                  fontFamily: baseFont,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),),
                const SizedBox(height: 8,),
                const CustomTextField(
                  hintText: 'ashfaksayem@gmail.com',
                  prefixIcon: Icon(Icons.edit),
                  radius: 10,
                ),
                const SizedBox(height: 16,),
                const Text('عنوان الماركت',style: TextStyle(
                  fontSize: 18,
                  fontFamily: baseFont,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),),
                const SizedBox(height: 8,),
                const CustomTextField(
                  hintText: '------------',
                  prefixIcon: Icon(Icons.edit),
                  radius: 10,
                ),
                const SizedBox(height: 16,),
                const Text('اسم الماركت',style: TextStyle(
                  fontSize: 18,
                  fontFamily: baseFont,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),),
                const SizedBox(height: 8,),
                const CustomTextField(
                  hintText: '-----------------',
                  prefixIcon: Icon(Icons.edit),
                  radius: 10,
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: CustomButton(
                    text:'حفظ التعديلات' ,
                    textColor: Colors.white ,
                    color: darkOrange,
                    fontSize: 18,
                    width: 154,
                    height:40 ,
                  ),
                ),
               const SizedBox(height: 8,),
                Center(
                  child: CustomButton(
                    text:'خروج' ,
                    textColor: Colors.black ,
                    color: buttonColor,
                    fontSize: 18,
                    width: 154,
                    height:40 ,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
