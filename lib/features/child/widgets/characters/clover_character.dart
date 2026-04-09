// Clover — dusty-rose dog. Routine-lover, grounded, sitting pose.
// SIGNATURE: giant floppy ears, larger than the head, the most distinctive feature.
// Design: cream muzzle, warm brown eyes, stub tail, tiny paws.
// Virtual canvas: 200×220. Scale: s = size.width / 200.

import 'package:flutter/material.dart';

class CloverCharacter extends StatelessWidget {
  const CloverCharacter({this.emotion = 'happy', this.size = 140, super.key});
  final String emotion;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CloverPainter(emotion)),
    );
  }
}

class _CloverPainter extends CustomPainter {
  const _CloverPainter(this.emotion);
  final String emotion;

  // Palette — dusty rose / mauve family
  static const _body      = Color(0xFFCFAFAF); // main dusty rose
  static const _bodyLt    = Color(0xFFEDD8D8); // lighter highlight
  static const _bodyDk    = Color(0xFFAA8080); // shadow/depth
  static const _ear       = Color(0xFFC09898); // slightly deeper than body
  static const _earInner  = Color(0xFFEDD4D4); // soft inner ear
  static const _muzzle    = Color(0xFFF8EDE0); // cream
  static const _muzzleDk  = Color(0xFFEDD5C0);
  static const _nose      = Color(0xFF3E2020);
  static const _outline   = Color(0xFF3E2020);
  static const _irisWarm  = Color(0xFF7B3F1A); // warm chocolate
  static const _irisDk    = Color(0xFF4A2200);
  static const _pupil     = Color(0xFF180E08);
  static const _blush     = Color(0xFFE87070);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 200;
    _drawShadow(canvas, s);
    _drawBody(canvas, s);
    _drawTail(canvas, s);
    _drawPaws(canvas, s);
    // Ears drawn BEFORE head (head overlaps the attachment point)
    _drawLeftEar(canvas, s);
    _drawRightEar(canvas, s);
    _drawHead(canvas, s);
    _drawMuzzle(canvas, s);
    _drawNose(canvas, s);
    _drawCheeks(canvas, s);
    _drawEyes(canvas, s);
    _drawEmotion(canvas, s);
  }

  // ── Shadow ───────────────────────────────────────────────────────────────────
  void _drawShadow(Canvas canvas, double s) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(100 * s, 216 * s), width: 90 * s, height: 10 * s),
      Paint()
        ..color = const Color(0x18000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }

  // ── Body (sitting haunches — wide, low rounded shape) ────────────────────────
  void _drawBody(Canvas canvas, double s) {
    final r = Rect.fromCenter(center: Offset(100 * s, 172 * s), width: 104 * s, height: 88 * s);
    final path = Path()
      ..moveTo(100 * s, 130 * s)
      ..cubicTo(138 * s, 130 * s, 154 * s, 148 * s, 154 * s, 175 * s)
      ..cubicTo(154 * s, 202 * s, 132 * s, 214 * s, 100 * s, 214 * s)
      ..cubicTo(68  * s, 214 * s, 46  * s, 202 * s, 46  * s, 175 * s)
      ..cubicTo(46  * s, 148 * s, 62  * s, 130 * s, 100 * s, 130 * s)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          colors: const [_bodyLt, _body, _bodyDk],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.4, 1.0],
        ).createShader(r),
    );
    // Soft belly highlight
    final belly = Path()
      ..moveTo(100 * s, 138 * s)
      ..cubicTo(120 * s, 138 * s, 132 * s, 152 * s, 132 * s, 173 * s)
      ..cubicTo(132 * s, 194 * s, 118 * s, 206 * s, 100 * s, 206 * s)
      ..cubicTo(82  * s, 206 * s, 68  * s, 194 * s, 68  * s, 173 * s)
      ..cubicTo(68  * s, 152 * s, 80  * s, 138 * s, 100 * s, 138 * s)
      ..close();
    canvas.drawPath(belly, Paint()..color = const Color(0x40EDD8D8));
    canvas.drawPath(path, _stroke(s, 2.5));
  }

  // ── Stub tail ────────────────────────────────────────────────────────────────
  void _drawTail(Canvas canvas, double s) {
    final r = Rect.fromLTWH(142 * s, 166 * s, 34 * s, 28 * s);
    final path = Path()
      ..moveTo(148 * s, 186 * s)
      ..cubicTo(158 * s, 178 * s, 174 * s, 172 * s, 172 * s, 162 * s)
      ..cubicTo(170 * s, 154 * s, 160 * s, 156 * s, 154 * s, 164 * s)
      ..cubicTo(150 * s, 170 * s, 148 * s, 180 * s, 148 * s, 186 * s)
      ..close();
    canvas.drawPath(path, Paint()
      ..shader = LinearGradient(
        colors: const [_bodyLt, _body],
      ).createShader(r));
    canvas.drawPath(path, _stroke(s, 1.8));
  }

  // ── Tiny paws (just visible at bottom) ──────────────────────────────────────
  void _drawPaws(Canvas canvas, double s) {
    for (final (cx, cy) in [(78.0, 212.0), (122.0, 212.0)]) {
      final r = Rect.fromCenter(center: Offset(cx * s, cy * s), width: 28 * s, height: 14 * s);
      canvas.drawOval(r, Paint()
        ..shader = LinearGradient(
          colors: const [_bodyLt, _body],
        ).createShader(r));
      canvas.drawOval(r, _stroke(s, 1.8));
    }
  }

  // ── GIANT floppy left ear ────────────────────────────────────────────────────
  // This is Clover's signature. The ear is a large leaf/teardrop shape,
  // wider at the top attachment, narrowing and rounding at the drooping tip.
  void _drawLeftEar(Canvas canvas, double s) {
    final r = Rect.fromLTWH(14 * s, 52 * s, 72 * s, 120 * s);

    // Outer ear shape (the visible silhouette)
    final outer = Path()
      ..moveTo(60 * s, 52 * s)     // top of ear at head
      ..cubicTo(44 * s, 52 * s, 22 * s, 68  * s, 18 * s, 100 * s)
      ..cubicTo(14 * s, 128 * s,   24 * s, 158 * s, 36 * s, 168 * s)
      ..cubicTo(46 * s, 176 * s,   58 * s, 174 * s, 62 * s, 162 * s)
      ..cubicTo(68 * s, 146 * s,   62 * s, 120 * s, 58 * s,  96 * s)
      ..cubicTo(55 * s, 76  * s,   60 * s,  60 * s, 60 * s,  52 * s)
      ..close();

    canvas.drawPath(outer, Paint()
      ..shader = LinearGradient(
        colors: const [_bodyLt, _ear, _bodyDk],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.5, 1.0],
      ).createShader(r));

    // Inner ear highlight (a smaller shape inside)
    final inner = Path()
      ..moveTo(54 * s,  66 * s)
      ..cubicTo(44 * s,  68 * s, 32 * s, 82  * s, 30 * s, 104 * s)
      ..cubicTo(28 * s, 122 * s, 34 * s, 148 * s, 42 * s, 158 * s)
      ..cubicTo(46 * s, 163 * s, 53 * s, 163 * s, 54 * s, 156 * s)
      ..cubicTo(56 * s, 144 * s, 52 * s, 118 * s, 50 * s,  96 * s)
      ..cubicTo(48 * s,  78 * s, 52 * s,  68 * s, 54 * s,  66 * s)
      ..close();
    canvas.drawPath(inner, Paint()..color = _earInner.withOpacity(0.55));
    canvas.drawPath(outer, _stroke(s, 2.2));
  }

  // ── GIANT floppy right ear (mirror) ─────────────────────────────────────────
  void _drawRightEar(Canvas canvas, double s) {
    final r = Rect.fromLTWH(114 * s, 52 * s, 72 * s, 120 * s);

    final outer = Path()
      ..moveTo(140 * s, 52 * s)
      ..cubicTo(156 * s, 52 * s, 178 * s, 68  * s, 182 * s, 100 * s)
      ..cubicTo(186 * s, 128 * s, 176 * s, 158 * s, 164 * s, 168 * s)
      ..cubicTo(154 * s, 176 * s, 142 * s, 174 * s, 138 * s, 162 * s)
      ..cubicTo(132 * s, 146 * s, 138 * s, 120 * s, 142 * s,  96 * s)
      ..cubicTo(145 * s, 76  * s, 140 * s,  60 * s, 140 * s,  52 * s)
      ..close();

    canvas.drawPath(outer, Paint()
      ..shader = LinearGradient(
        colors: const [_bodyLt, _ear, _bodyDk],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: const [0.0, 0.5, 1.0],
      ).createShader(r));

    final inner = Path()
      ..moveTo(146 * s,  66 * s)
      ..cubicTo(156 * s,  68 * s, 168 * s, 82  * s, 170 * s, 104 * s)
      ..cubicTo(172 * s, 122 * s, 166 * s, 148 * s, 158 * s, 158 * s)
      ..cubicTo(154 * s, 163 * s, 147 * s, 163 * s, 146 * s, 156 * s)
      ..cubicTo(144 * s, 144 * s, 148 * s, 118 * s, 150 * s,  96 * s)
      ..cubicTo(152 * s,  78 * s, 148 * s,  68 * s, 146 * s,  66 * s)
      ..close();
    canvas.drawPath(inner, Paint()..color = _earInner.withOpacity(0.55));
    canvas.drawPath(outer, _stroke(s, 2.2));
  }

  // ── Head ────────────────────────────────────────────────────────────────────
  void _drawHead(Canvas canvas, double s) {
    const cx = 100.0; const cy = 84.0; const r = 60.0;
    final center = Offset(cx * s, cy * s);
    canvas.drawCircle(
      center, r * s,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.25, -0.35),
          radius: 0.9,
          colors: const [_bodyLt, _body, _bodyDk],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: r * s)),
    );
    canvas.drawCircle(center, r * s, _stroke(s, 2.5));
  }

  // ── Muzzle ──────────────────────────────────────────────────────────────────
  // Protruding cream oval on lower face — slightly forward of the head plane
  void _drawMuzzle(Canvas canvas, double s) {
    final r = Rect.fromCenter(center: Offset(100 * s, 104 * s), width: 46 * s, height: 36 * s);
    canvas.drawOval(r, Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.3),
        colors: const [_muzzle, _muzzleDk],
        stops: const [0.0, 1.0],
      ).createShader(r));
    canvas.drawOval(r, _stroke(s, 1.8));
  }

  // ── Nose ────────────────────────────────────────────────────────────────────
  void _drawNose(Canvas canvas, double s) {
    final r = Rect.fromCenter(center: Offset(100 * s, 96 * s), width: 18 * s, height: 12 * s);
    canvas.drawRRect(
      RRect.fromRectAndRadius(r, Radius.circular(6 * s)),
      Paint()..color = _nose,
    );
    // Highlight on nose
    canvas.drawOval(
      Rect.fromCenter(center: Offset(95 * s, 93 * s), width: 5 * s, height: 3.5 * s),
      Paint()..color = Colors.white.withOpacity(0.35),
    );
  }

  // ── Cheeks ──────────────────────────────────────────────────────────────────
  void _drawCheeks(Canvas canvas, double s) {
    for (final x in [68.0, 132.0]) {
      canvas.drawCircle(Offset(x * s, 100 * s), 12 * s,
          Paint()..color = _blush.withOpacity(0.18));
    }
  }

  // ── Eyes ────────────────────────────────────────────────────────────────────
  void _drawEyes(Canvas canvas, double s) {
    _eye(canvas, Offset(80 * s, 78 * s), s);
    _eye(canvas, Offset(120 * s, 78 * s), s);
  }

  void _eye(Canvas canvas, Offset c, double s) {
    final eyeR = Rect.fromCenter(center: c, width: 26 * s, height: 30 * s);
    final irisC = c.translate(0, 1.5 * s);

    canvas.drawOval(eyeR, Paint()..color = Colors.white);

    canvas.drawCircle(irisC, 11 * s, Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: const [Color(0xFFB85A2A), _irisWarm, _irisDk],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: irisC, radius: 11 * s)));

    canvas.drawCircle(c.translate(0.5 * s, 2 * s), 7 * s, Paint()
      ..shader = RadialGradient(
        colors: const [Color(0xFF2A1A10), _pupil],
      ).createShader(Rect.fromCircle(center: c.translate(0.5 * s, 2 * s), radius: 7 * s)));

    // Catchlights
    canvas.drawCircle(c.translate(3 * s, -1.5 * s), 3.5 * s, Paint()..color = Colors.white);
    canvas.drawCircle(c.translate(-3 * s, 4 * s), 1.6 * s, Paint()..color = Colors.white.withOpacity(0.75));

    canvas.drawOval(eyeR, _stroke(s, 1.8));
  }

  // ── Emotion expressions ──────────────────────────────────────────────────────
  void _drawEmotion(Canvas canvas, double s) {
    switch (emotion) {
      case 'happy':   _happy(canvas, s);      break;
      case 'sad':     _sad(canvas, s);        break;
      case 'angry':   _angry(canvas, s);      break;
      case 'scared':  _scared(canvas, s);     break;
      case 'surprised': _surprised(canvas, s); break;
      case 'frustrated': _frustrated(canvas, s); break;
      case 'proud':   _proud(canvas, s);      break;
      default:        _happy(canvas, s);
    }
  }

  void _happy(Canvas canvas, double s) {
    // Soft eyelid squint
    for (final cx in [80.0, 120.0]) {
      _upperLid(canvas, s, cx, 78, 8);
    }
    _smile(canvas, s, depth: 10);
    // Tail wag hint: small motion lines near tail
    _wagLines(canvas, s);
  }

  void _sad(Canvas canvas, double s) {
    // Sad inner brows rise toward center
    _sadBrow(canvas, s, 80, flip: false);
    _sadBrow(canvas, s, 120, flip: true);
    _frown(canvas, s);
  }

  void _angry(Canvas canvas, double s) {
    _angryBrow(canvas, s, left: true);
    _angryBrow(canvas, s, left: false);
    for (final cx in [80.0, 120.0]) { _lowerLid(canvas, s, cx, 78, 7); }
    // Grumpy line
    _drawPath(canvas, s, _mouthPaint(s), (p) => p
      ..moveTo(86 * s, 112 * s)
      ..cubicTo(92 * s, 110 * s, 108 * s, 110 * s, 114 * s, 112 * s));
  }

  void _scared(Canvas canvas, double s) {
    _raisedBrow(canvas, s, 80, -32);
    _raisedBrow(canvas, s, 120, -32);
    _oMouth(canvas, s, 18, 15);
  }

  void _surprised(Canvas canvas, double s) {
    _raisedBrow(canvas, s, 80, -38);
    _raisedBrow(canvas, s, 120, -38);
    _oMouth(canvas, s, 24, 20);
  }

  void _frustrated(Canvas canvas, double s) {
    _drawPath(canvas, s, _browPaint(s), (p) => p
      ..moveTo(66 * s, 62 * s)
      ..quadraticBezierTo(80 * s, 58 * s, 94 * s, 64 * s));
    _drawPath(canvas, s, _browPaint(s), (p) => p
      ..moveTo(106 * s, 62 * s)
      ..quadraticBezierTo(120 * s, 60 * s, 134 * s, 65 * s));
    _drawPath(canvas, s, _mouthPaint(s), (p) => p
      ..moveTo(86 * s, 112 * s)
      ..cubicTo(92 * s, 106 * s, 96 * s, 118 * s, 100 * s, 112 * s)
      ..cubicTo(104 * s, 106 * s, 108 * s, 118 * s, 114 * s, 112 * s));
  }

  void _proud(Canvas canvas, double s) {
    for (final cx in [80.0, 120.0]) { _upperLid(canvas, s, cx, 78, 6); }
    _smile(canvas, s, depth: 8);
  }

  // ── Expression helpers ───────────────────────────────────────────────────────

  void _upperLid(Canvas canvas, double s, double cx, double cy, double depth) {
    final lid = Path()
      ..moveTo((cx - 13) * s, cy * s)
      ..quadraticBezierTo(cx * s, (cy - depth) * s, (cx + 13) * s, cy * s)
      ..lineTo((cx + 13) * s, (cy - 28) * s)
      ..lineTo((cx - 13) * s, (cy - 28) * s)
      ..close();
    canvas.drawPath(lid, Paint()..color = _body);
    _drawPath(canvas, s, _stroke(s, 1.8), (p) => p
      ..moveTo((cx - 13) * s, cy * s)
      ..quadraticBezierTo(cx * s, (cy - depth) * s, (cx + 13) * s, cy * s));
  }

  void _lowerLid(Canvas canvas, double s, double cx, double cy, double depth) {
    final lid = Path()
      ..moveTo((cx - 13) * s, cy * s)
      ..quadraticBezierTo(cx * s, (cy + depth) * s, (cx + 13) * s, cy * s)
      ..lineTo((cx + 13) * s, (cy + 28) * s)
      ..lineTo((cx - 13) * s, (cy + 28) * s)
      ..close();
    canvas.drawPath(lid, Paint()..color = _body);
    _drawPath(canvas, s, _stroke(s, 1.8), (p) => p
      ..moveTo((cx - 13) * s, cy * s)
      ..quadraticBezierTo(cx * s, (cy + depth) * s, (cx + 13) * s, cy * s));
  }

  void _smile(Canvas canvas, double s, {required double depth}) {
    final mouthFill = Path()
      ..moveTo(84 * s, 112 * s)
      ..cubicTo(90 * s, (112 + depth) * s, 110 * s, (112 + depth) * s, 116 * s, 112 * s)
      ..close();
    canvas.drawPath(mouthFill, Paint()..color = const Color(0xFFD4594A).withOpacity(0.45));
    _drawPath(canvas, s, _mouthPaint(s), (p) => p
      ..moveTo(84 * s, 112 * s)
      ..cubicTo(90 * s, (112 + depth) * s, 110 * s, (112 + depth) * s, 116 * s, 112 * s));
  }

  void _frown(Canvas canvas, double s) {
    _drawPath(canvas, s, _mouthPaint(s), (p) => p
      ..moveTo(84 * s, 116 * s)
      ..cubicTo(90 * s, 108 * s, 110 * s, 108 * s, 116 * s, 116 * s));
  }

  void _sadBrow(Canvas canvas, double s, double cx, {required bool flip}) {
    // Inner end rises toward center of face
    final innerX = flip ? cx + 14.0 : cx - 14.0;
    final outerX = flip ? cx - 14.0 : cx + 14.0;
    _drawPath(canvas, s, _browPaint(s), (p) => p
      ..moveTo(outerX * s, 64 * s)
      ..quadraticBezierTo(cx * s, 60 * s, innerX * s, 56 * s));
  }

  void _angryBrow(Canvas canvas, double s, {required bool left}) {
    if (left) {
      _drawPath(canvas, s, _browPaint(s, width: 3.0), (p) => p
        ..moveTo(66 * s, 58 * s)
        ..quadraticBezierTo(80 * s, 65 * s, 94 * s, 58 * s));
    } else {
      _drawPath(canvas, s, _browPaint(s, width: 3.0), (p) => p
        ..moveTo(106 * s, 58 * s)
        ..quadraticBezierTo(120 * s, 65 * s, 134 * s, 58 * s));
    }
  }

  void _raisedBrow(Canvas canvas, double s, double cx, double yOffset) {
    final y = 78 + yOffset;
    _drawPath(canvas, s, _browPaint(s), (p) => p
      ..moveTo((cx - 13) * s, y * s)
      ..quadraticBezierTo(cx * s, (y - 7) * s, (cx + 13) * s, y * s));
  }

  void _oMouth(Canvas canvas, double s, double w, double h) {
    final r = Rect.fromCenter(center: Offset(100 * s, 114 * s), width: w * s, height: h * s);
    canvas.drawOval(r, Paint()..color = const Color(0xFFD4594A).withOpacity(0.55));
    canvas.drawOval(r, _mouthPaint(s));
  }

  void _wagLines(Canvas canvas, double s) {
    // Short curved lines near tail to suggest wagging
    final linePaint = Paint()
      ..color = _body.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(162 * s, 178 * s), width: 20 * s, height: 12 * s),
      -0.8, 1.2, false, linePaint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(166 * s, 185 * s), width: 16 * s, height: 10 * s),
      -0.6, 1.0, false, linePaint,
    );
  }

  // ── Paint factories ──────────────────────────────────────────────────────────
  Paint _stroke(double s, double w) => Paint()
    ..color = _outline
    ..style = PaintingStyle.stroke
    ..strokeWidth = w * s
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Paint _mouthPaint(double s) => Paint()
    ..color = _outline.withOpacity(0.88)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.4 * s
    ..strokeCap = StrokeCap.round;

  Paint _browPaint(double s, {double width = 2.6}) => Paint()
    ..color = _outline.withOpacity(0.9)
    ..style = PaintingStyle.stroke
    ..strokeWidth = width * s
    ..strokeCap = StrokeCap.round;

  void _drawPath(Canvas canvas, double s, Paint paint, Path Function(Path) builder) {
    canvas.drawPath(builder(Path()), paint);
  }

  @override
  bool shouldRepaint(_CloverPainter old) => old.emotion != emotion;
}
