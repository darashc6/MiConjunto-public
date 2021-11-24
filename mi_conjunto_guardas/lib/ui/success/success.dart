import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/route_arguments/success_arguments.dart';

/// Pantalla para confirmar que una accion se ha realizado correctamente.
class SuccessPage extends StatefulWidget {
  SuccessPage();

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    final SuccessArguments args =
        ModalRoute.of(context).settings.arguments as SuccessArguments;

    return WillPopScope(
      onWillPop: () => _goToNextRoute(args.nextRoute),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (args.qrData != null) _buildQrData(args.qrData),
              _buildSuccessTick(),
              SizedBox(
                height: 15,
              ),
              Text(
                args.successMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 50,
              ),
              _buildReturnButton(() => _goToNextRoute(args.nextRoute))
            ],
          ),
        ),
      ),
    );
  }

  _buildQrData(List<String> qrData) {
    return Container(
        width: 300,
        margin: EdgeInsets.only(bottom: 40.0),
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _createQrDataWidget(qrData),
        ));
  }

  _createQrDataWidget(List<String> qrData) {
    var qrDataWidget = <Text>[];

    qrData.forEach((data) => {
          qrDataWidget.add(Text(data,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )))
        });

    return qrDataWidget;
  }

  _buildSuccessTick() {
    return Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
        child: Icon(
          Icons.done,
          color: Colors.white,
          size: 125,
        ));
  }

  _buildReturnButton(Function onPress) {
    return ElevatedButton(
        onPressed: onPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text("VOLVER",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
        ));
  }

  _goToNextRoute(String nextRoute) {
    Navigator.pushNamedAndRemoveUntil(context, nextRoute, (route) => false);
  }
}
