import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/provider_models/qr_reader_provider.dart';
import 'package:mi_conjunto_guardas/route_arguments/success_arguments.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../constants/colors.dart' as AppColors;
import '../../constants/strings.dart' as AppStrings;
import 'package:provider/provider.dart';

/// Pantalla para activar la camara para el lector del código QR
class QrReaderPage extends StatefulWidget {
  @override
  State<QrReaderPage> createState() => _QrReaderPageState();
}

class _QrReaderPageState extends State<QrReaderPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController qrController;
  QrReaderProvider _qrReaderData;
  bool isReadingQr = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController.pauseCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    _qrReaderData = context.watch<QrReaderProvider>();

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildQrView(context),
          _buildLoading(),
          _buildCameraControlButtons(),
        ],
      ),
    );
  }

  /// Funcion para la construccion del boton de flash
  _buildCameraControlButtons() {
    return Positioned(
        top: 100,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.white24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  await qrController.toggleFlash();
                  setState(() {});
                },
                icon: FutureBuilder<bool>(
                  future: qrController?.getFlashStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return Icon(
                          snapshot.data ? Icons.flash_on : Icons.flash_off);
                    } else {
                      return Container();
                    }
                  },
                ),
                color: Colors.white,
              ),
            ],
          ),
        ));
  }

  /// Funcion para la construccion del overlay de la lectura de QR
  _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: AppColors.themeBlack,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.7),
    );
  }

  _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.qrController = controller;
    });

    qrController.scannedDataStream.listen((data) {
      setState(() async {
        qrController.dispose();
        await _readData(data.code);
      });
    });
  }

  Future<void> _readData(String data) async {
    setState(() {
      isReadingQr = true;
    });

    bool readData = await Future.delayed(
        Duration(milliseconds: 750), () => _qrReaderData.readQr(data));

    if (readData) {
      setState(() {
        isReadingQr = false;
        Navigator.pushNamed(context, AppStrings.successPageRoute,
            arguments: SuccessArguments(
                successMessage: '¡Código QR leído!',
                nextRoute: AppStrings.profilePageRoute,
                qrData: data.split(";")));
      });
    }
  }

  _buildLoading() {
    if (isReadingQr) {
      return Positioned(
          bottom: 100,
          child: CircularProgressIndicator(
            backgroundColor: AppColors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ));
    }

    return Container();
  }

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }
}
