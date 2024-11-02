import 'package:awlad_khedr/features/products_screen/presentation/provider/counter_provider.dart';
import 'package:awlad_khedr/features/products_screen/presentation/views/widgets/counter_virtecal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_router.dart';
import 'features/drawer_slider/controller/notification_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => CounterProvider()),
      ],
      child: const AwladKhedr(),
    ),

  );
}

class AwladKhedr extends StatelessWidget {
  const AwladKhedr({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.white,
        ),
      );
  }
}
