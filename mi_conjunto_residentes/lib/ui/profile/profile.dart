import 'package:firebase_messaging/firebase_messaging.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:mi_conjunto_residentes/arguments/parking_arguments.dart';
import 'package:mi_conjunto_residentes/provider/message_provider.dart';
import 'package:mi_conjunto_residentes/provider/package_provider.dart';
import 'package:mi_conjunto_residentes/provider/receipt_provider.dart';
import 'package:mi_conjunto_residentes/ui/profile/item_button.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'info_card.dart';
import "../../constants/colors.dart" as AppColors;
import '../../constants/strings.dart' as AppStrings;
import '../common/orange_gradient_container.dart';
import 'package:vibration/vibration.dart';

import 'package:provider/provider.dart';
import '../../provider/resident_provider.dart';
import '../../arguments/list_arguments.dart';

/// Página de perfil del residente
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _residentData = context.watch<ResidentProvider>();
    final _packageData = context.watch<PackageProvider>();
    final _receiptData = context.watch<ReceiptProvider>();
    final _messageData = context.watch<MessageProvider>();

    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.public, color: Colors.black, size: 25),
                onPressed: () {
                  Navigator.pushNamed(context, AppStrings.webPageRoute);
                }),
            centerTitle: true,
            title: Text(
              "Perfil de Residente",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14),
            ),
            flexibleSpace: OrangeGradientContainer(),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.black,
                    size: 25.0,
                  ),
                  onPressed: () async {
                    await _removeLoginCredentials();
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppStrings.loginPageRoute, (route) => false);
                  })
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: FutureBuilder<void>(
              future: Future.delayed(Duration(milliseconds: 250), () async {
                await _saveFcmDeviceToken(_residentData);

                final residentId = _residentData.getResident.residentId;
                await _packageData.fetchPackages(residentId);
                await _receiptData.fetchReceipts(residentId);
                await _messageData.fetchMessages(residentId);

                FirebaseMessaging.onMessage.listen((RemoteMessage message) {
                  RemoteNotification notification = message.notification;
                  Map<String, dynamic> extra = message.data;

                  Vibration.vibrate(duration: 250);
                  showSimpleNotification(
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 4.0),
                          child: Text(
                            notification.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                      leading: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: _showImageNotification(extra["type"]),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 8.0),
                        child: Text(notification.body,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      background:
                          _setNotificationBackgroundColor(extra["type"]),
                      duration: Duration(seconds: 3));

                  print("Got a message whilst in the foreground!");
                });

                FirebaseMessaging.onBackgroundMessage(
                    _firebaseMessagingBackgroundHandler);
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: AppColors.backgroundColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.themeOrange),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ProfileInfoCard(
                        resident: _residentData.getResident,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 35,
                          children: [
                            ItemButton(
                              buttonName: AppStrings.receiptsString,
                              assetButtonIcon: "assets/receipts_icon.png",
                              linearColors: AppColors.gradientGreen,
                              pending:
                                  (_receiptData.getReceiptsPending.isNotEmpty)
                                      ? _receiptData.getReceiptsPending.length
                                          .toString()
                                      : null,
                              onPress: () {
                                Navigator.pushNamed(
                                    context, AppStrings.listReceiptsPageRoute,
                                    arguments: ListArguments(
                                        pendingList:
                                            _receiptData.getReceiptsPending,
                                        receivedList:
                                            _receiptData.getReceiptsReceived,
                                        itemType: AppStrings.itemTypeReceipt));
                              },
                            ),
                            ItemButton(
                              buttonName: AppStrings.packagesString,
                              assetButtonIcon: "assets/packages_icon.png",
                              linearColors: AppColors.gradientBrown,
                              pending:
                                  (_packageData.getPackagesPending.isNotEmpty)
                                      ? _packageData.getPackagesPending.length
                                          .toString()
                                      : null,
                              onPress: () {
                                Navigator.pushNamed(
                                    context, AppStrings.listPackagesPageRoute,
                                    arguments: ListArguments(
                                        pendingList:
                                            _packageData.getPackagesPending,
                                        receivedList:
                                            _packageData.getPackagesReceived,
                                        itemType: AppStrings.itemTypePackage));
                              },
                            ),
                            ItemButton(
                              buttonName: AppStrings.parkingString,
                              assetButtonIcon: "assets/parking_icon.png",
                              linearColors: AppColors.gradientBlue,
                              pending: (_residentData.getResident.parkingActive)
                                  ? " "
                                  : null,
                              onPress: () {
                                Navigator.pushNamed(
                                    context, AppStrings.parkingMainPageRoute,
                                    arguments: ParkingArguments(
                                        parkingActive: _residentData
                                            .getResident.parkingActive));
                              },
                            ),
                            ItemButton(
                              buttonName: AppStrings.messagesString,
                              assetButtonIcon: "assets/messages_icon.png",
                              linearColors: AppColors.gradientViolet,
                              pending: (_messageData.getMessages
                                      .where((message) => !message.isRead)
                                      .isNotEmpty)
                                  ? _messageData.getMessages
                                      .where((message) => !message.isRead)
                                      .length
                                      .toString()
                                  : null,
                              onPress: () {
                                Navigator.pushNamed(context,
                                        AppStrings.listMessagesPageRoute,
                                        arguments: ListArguments(
                                            messagesList:
                                                _messageData.getMessages))
                                    .then((value) => setState(() {}));
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )),
    );
  }

  /// Guarda el token de dispositivo en la base de datos
  /// Ese token será utilizado luego para las notificaciones de encomiendas y recibos
  Future<void> _saveFcmDeviceToken(ResidentProvider residentData) async {
    String deviceToken = await FirebaseMessaging.instance.getToken();
    await residentData.saveDeviceToken(
        residentData.getResident.residentId, deviceToken);
  }

  /// Quita las credenciales de login guardadas en el dispositivo
  /// Ejecutado cuando el residente hace log out de la aplicación
  Future<void> _removeLoginCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("email");
    await prefs.remove("passwords");
  }

  Image _showImageNotification(String itemType) {
    switch (itemType) {
      case AppStrings.notificationsItemTypeReceipt:
        return Image.asset("assets/receipts_icon.png");
        break;
      case AppStrings.notificationsItemTypePackage:
        return Image.asset("assets/packages_icon.png");
        break;
      case AppStrings.notificationsItemTypeParking:
        return Image.asset("assets/parking_icon.png");
        break;
      default:
        return Image.asset("assets/messages_icon.png");
        break;
    }
  }

  Color _setNotificationBackgroundColor(String itemType) {
    switch (itemType) {
      case AppStrings.notificationsItemTypeReceipt:
        return AppColors.lightGreen;
        break;
      case AppStrings.notificationsItemTypePackage:
        return AppColors.lightBrown;
        break;
      case AppStrings.notificationsItemTypeParking:
        return AppColors.lightBlue;
        break;
      default:
        return AppColors.lightViolet;
        break;
    }
  }
}

/// Función para reconocer notificaciones cuando la app está en el fondo o inactiva
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.notification.title}");
}
