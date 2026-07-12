import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/core/FrecciaIndietroWidget/FrecciaIndietro.dart';

class Shop_View extends StatelessWidget {
  const Shop_View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        leading: const FrecciaIndietro(),
        centerTitle: true,
      ),
      body: const SizedBox.shrink(),
    );
  }
}
