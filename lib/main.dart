import 'package:awlad_khedr/features/auth/register/data/provider/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/app_router.dart';
import 'features/auth/login/data/provider/login_provider.dart';
import 'features/drawer_slider/controller/notification_provider.dart';

String authToken = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  authToken = pref.getString('token') ?? '';
  // setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        // ChangeNotifierProvider(create: (context) => CounterProvider()),
      ],
      child: const AwladKhedr(),
    ),
  );
}

class AwladKhedr extends StatelessWidget {
  const AwladKhedr({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.white,
          ),
          builder: (context, child) {
            return FutureBuilder(
              future: Future.delayed(const Duration(seconds: 0)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return child!;
                }
                return const Text('');
              },
            );
          },
        );
      },
    );
  }
}
