import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentTabIndex = 0;
  String _searchQuery = "";
  String _selectedPaymentMethod = 'Transfer Bank'; // Metode pembayaran default

  // Daftar produk toko
  final List<Map<String, String>> _products = [
    {'name': 'Produk A', 'price': 'Rp 100.000', 'image': 'assets/product_1.jpg'},
    {'name': 'Produk B', 'price': 'Rp 200.000', 'image': 'assets/product_2.jpg'},
    {'name': 'Produk C', 'price': 'Rp 150.000', 'image': 'assets/product_3.jpg'},
  ];

  // Daftar produk dalam keranjang
  final List<Map<String, String>> _cart = [];

  void _addToCart(Map<String, String> product) {
    setState(() {
      _cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['name']} ditambahkan ke keranjang!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: const InputDecoration(
            hintText: 'Cari Produk...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              _showCartDialog(context);
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          // Tab Home
          _buildHomeTab(),
          // Tab Profil
          _buildProfileTab(),
          // Tab Metode Pembayaran
          _buildPaymentTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Pembayaran'),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    final filteredProducts = _products
        .where((product) => product['name']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Container(
      color: Colors.lightBlue[50], // Latar belakang warna biru muda
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Produk Toko',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Image.asset(
                      filteredProducts[index]['image']!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(filteredProducts[index]['name']!),
                    subtitle: Text(filteredProducts[index]['price']!),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () => _addToCart(filteredProducts[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Container(
      color: Colors.amber[50], // Latar belakang warna kuning muda
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Nama Pengguna: Albi Saepul Marup',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Email: albi@example.com',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Telepon: 0812-3456-7890',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Alamat: Jl. Merdeka No. 123, Bandung',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTab() {
    return Container(
      color: Colors.green[50], // Latar belakang warna hijau muda
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedPaymentMethod,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPaymentMethod = newValue!;
                });
              },
              items: <String>['Transfer Bank', 'E-Wallet', 'Kartu Kredit']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Keranjang Anda'),
          content: _cart.isNotEmpty
              ? SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.asset(
                          _cart[index]['image']!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        title: Text(_cart[index]['name']!),
                        subtitle: Text(_cart[index]['price']!),
                      );
                    },
                  ),
                )
              : const Text('Keranjang Anda kosong.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}