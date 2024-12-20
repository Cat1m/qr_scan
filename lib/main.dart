// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Scanner Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _scanResult = 'Chưa quét mã';
  String _continuousScanResult = 'Chưa quét mã';

  Future<void> startBarcodeScan() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Màu của đường quét
        'Hủy', // Text nút hủy
        true, // Hiển thị icon đèn pin
        ScanMode.DEFAULT, // Chế độ quét
      );
    } catch (e) {
      barcodeScanRes = 'Không thể quét mã: $e';
    }

    if (!mounted) return;

    setState(() {
      _scanResult = barcodeScanRes;
    });
  }

  void startContinuousScan() {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
      '#ff6666',
      'Hủy',
      true,
      ScanMode.DEFAULT,
    )?.listen((barcode) {
      if (!mounted) return;

      setState(() {
        _continuousScanResult = barcode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét Mã Vạch Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: startBarcodeScan,
              child: const Text('Quét Một Lần'),
            ),
            const SizedBox(height: 20),
            Text('Kết quả quét một lần: $_scanResult'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: startContinuousScan,
              child: const Text('Quét Liên Tục'),
            ),
            const SizedBox(height: 20),
            Text('Kết quả quét liên tục: $_continuousScanResult'),
          ],
        ),
      ),
    );
  }
}
