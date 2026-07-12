import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/domain/AvatarColors.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';

class AvatarCondiviso extends StatelessWidget {
  final String messaggio;
  final VoidCallback? onTap;

  const AvatarCondiviso({super.key, required this.messaggio, this.onTap});

  @override
  Widget build(BuildContext context) {
    final chosenColor = context.watch<Avatar_ViewModel>().user?.chosen_color ?? 0;

    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if(messaggio.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxWidth: 220),
              margin: const EdgeInsets.only(bottom: 80.0, right: 12.0),
              padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: Radius.circular(24),
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
            child: Text(
              messaggio,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: SizedBox(
              width: 180,
              height: 180,
              child: Image.asset(
                avatarSprite(chosenColor),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
