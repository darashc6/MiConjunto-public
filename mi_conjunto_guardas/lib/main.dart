import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/provider_models/message_provider.dart';
import 'package:mi_conjunto_guardas/provider_models/package_provider.dart';
import 'package:mi_conjunto_guardas/provider_models/parking_provider.dart';
import 'package:mi_conjunto_guardas/provider_models/qr_reader_provider.dart';
import 'package:mi_conjunto_guardas/provider_models/receipt_provider.dart';
import 'package:mi_conjunto_guardas/provider_models/resident_provider.dart';
import 'package:mi_conjunto_guardas/provider_models/residential_block_provider.dart';
import 'package:mi_conjunto_guardas/ui/item_reception/list_residents_with_pending_items.dart';
import 'package:mi_conjunto_guardas/ui/item_reception/package_reception/new_package_received/new_package_received_info.dart';
import 'package:mi_conjunto_guardas/ui/item_reception/parking_reception/new_parking/new_parking.dart';
import 'package:mi_conjunto_guardas/ui/item_reception/parking_reception/new_parking/new_parking_info.dart';
import 'package:mi_conjunto_guardas/ui/item_reception/parking_reception/parking_exit_confirm_page.dart';
import 'package:mi_conjunto_guardas/ui/item_reception/parking_reception/parking_main_page.dart';
import 'package:mi_conjunto_guardas/ui/item_reception/parking_reception/resident_parking_active.dart';
import 'package:mi_conjunto_guardas/ui/item_reception/receipt_reception/new_receipt_received/new_receipt_received.dart';
import 'package:mi_conjunto_guardas/ui/list_residents/new_message.dart';
import 'package:mi_conjunto_guardas/ui/qr_reader/qr_reader.dart';
import 'package:mi_conjunto_guardas/ui/splash_screen_loading/splash_screen_loading.dart';
import 'package:mi_conjunto_guardas/ui/success/success.dart';
import 'ui/item_reception/package_reception/user_packages_pending/user_packages_pending.dart';
import 'ui/item_reception/receipt_reception/new_receipt_received/new_receipt_received_info.dart';
import 'ui/item_reception/receipt_reception/user_receipts_pending/user_receipts_pending.dart';
import 'ui/login/login.dart';
import 'ui/profile/profile.dart';
import 'ui/list_residents/list_residents.dart';
import 'ui/item_reception/package_reception/package_main_page.dart';
import 'ui/item_reception/receipt_reception/receipt_main_page.dart';
import 'ui/item_reception/package_reception/new_package_received/new_package_received.dart';
import 'constants/colors.dart' as AppColors;
import 'constants/strings.dart' as AppStrings;

import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ResidentialBlockProvider()),
      ChangeNotifierProvider(create: (context) => PackageProvider()),
      ChangeNotifierProvider(create: (context) => ReceiptProvider()),
      ChangeNotifierProvider(create: (context) => ResidentProvider()),
      ChangeNotifierProvider(create: (context) => MessageProvider()),
      ChangeNotifierProvider(create: (context) => ParkingProvider()),
      ChangeNotifierProvider(create: (context) => QrReaderProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mi Conjunto Guardas',
        theme: ThemeData(
            primarySwatch: customColor,
            fontFamily: "Montserrat",
            scaffoldBackgroundColor: AppColors.backgroundColor),
        initialRoute: AppStrings.initialRoute,
        routes: {
          AppStrings.initialRoute: (context) => SplashScreenLoading(),
          AppStrings.loginPageRoute: (context) => LoginPage(),
          AppStrings.profilePageRoute: (context) => ProfilePage(),
          AppStrings.residentsListPageRoute: (context) => ResidentsListPage(),
          AppStrings.packageReceptionPageRoute: (context) => PackageMainPage(),
          AppStrings.newPackageReceivedPageRoute: (context) =>
              NewPackageReceivedPage(),
          AppStrings.newPackageReceivedInfoPageRoute: (context) =>
              NewPackageReceivedInfoPage(),
          AppStrings.receiptReceptionPageRoute: (context) => ReceiptMainPage(),
          AppStrings.newReceiptReceivedPageRoute: (context) =>
              NewReceiptReceivedPage(),
          AppStrings.newReceiptReceivedPageInfoRoute: (context) =>
              NewReceiptReceivedInfoPage(),
          AppStrings.residentsListWithPackagesPendingPageRoute: (context) =>
              ListResidentsWithPendingItems(),
          AppStrings.residentsListWithReceiptsPendingPageRoute: (context) =>
              ListResidentsWithPendingItems(),
          AppStrings.residentPackagesPendingPageRoute: (context) =>
              UserPackagesPendingPage(),
          AppStrings.residentReceiptsPendingPageRoute: (context) =>
              UserReceiptsPendingPage(),
          AppStrings.newMessagePage: (context) => NewMessagePage(),
          AppStrings.parkingMainPageRoute: (context) => ParkingMainPage(),
          AppStrings.residentsListWithParkingActivePageRoute: (context) =>
              ListResidentsWithPendingItems(),
          AppStrings.newParkingPageRoute: (context) => NewParkingPage(),
          AppStrings.newParkingInfoPageRoute: (context) => NewParkingInfoPage(),
          AppStrings.residentParkingPageRoute: (context) =>
              ResidentParkingActivePage(),
          AppStrings.residentParkingExitRoute: (context) =>
              ParkingExitConfirmedPage(),
          AppStrings.successPageRoute: (context) => SuccessPage(),
          AppStrings.qrReaderPageRoute: (context) => QrReaderPage()
        },
      ),
    );
  }
}

const MaterialColor customColor = MaterialColor(0xFF000000, const <int, Color>{
  50: const Color(0xFF000000),
  100: const Color(0xFF000000),
  200: const Color(0xFF000000),
  300: const Color(0xFF000000),
  400: const Color(0xFF000000),
  500: const Color(0xFF000000),
  600: const Color(0xFF000000),
  700: const Color(0xFF000000),
  800: const Color(0xFF000000),
  900: const Color(0xFF000000),
});
