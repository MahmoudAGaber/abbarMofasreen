import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream2/my_library.dart';
import 'package:dream2/view/widgets/custom_text.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'audioPlayerItem.dart';

class InChatItem extends StatelessWidget {
  final bool? inLeft;

  final String? message;
  final Timestamp? date;

  InChatItem({this.inLeft = false, this.date, this.message});

  @override
  Widget build(BuildContext context) {
    var dd = DateTime.parse(date!.toDate().toString());
    var d12 = intl.DateFormat('hh:mm a').format(dd);
    return Align(
      alignment: inLeft! ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: !inLeft! ? 20.0 : 0.0,
          right: inLeft! ? 20.0 : 0.0,
        ),
        child: CustomPaint(
          size: Size(233.34.w, 35.h),
          painter: inLeft! ? RPSCustomPainterLift() : RPSCustomPainter(),
          child: IntrinsicWidth(
            child: Container(
              constraints: BoxConstraints(minHeight: 25.h),
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Row(
                textDirection: inLeft! ? TextDirection.ltr : TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      child: message!.contains('voice')
                          ? AudioPlayerItem(audioPath: message)
                          : CustomText(
                              message ?? '',
                              fontSize: 14,
                              color: const Color(0xff444444),
                              fontWeight: FontWeight.w600,
                              height: 1.5.h,
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  CustomText(
                    d12,
                    fontSize: 10,
                    color: const Color(0xab858585),
                    height: 1.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RPSCustomPainterLift extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9445444, 0);
    path_0.lineTo(size.width * 0.06564241, 0);
    path_0.cubicTo(
        size.width * 0.03501757,
        0,
        size.width * 0.03610611,
        size.height * 0.5104571,
        size.width * 0.03610611,
        size.height * 0.6530000);
    path_0.lineTo(0, size.height * 0.7904571);
    path_0.lineTo(0, size.height * 0.7904571);
    path_0.cubicTo(
        0,
        size.height * 0.8255143,
        size.width * 0.05549841,
        size.height * 0.8424857,
        size.width * 0.05908117,
        size.height * 0.8821143);
    path_0.cubicTo(
        size.width * 0.06655953,
        size.height * 0.9663714,
        size.width * 0.08271192,
        size.height,
        size.width * 0.1058198,
        size.height);
    path_0.lineTo(size.width * 0.9445444, size.height);
    path_0.cubicTo(
        size.width * 0.9751693,
        size.height,
        size.width * 0.9999957,
        size.height * 0.8844571,
        size.width * 0.9999957,
        size.height * 0.7419429);
    path_0.lineTo(size.width * 0.9999957, size.height * 0.2580571);
    path_0.cubicTo(size.width, size.height * 0.1155429, size.width * 0.9751736,
        0, size.width * 0.9445444, 0);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffDCF8C7).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.05546181, 0);
    path_0.lineTo(size.width * 0.9345031, 0);
    path_0.cubicTo(
        size.width * 0.9651337,
        0,
        size.width * 0.9640467,
        size.height * 0.5104694,
        size.width * 0.9640467,
        size.height * 0.6529945);
    path_0.lineTo(size.width * 1.000158, size.height * 0.7904648);
    path_0.lineTo(size.width * 1.000158, size.height * 0.7904648);
    path_0.cubicTo(
        size.width * 1.000158,
        size.height * 0.8255260,
        size.width * 0.9446523,
        size.height * 0.8424922,
        size.width * 0.9410684,
        size.height * 0.8821121);
    path_0.cubicTo(
        size.width * 0.9335872,
        size.height * 0.9663814,
        size.width * 0.9174173,
        size.height,
        size.width * 0.8943217,
        size.height);
    path_0.lineTo(size.width * 0.05546181, size.height);
    path_0.cubicTo(size.width * 0.02483110, size.height, 0,
        size.height * 0.8844606, 0, size.height * 0.7419355);
    path_0.lineTo(0, size.height * 0.2580645);
    path_0.cubicTo(0, size.height * 0.1155394, size.width * 0.02483110, 0,
        size.width * 0.05546181, 0);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xfff9f9f9).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
