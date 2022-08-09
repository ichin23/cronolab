import 'package:flutter/material.dart';

enum PopItColor { verde, amarelo, vermelho }

class PopIt extends StatelessWidget {
  PopIt(this.color, {Key? key}) : super(key: key);
  PopItColor color;

  @override
  Widget build(BuildContext context) {
    Color verde = const Color(0xff79FF52);
    Color vermelho = const Color(0xffFF4238);
    Color amarelo = const Color(0xffF2FF45);
    LinearGradient verdeGr = const LinearGradient(
        colors: [Color(0xff96F6A0), Color(0xff96F6A0)],
        end: Alignment.bottomLeft,
        begin: Alignment.topRight);
    LinearGradient vermelhoGr = const LinearGradient(
        colors: [Color(0xffF2A299), Color(0xffF2A299)],
        end: Alignment.bottomLeft,
        begin: Alignment.topRight);
    LinearGradient amareloGr = const LinearGradient(
        colors: [Color(0xffF5DA93), Color.fromARGB(255, 175, 155, 104)],
        end: Alignment.bottomLeft,
        begin: Alignment.topRight);
    return SizedBox(
      width: 300,
      height: 300,
      child: CustomPaint(
        painter: PopItPainter(
            // color == PopItColor.verde
            //     ? verdeGr
            //     : color == PopItColor.amarelo
            //         ? amareloGr
            //         : vermelhoGr,
            null,
            color == PopItColor.verde
                ? verde
                : color == PopItColor.amarelo
                    ? amarelo
                    : vermelho),
      ),
    );
  }
}

class PopItPainter extends CustomPainter {
  PopItPainter(this.gradient, this.color);
  LinearGradient? gradient;
  Color? color;
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    Path path = Path();
    Paint paint = Paint()..strokeWidth = 10;
    // ..color = Colors.red
    // ..shader = gradient.createShader(rect);
    paint.shader = gradient != null ? gradient!.createShader(rect) : null;
    color != null ? paint.color = color! : null;
    Paint shadow = Paint()
      ..color = Colors.grey[900]!.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    Path shaddow = Path();

    shaddow.lineTo(size.width * 0.03, size.height * 0.98);
    shaddow.lineTo(size.width, size.height);

    path.lineTo(size.width * 0.02, size.height);
    path.lineTo(size.width * 0.98, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    // path.cubicTo(x1, y1, size.width*0.3, size.height*0.9, x3, y3)

    canvas.drawPath(shaddow, shadow);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(PopItPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(PopItPainter oldDelegate) => false;
}
