import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project/logic/db/db_helper.dart';
import 'package:project/logic/services/languge_services.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/logic/services/theme_services.dart';
import 'package:project/logic/translation/local_string.dart';
import 'package:project/view/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: LocalString(),
      locale: LangugeServices().local,
      debugShowCheckedModeBanner: false,
      theme: Themes.ligth,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      home: const SplashScreen(),
    );
  }
}
