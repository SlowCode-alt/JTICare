// transaction_result_screen.dart
import 'package:flutter/material.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';

class TransactionResultScreen extends StatelessWidget {
  final TransactionResult result;

  const TransactionResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    String message;
    Color statusColor;
    IconData statusIcon;

    switch (result.statusMessage) {
      case 'settlement':
      case 'capture':
        message = 'Pembayaran Berhasil!';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        message = 'Pembayaran Sedang Diproses';
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'deny':
      case 'cancel':
      case 'expire':
        message = 'Pembayaran Gagal: ${result.statusMessage}';
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      default:
        message = 'Status Tidak Diketahui: ${result.statusMessage}';
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Transaksi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              statusIcon,
              color: statusColor,
              size: 100,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}