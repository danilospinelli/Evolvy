import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/QuizPage/ViewModel/QuizPage_ViewModel.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';

class ExplanationBubble extends StatelessWidget {
  const ExplanationBubble({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuizPage_ViewModel>();

    return Container(
      width: double.infinity,
      // TODO: RISOLVI OVERFLOW DI AVATAR
      // MARGINI -----------------------------------------------
      margin: const EdgeInsets.fromLTRB(12, 0, 100, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SPIEGAZIONE',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    vm.spiegazione,
                    style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.3),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 70,
            height: 70,
            child: AvatarCondiviso(
              messaggio: '',
              onTap: () {} // TODO: TOCCO MASCOTTE
            )
          ),
        ],
      ),
    );
  }
}
