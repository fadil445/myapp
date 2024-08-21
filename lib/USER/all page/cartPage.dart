import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:myapp/USER/all%20page/cartmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:midtrans_sdk/midtrans_sdk.dart'; // Import Midtrans SDK jika perlu

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    void _proceedToPayment() async {
      final serverKey = 'SB-Mid-server-JyCrGhz3ueR59EwqM3sPWOmZ';
      final clientKey = 'SB-Mid-client-GvRwcwOZMJxtfErL';

      try {
        // Mengirim permintaan ke backend untuk membuat transaksi
        final response = await http.post(
          Uri.parse('${dotenv.env['ENDPOINT']}/'), // Endpoint untuk membuat transaksi
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Basic ' + base64Encode(utf8.encode('$serverKey:')),
          },
          body: jsonEncode({
            'order_id': 'ORDER-${DateTime.now().millisecondsSinceEpoch}',
            'amount': cart.total, // Amount in the smallest currency unit (e.g., cents)
            'payment_type': 'credit_card',
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final transactionToken = data['token'];

          // Panggil Midtrans SDK untuk melanjutkan pembayaran
          final midtrans = MidtransFlutter(clientKey: clientKey);
          midtrans.startPayment(
            token: transactionToken,
            onSuccess: (result) {
              print('Payment Success: $result');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pembayaran berhasil!')),
              );
            },
            onFailure: (result) {
              print('Payment Failure: $result');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pembayaran gagal!')),
              );
            },
            onCancel: () {
              print('Payment Cancelled');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pembayaran dibatalkan!')),
              );
            },
          );
        } else {
          print('Failed to create transaction');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal membuat transaksi!')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan!')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        leadingWidth: 70,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color.fromARGB(206, 197, 197, 197),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Card(
                    elevation: 4,
                    shadowColor: Colors.black12,
                    child: ListTile(
                      leading: Image.network(item.image, width: 50, height: 50),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text untuk item price
                          Text(
                            'Rp ${(item.price * item.quantity)}',
                            style: TextStyle(fontSize: 16),
                          ),
                          // Row untuk qty dan tombol - +
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () => cart.decreaseQuantity(item),
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => cart.increaseQuantity(item),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Box total dan checkout
          SizedBox(
            height: 130, // Total height for both Text and ElevatedButton
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Column(
                children: [
                  Container(
                    height: 50, // tinggi box Text
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Total : Rp.${(cart.total)}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 10), // Space antara Text and Button
                  Container(
                    height: 40, // tinggi ElevatedButton
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(243, 162, 11, 1),
                      ),
                      onPressed: _proceedToPayment,
                      child: const Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
