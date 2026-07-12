import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/domain/AvatarColors.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';

class AvatarCondiviso extends StatelessWidget {
  final String messaggio;
  final String? titolo;
  final double dimensioneAvatar;
  final double larghezzaMassimaMessaggio;
  final VoidCallback? onTap;

  const AvatarCondiviso({
    super.key,
    required this.messaggio,
    this.titolo,
    this.dimensioneAvatar = 180,
    this.larghezzaMassimaMessaggio = 220,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chosenColor = context.watch<Avatar_ViewModel>().user?.chosenColor ?? 0;

    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if(messaggio.isNotEmpty)
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: larghezzaMassimaMessaggio),
                margin: EdgeInsets.only(
                  bottom: dimensioneAvatar * 4 / 9,
                  right: 12.0,
                ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (titolo != null) ...[
                    Text(
                      titolo!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    messaggio,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: SizedBox(
              width: dimensioneAvatar,
              height: dimensioneAvatar,
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
