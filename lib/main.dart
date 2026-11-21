import 'package:flutter/material.dart';

// ====== DATA MAHASISWA ======
const String kNama = 'Bunga Octavia Ramadani';
const String kNim = '20240040152';
const String kProdiKelas = 'Teknik Informatika (TI24D)';
// ============================

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PPM Sesi 2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: const Text(
          'PPM Sesi 2 - $kNama ($kNim)',
          maxLines: 2,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            PromoBanner(),
            SizedBox(height: 16),
            ProfileCard(
              nama: kNama,
              nim: kNim,
              prodiKelas: kProdiKelas,
            ),
            SizedBox(height: 16),
            ProductCard(
              nama: 'Headphone Wireless X1',
              kategori: 'Elektronik',
              harga: 150000,
            ),
          ],
        ),
      ),
    );
  }
}

/// Banner promo sederhana: Stack + Positioned
class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 120,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [scheme.primary, Colors.tealAccent.shade700],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -20,
            child: Icon(Icons.local_offer,
                size: 130, color: Colors.white.withOpacity(0.2)),
          ),
          const Positioned(
            left: 16,
            top: 16,
            child: Text('PROMO AKHIR PEKAN',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          const Positioned(
            left: 16,
            bottom: 16,
            child: Text('Diskon hingga 20% semua produk',
                style: TextStyle(color: Colors.white70)),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('-20%',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu profil mahasiswa (StatelessWidget)
class ProfileCard extends StatelessWidget {
  final String nama;
  final String nim;
  final String prodiKelas;

  const ProfileCard({
    super.key,
    required this.nama,
    required this.nim,
    required this.prodiKelas,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: scheme.primaryContainer,
              child: Icon(Icons.person, size: 44, color: scheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nama,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('NIM: $nim'),
                  Text(prodiKelas),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (_) => const Icon(Icons.star,
                          color: Colors.amber, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu produk (StatefulWidget)
class ProductCard extends StatefulWidget {
  final String nama;
  final String kategori;
  final int harga;

  const ProductCard({
    super.key,
    required this.nama,
    required this.kategori,
    required this.harga,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;
  int _likes = 24;
  int _qty = 1;

  int get _total => widget.harga * _qty;

  String _rupiah(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return 'Rp $buf';
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      _likes += _isFavorite ? 1 : -1;
    });
  }

  void _decrement() {
    if (_qty > 1) setState(() => _qty--);
  }

  void _increment() => setState(() => _qty++);

  void _addToCart() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
              '${widget.nama} x$_qty ditambahkan ke keranjang (${_rupiah(_total)})'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder gambar produk + chip kategori
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                color: scheme.primaryContainer,
                child: Icon(Icons.headphones, size: 90, color: scheme.primary),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(widget.kategori,
                      style: TextStyle(color: scheme.onPrimary, fontSize: 12)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(widget.nama,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    // Tombol Favorite + jumlah like
                    IconButton(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                    Text('$_likes'),
                  ],
                ),
                Text('Kategori: ${widget.kategori}'),
                const SizedBox(height: 4),
                Text('Harga: ${_rupiah(widget.harga)}',
                    style: TextStyle(
                        fontSize: 16,
                        color: scheme.primary,
                        fontWeight: FontWeight.w600)),
                const Divider(height: 24),
                // Pengatur jumlah
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton.outlined(
                          onPressed: _qty > 1 ? _decrement : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('$_qty',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        IconButton.outlined(
                          onPressed: _increment,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Total',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(_rupiah(_total),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addToCart,
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Tambah ke Keranjang'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}