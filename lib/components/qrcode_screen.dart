import 'package:flutter/material.dart';
import 'package:qr/qr.dart';

class QRScreen extends StatelessWidget {
  final String userId;
  late final QrCode qrCode;
  late final QrImage qrImage;

  QRScreen({super.key, required this.userId}) {
    qrCode = QrCode(4, QrErrorCorrectLevel.L);
    qrCode.addData(userId);
    qrImage = QrImage(qrCode);
  }

  @override
  Widget build(BuildContext context) {
    final size = qrImage.moduleCount;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(size, (y) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(size, (x) {
              final isDark = qrImage.isDark(y, x);
              return Container(
                width: 7,
                height: 7,
                color: isDark ? Colors.black : Colors.white,
              );
            }),
          );
        }),
      ),
    );
  }
}