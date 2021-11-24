import 'package:flutter/material.dart';
import 'package:mi_conjunto_residentes/provider/parking_provider.dart';
import 'package:mi_conjunto_residentes/ui/parking/parking_info_page.dart';
import 'package:mi_conjunto_residentes/ui/web_page/web_page.dart';
import 'provider/message_provider.dart';
import 'provider/package_provider.dart';
import 'provider/receipt_provider.dart';
import 'provider/resident_provider.dart';
import 'ui/splash_screen_loading/splash_screen_loading.dart';
import 'ui/list_messages/list_messages.dart';
import 'ui/list_messages/message_page.dart';
import 'ui/login/login.dart';
import 'ui/parking/parking_main_page.dart';
import 'ui/profile/profile.dart';
import 'ui/list_items/list_items.dart';
import 'package:overlay_support/overlay_support.dart';
import 'constants/colors.dart' as AppColors;
import 'constants/strings.dart' as AppStrings;

import 'package:provider/provider.dart';

void main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ResidentProvider()),
      ChangeNotifierProvider(create: (context) => PackageProvider()),
      ChangeNotifierProvider(create: (context) => ReceiptProvider()),
      ChangeNotifierProvider(create: (context) => MessageProvider()),
      ChangeNotifierProvider(create: (context) => ParkingProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: OverlaySupport.global(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mi Conjunto Residentes',
          initialRoute: AppStrings.splashScreenPageRoute,
          routes: {
            AppStrings.splashScreenPageRoute: (context) =>
                SplashScreenLoading(),
            AppStrings.loginPageRoute: (context) => LoginPage(),
            AppStrings.profilePageRoute: (context) => ProfilePage(),
            AppStrings.listReceiptsPageRoute: (context) =>
                ItemsListPage(AppStrings.receiptsString),
            AppStrings.listPackagesPageRoute: (context) =>
                ItemsListPage(AppStrings.packagesString),
            AppStrings.listMessagesPageRoute: (context) =>
                MessagesListPage(AppStrings.messagesString),
            AppStrings.messagePageRoute: (context) => MessagePage(),
            AppStrings.parkingMainPageRoute: (context) => ParkingMainPage(),
            AppStrings.parkingInfoPageRoute: (context) => ParkingInfoPage(),
            AppStrings.webPageRoute: (context) => WebPagePage()
          },
          theme: ThemeData(
              primarySwatch: Colors.orange,
              fontFamily: "Montserrat",
              scaffoldBackgroundColor: AppColors.backgroundColor),
        ),
      ),
    );
  }
}
