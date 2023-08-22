import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  Future<Map<String, dynamic>> getProductData() async {
    final prefs = await SharedPreferences.getInstance();

    final productName = prefs.getString('productName') ?? '';
    final price = prefs.getDouble('price') ?? 0.0;
    final quantity = prefs.getInt('quantity') ?? 0;
    final companyName = prefs.getString('companyName') ?? '';

    return {
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'companyName': companyName,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SharedPreferences Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            SizedBox(height: 16),
            FutureBuilder(
              future: getProductData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  Map<String, dynamic>? data = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product Name: ${data!['productName']}'),
                      Text('Price: ${data!['price']}'),
                      Text('Quantity: ${data['quantity']}'),
                      Text('Company Name: ${data['companyName']}'),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
