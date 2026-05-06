import 'package:flutter/material.dart';

class AvatarCondiviso extends StatelessWidget {
  final String messaggio;

  const AvatarCondiviso({super.key, required this.messaggio});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,

      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Spacer(),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 55.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                margin: const EdgeInsets.only(bottom: 20.0, right: 15.0),
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
            ),
          ),
          SizedBox(
            width: 180,
            height: 180,
            child: Image.asset(
              'assets/images/fiammella.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
