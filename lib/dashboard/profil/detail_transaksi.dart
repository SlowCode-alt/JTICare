import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:project_akhir_donasi_android/API/midtrans_service.dart';
import 'package:project_akhir_donasi_android/dashboard/TransactionResultScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DetailTransaksiScreen extends StatefulWidget {
  final String judulDonasi;
  final String namaDonatur;
  final String email;
  final String whatsapp;
  final int nominal;
  final int kategoriDonasiId;

  const DetailTransaksiScreen({
    super.key,
    required this.judulDonasi,
    required this.namaDonatur,
    required this.email,
    required this.whatsapp,
    required this.nominal,
    required this.kategoriDonasiId,
  });

  @override
  State<DetailTransaksiScreen> createState() => _DetailTransaksiScreenState();
}

class _DetailTransaksiScreenState extends State<DetailTransaksiScreen> {
  late MidtransSDK _midtrans;
  bool _isMidtransReady = false;
  bool _isProcessingPayment = false;
  late MidtransService _midtransService;

  @override
  void initState() {
    super.initState();
    _midtransService = MidtransService(
      baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000/api',
      authToken: null, // Add your auth token if needed
    );
    _initMidtransSDK();
  }

  Future<void> _initMidtransSDK() async {
    try {
      final clientKey =
          dotenv.env['MIDTRANS_CLIENT_KEY'] ?? 'SB-Mid-client-MLuYAEYGBy0qPr8V';

      _midtrans = await MidtransSDK.init(
        config: MidtransConfig(
          clientKey: clientKey,
          merchantBaseUrl: dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000',
          colorTheme: ColorTheme(
            colorPrimary: Colors.blue,
            colorPrimaryDark: Colors.blue[800],
            colorSecondary: Colors.grey,
          ),
        ),
      );

      await _midtrans.setUIKitCustomSetting(
        skipCustomerDetailsPages: true,
      );

      _midtrans.setTransactionFinishedCallback(_handlePaymentResult);

      setState(() => _isMidtransReady = true);
    } catch (e, stack) {
      print('Midtrans init error: $e\n$stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Gagal menginisialisasi pembayaran: ${e.toString()}')),
        );
      }
    }
  }

  void _handlePaymentResult(TransactionResult result) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionResultScreen(result: result),
      ),
    );
  }

  Future<void> _processPayment() async {
    if (!_isMidtransReady) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sistem pembayaran belum siap')),
      );
      return;
    }

    setState(() => _isProcessingPayment = true);

    try {
      final response = await _midtransService
          .createCharge(
            nominal: widget.nominal.toString(),
            nama: widget.namaDonatur,
            email: widget.email,
            telepon: widget.whatsapp,
            kategoriDonasiId: widget.kategoriDonasiId,
          )
          .timeout(const Duration(seconds: 30));

      if (response['success'] == true) {
        try {
          await _midtrans.startPaymentUiFlow(
            token: response['snap_token'],
          );
        } catch (error) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error pembayaran: $error')),
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response['message'] ?? 'Gagal memproses pembayaran')),
        );
      }
    } on SocketException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada koneksi internet')),
      );
    } on TimeoutException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Timeout koneksi')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pembayaran gagal: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessingPayment = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
    final formattedNominal = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(widget.nominal);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Transaksi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Tanggal', formattedDate),
                    const Divider(),
                    _buildDetailRow('Kategori Donasi', widget.judulDonasi),
                    const Divider(),
                    _buildDetailRow('Nama Donatur', widget.namaDonatur),
                    const Divider(),
                    _buildDetailRow('Email', widget.email),
                    const Divider(),
                    _buildDetailRow('No. WhatsApp', widget.whatsapp),
                    const Divider(),
                    _buildDetailRow('Nominal', formattedNominal),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _isProcessingPayment ? null : _processPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isProcessingPayment
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Bayar Sekarang',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
