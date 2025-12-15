import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_app/consts/consts.dart';
import 'package:flutter_ble_app/model/data_model.dart';
import 'package:flutter_ble_app/views/scan_view.dart';
import 'package:flutter_ble_app/widgets/connection_info_widget.dart';
import 'package:flutter_ble_app/widgets/title_widget.dart';
import 'package:flutter_ble_app/widgets/led_status_button.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:gap/gap.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.dhtCharacteristic,
  });

  final BluetoothCharacteristic dhtCharacteristic;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ReceivedDataModel _dataModel;
  late BluetoothCharacteristic blecharacteristic;

  @override
  void initState() {
    blecharacteristic = widget.dhtCharacteristic;
    _dataModel = ReceivedDataModel(
      ledStatus: 0,
    );
    _listenBleData();
    super.initState();
  }

  @override
  void dispose() {
    if (blecharacteristic.device.isConnected) {
      blecharacteristic.device.disconnect();
    }
    super.dispose();
  }

  Future _sendBleData(SendDataModel dataModel) async {
    if (blecharacteristic.device.isConnected) {
      await blecharacteristic
          .write(utf8.encode(jsonEncode(dataModel.toJson())));
    }
  }

  void _listenBleData() async {
    await blecharacteristic.setNotifyValue(true);
    blecharacteristic.lastValueStream.listen(
      (value) {
        if (mounted) {
          setState(() {
            var decode = utf8.decode(value);
            _dataModel = ReceivedDataModel.fromJson(jsonDecode(decode));
          });
        }
      },
    ).onError((err) {
      if (kDebugMode) print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          const Gap(homeSizedHeight),
          const TitleWidget(title: 'BLE App', isTitle: true),
          const Gap(homeSizedHeight),
          const TitleWidget(title: 'Connection Status', isTitle: false),
          ConnectionInfoWidget(
            isConnected: blecharacteristic.device.isConnected,
            infoText: blecharacteristic.device.isConnected
                ? 'Connected to ${blecharacteristic.device.platformName}'
                : 'Disconnected',
            changeStatus: (p0) async {
              await blecharacteristic.device.disconnect();
              setState(() {});
              Future.delayed(const Duration(milliseconds: 1500)).then(
                (value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanPage()),
                ),
              );
            },
          ),
          LedStatusWidget(
            changeStatus: (p0) async {
              await _sendBleData(
                SendDataModel(
                  ledStatus: _dataModel.ledStatus == 1 ? '0' : '1',
                ),
              );
            },
            isLedOn: _dataModel.ledStatus == 1 ? true : false,
          ),
        ],
      ),
    );
  }
}
