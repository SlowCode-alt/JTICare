import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailTransaksiScreen extends StatefulWidget {
  final String judulDonasi;
  final String namaDonatur;
  final String email;
  final String whatsapp;
  final int nominal;
  final int kategoriDonasiId;
  final String snapToken;

  const DetailTransaksiScreen({
    super.key,
    required this.judulDonasi,
    required this.namaDonatur,
    required this.email,
    required this.whatsapp,
    required this.nominal,
    required this.kategoriDonasiId,
    required this.snapToken,
  });

  @override
  State<DetailTransaksiScreen> createState() => _DetailTransaksiScreenState();
}

class _DetailTransaksiScreenState extends State<DetailTransaksiScreen> {
  late final WebViewController _webViewController;
  bool _isLoading = true;
  bool _paymentSuccess = false;
  bool _showWebView = false;

  @override
  void initState() {
    super.initState();
    
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print('Loading progress: $progress%');
          },
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            _checkPaymentStatus(url);
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView Error: ${error.description}');
          },
          onUrlChange: (UrlChange change) {
            _checkPaymentStatus(change.url ?? '');
          },
        ),
      );
  }

  void _checkPaymentStatus(String url) {
    print('Current URL: $url');
    if (url.contains('/success') || 
        url.contains('status_code=200') || 
        url.contains('transaction_status=settlement')) {
      setState(() => _paymentSuccess = true);
    }
  }

  void _loadPaymentPage() {
    setState(() {
      _showWebView = true;
    });
    final paymentUrl = 'https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.snapToken}';
    print('Loading payment URL: $paymentUrl');
    _webViewController.loadRequest(Uri.parse(paymentUrl));
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
          onPressed: () {
            if (_paymentSuccess) {
              Navigator.pop(context, true);
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Batalkan Pembayaran?'),
                  content: const Text('Apakah Anda yakin ingin membatalkan pembayaran ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tidak'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Ya'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      body: _showWebView ? _buildWebView() : _buildTransactionDetails(formattedDate, formattedNominal),
    );
  }

  Widget _buildTransactionDetails(String formattedDate, String formattedNominal) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
                        onPressed: _loadPaymentPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Tampilkan Halaman Pembayaran',
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
            const SizedBox(height: 16),
            const Text(
              'Silakan lanjutkan pembayaran di halaman berikut:',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebView() {
    return Stack(
      children: [
        WebViewWidget(controller: _webViewController),
        if (_isLoading)
          const Center(child: CircularProgressIndicator()),
      ],
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