import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/core/custom_button.dart';
import 'package:awlad_khedr/core/main_layout.dart';
import 'package:awlad_khedr/features/drawer_slider/presentation/views/widgets/popup_account_details.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../drawer_slider/controller/notification_provider.dart';
import '../../../drawer_slider/model/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationProvider>().notifications;

    return MainLayout(
      selectedIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
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
          leadingWidth: 100,
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'الاشعارات',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont),
              ),
            )
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationCard(notification: notification);
          },
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: SizedBox(
            height: 40,
            width: 40,
            child: Image.asset(
              AssetsData.logoPng,
              fit: BoxFit.contain,
            ),
          ),
          title: Text(
            notification.orderDetails,
            style: const TextStyle(
                fontSize: 12,
                fontFamily: baseFont,
                color: Colors.black,
                fontWeight: FontWeight.w700),
          ),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.status,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: baseFont,
                  )),
              const SizedBox(
                width: 6,
              ),
              Text(notification.orderNumber,
                  style: const TextStyle(color: Colors.black)),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                notification.timeAgo,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: baseFont,
                ),
              ),
              CustomButton(
                text: 'تفاصيل الاوردر',
                color: darkOrange,
                textColor: Colors.black,
                fontSize: 8,
                width: 80,
                height: 16,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const OrderDetailsPopup();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
