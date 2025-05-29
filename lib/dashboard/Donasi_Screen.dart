import 'package:flutter/material.dart';
import 'package:project_akhir_donasi_android/API/midtrans_service.dart';
import '../models/donasi_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'detail_transaksi.dart';


class DonasiScreen extends StatefulWidget {
  final Donasi donasi;

  const DonasiScreen({super.key, required this.donasi});

  @override
  State<DonasiScreen> createState() => _DonasiScreenState();
}

class _DonasiScreenState extends State<DonasiScreen> {
  String _userFullName = '';
  String _userEmail = '';
  String _userPhone = '';
  String _userId = ''; // Tambahkan userId
  bool _isLoadingUserData = true;
  final TextEditingController _manualAmountController = TextEditingController();
  bool _isAnonymous = false;
  String? _selectedAmount;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    print('Mengambil data dari SharedPreferences...');
    final userId = prefs.getInt('user_id'); // BUKAN getString
    print('User ID: $userId');

    setState(() {
      _userFullName = prefs.getString('fullname') ?? 'Nama Pengguna';
      _userEmail = prefs.getString('email') ?? 'email@example.com';
      _userPhone = prefs.getString('whatsapp') ?? 'Nomor tidak tersedia';
      _userId = _userId ;
      _isLoadingUserData = false;
    });
  } catch (e) {
    print('Error saat load user data: $e');
  }
}


  void _formatCurrency(String value) {
    if (value.isNotEmpty) {
      final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
      final parsedValue = int.tryParse(cleanValue) ?? 0;
      final formattedValue = NumberFormat.currency(
        locale: 'id',
        symbol: '',
        decimalDigits: 0,
      ).format(parsedValue);

      _manualAmountController.value = _manualAmountController.value.copyWith(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      );

      if (_selectedAmount != null && value != _selectedAmount?.replaceAll('Rp ', '')) {
        setState(() {
          _selectedAmount = null;
        });
      }
    }
  }

  void _handleAmountSelection(String amount) {
    final numericValue = amount.replaceAll('Rp ', '').replaceAll('.', '');
    setState(() {
      _selectedAmount = amount;
      _manualAmountController.text = numericValue;
      _formatCurrency(numericValue);
    });
  }

 Future<void> _processDonation() async {
  if (!mounted) return;

  final amountText = _selectedAmount ??
      (_manualAmountController.text.isNotEmpty
          ? 'Rp ${_manualAmountController.text}'
          : null);

  if (amountText == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Silakan pilih atau masukkan nominal donasi')),
    );
    return;
  }

  final cleanAmount = amountText.replaceAll('Rp ', '').replaceAll('.', '');
  final nominal = int.tryParse(cleanAmount) ?? 0;

  if (nominal <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nominal donasi tidak valid')),
    );
    return;
  }

  final midtrans = MidtransService(baseUrl: 'http://10.0.2.2:8000/api'); // Ganti sesuai base URL kamu

  final response = await midtrans.createCharge(
    nominal: nominal,
    nama: _isAnonymous ? 'Anonymous' : _userFullName,
    email: _userEmail,
    telepon: _userPhone,
    kategoriDonasiId: widget.donasi.id,
    userId: _userId, // Kirim user_id ke MidtransService
  );

  if (!response['success']) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal membuat transaksi: ${response['message']}')),
    );
    return;
  }

  final snapToken = response['snap_token'];

  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailTransaksiScreen(
      judulDonasi: widget.donasi.judulDonasi,
      namaDonatur: _isAnonymous ? 'Anonymous' : _userFullName,
      email: _userEmail,
      whatsapp: _userPhone,
      nominal: nominal,
      kategoriDonasiId: widget.donasi.id,
      snapToken: response['snap_token'], // Kirim snapToken ke sini
    ),
  ),
);

}



  Widget _buildAmountButton(String amount) {
    final isSelected = _selectedAmount == amount;
    return OutlinedButton(
      onPressed: () => _handleAmountSelection(amount),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.blue,
          width: isSelected ? 2 : 1,
        ),
        backgroundColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        amount,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.blue,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _manualAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressPercentage = widget.donasi.targetDana > 0
        ? (widget.donasi.donasiTerkumpul / widget.donasi.targetDana)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Kamu Akan Berdonasi'),
        centerTitle: true,
      ),
      body: _isLoadingUserData
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campaign Header with Image
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: widget.donasi.gambar,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.donasi.judulDonasi,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: progressPercentage,
                              backgroundColor: Colors.grey[200],
                              color: Colors.blue,
                              minHeight: 6,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(progressPercentage * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Amount Information
                  Text(
                    'Rp ${widget.donasi.donasiTerkumpul.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dari target Rp ${widget.donasi.targetDana.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Donation Amount Selection
                  const Text(
                    'Pilih Nominal Donasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Amount Buttons Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.5,
                    children: [
                      '1.000', '2.000', '5.000',
                      '10.000', '20.000', '50.000',
                      '100.000', '200.000', '500.000'
                    ].map((amount) => _buildAmountButton('Rp $amount')).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Manual Amount Input
                  const Text(
                    'Atau masukkan nominal lain',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _manualAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixText: 'Rp ',
                      prefixStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Masukkan nominal donasi',
                    ),
                    onChanged: _formatCurrency,
                  ),
                  const SizedBox(height: 24),

                  // Donor Information
                  const Text(
                    'Data Donatur',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        _userFullName,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Switch(
                        value: _isAnonymous,
                        onChanged: (value) {
                          setState(() {
                            _isAnonymous = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isAnonymous
                        ? 'Donasi anonim (nama tidak ditampilkan)'
                        : 'Nama akan ditampilkan di riwayat donasi',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Additional Data
                  const Text(
                    'Data Tambahan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: _userEmail,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: _userPhone,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Data ini digunakan untuk notifikasi terkait donasi',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Payment Methods
                  const Text(
                    'Pilih Metode Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Donate Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _processDonation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Donasi Sekarang',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}