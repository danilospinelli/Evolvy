import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/core/FrecciaIndietroWidget/FrecciaIndietro.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';

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
      body: AvatarCondiviso(
        messaggio: 'Questa pagina deve ancora essere sviluppata dallo Staff.', 
        titolo: 'WORK IN PROGRESS',
        dimensioneAvatar: 300,
      )
    );
  }
}
