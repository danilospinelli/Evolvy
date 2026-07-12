import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';

class GlobalRanking_View extends StatelessWidget {
  const GlobalRanking_View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AvatarCondiviso(
        messaggio: 'Questa pagina deve ancora essere sviluppata dallo Staff.', 
        titolo: 'WORK IN PROGRESS',
        dimensioneAvatar: 300, 
      )
    );
  }

}