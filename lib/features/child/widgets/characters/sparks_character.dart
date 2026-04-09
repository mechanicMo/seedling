// Sparks — warm yellow baby dinosaur. Emotional, round, tiny arms, amber crest.
// Design: oversized head (~60% of canvas), egg body, 5 crest bumps arcing over crown,
// large expressive eyes w/ green iris + catchlights, rosy cheeks.
// Virtual canvas: 200×220. Scale: s = size.width / 200.

import 'package:flutter/material.dart';

class SparksCharacter extends StatelessWidget {
  const SparksCharacter({this.emotion = 'happy', this.size = 140, super.key});
  final String emotion;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _SparksPainter(emotion)),
    );
  }
}

class _SparksPainter extends CustomPainter {
  const _SparksPainter(this.emotion);
  final String emotion;

  // Palette
  static const _bodyYellow    = Color(0xFFFFD93D);
  static const _bodyYellowLt  = Color(0xFFFFF07A);
  static const _bodyYellowDk  = Color(0xFFE8A000);
  static const _crestAmber    = Color(0xFFFF9F1C);
  static const _crestAmberDk  = Color(0xFFCC6A00);
  static const _outline       = Color(0xFF4A2C00);
  static const _irisGreen     = Color(0xFF43A047);
  static const _irisGreenDk   = Color(0xFF2E7D32);
  static const _pupil         = Color(0xFF1A1210);
  static const _blush         = Color(0xFFFF6E40);
  static const _mouthPink     = Color(0xFFD4594A);
  static const _tearBlue      = Color(0xFF64B5F6);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 200;
    _drawShadow(canvas, s);
    _drawTail(canvas, s);
    _drawBody(canvas, s);
    _drawArms(canvas, s);
    _drawCrest(canvas, s); // drawn before head so head overlaps base of bumps
    _drawHead(canvas, s);
    _drawCheeks(canvas, s);
    _drawEyes(canvas, s);
    _drawEmotion(canvas, s);
  }

  // ── Shadow ──────────────────────────────────────────────────────────────────
  void _drawShadow(Canvas canvas, double s) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(100 * s, 214 * s), width: 88 * s, height: 10 * s),
      Paint()
        ..color = const Color(0x18000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }

  // ── Tail ────────────────────────────────────────────────────────────────────
  void _drawTail(Canvas canvas, double s) {
    final r = Rect.fromLTWH(140 * s, 148 * s, 42 * s, 44 * s);
    final path = Path()
      ..moveTo(148 * s, 182 * s)
      ..cubicTo(165 * s, 172 * s, 180 * s, 162 * s, 178 * s, 150 * s)
      ..cubicTo(176 * s, 140 * s, 164 * s, 142 * s, 156 * s, 152 * s)
      ..cubicTo(150 * s, 160 * s, 148 * s, 172 * s, 148 * s, 182 * s)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          colors: const [_bodyYellowLt, _bodyYellowDk],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(r),
    );
    canvas.drawPath(path, _stroke(s, 2.0));
  }

  // ── Body ────────────────────────────────────────────────────────────────────
  void _drawBody(Canvas canvas, double s) {
    final r = Rect.fromCenter(center: Offset(100 * s, 165 * s), width: 110 * s, height: 96 * s);
    final path = Path()
      ..moveTo(100 * s, 120 * s)
      ..cubicTo(142 * s, 120 * s, 156 * s, 142 * s, 156 * s, 172 * s)
      ..cubicTo(156 * s, 200 * s, 134 * s, 212 * s, 100 * s, 212 * s)
      ..cubicTo(66  * s, 212 * s, 44  * s, 200 * s, 44  * s, 172 * s)
      ..cubicTo(44  * s, 142 * s, 58  * s, 120 * s, 100 * s, 120 * s)
      ..close();

    // Body fill (gradient: lighter top-left → warmer bottom-right)
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          colors: const [_bodyYellowLt, _bodyYellow, _bodyYellowDk],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.45, 1.0],
        ).createShader(r),
    );

    // Belly highlight: a lighter pear-shaped inner area
    final belly = Path()
      ..moveTo(100 * s, 128 * s)
      ..cubicTo(122 * s, 128 * s, 134 * s, 144 * s, 134 * s, 165 * s)
      ..cubicTo(134 * s, 186 * s, 120 * s, 198 * s, 100 * s, 198 * s)
      ..cubicTo(80  * s, 198 * s, 66  * s, 186 * s, 66  * s, 165 * s)
      ..cubicTo(66  * s, 144 * s, 78  * s, 128 * s, 100 * s, 128 * s)
      ..close();
    canvas.drawPath(belly, Paint()..color = const Color(0x55FFF9C4));

    canvas.drawPath(path, _stroke(s, 2.5));
  }

  // ── Arms ────────────────────────────────────────────────────────────────────
  void _drawArms(Canvas canvas, double s) {
    final leftR  = Rect.fromLTWH(28 * s, 136 * s, 28 * s, 26 * s);
    final rightR = Rect.fromLTWH(144 * s, 136 * s, 28 * s, 26 * s);

    void arm(Path p, Rect r) {
      canvas.drawPath(p, Paint()
        ..shader = LinearGradient(
          colors: const [_bodyYellow, _bodyYellowDk],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ).createShader(r));
      canvas.drawPath(p, _stroke(s, 1.8));
    }

    // Left: tiny stub pointing left-down
    final left = Path()
      ..moveTo(52 * s, 140 * s)
      ..cubicTo(38 * s, 136 * s, 30 * s, 148 * s, 38 * s, 158 * s)
      ..cubicTo(44 * s, 165 * s, 54 * s, 158 * s, 52 * s, 140 * s)
      ..close();
    arm(left, leftR);

    // Right: mirror
    final right = Path()
      ..moveTo(148 * s, 140 * s)
      ..cubicTo(162 * s, 136 * s, 170 * s, 148 * s, 162 * s, 158 * s)
      ..cubicTo(156 * s, 165 * s, 146 * s, 158 * s, 148 * s, 140 * s)
      ..close();
    arm(right, rightR);
  }

  // ── Crest bumps (drawn before head; head covers their roots) ─────────────
  void _drawCrest(Canvas canvas, double s) {
    // 5 bumps: sizes peak at center, taper to edges
    const bumps = [
      (68.0, 30.0,  9.0),
      (82.0, 21.0, 11.0),
      (100.0, 17.0, 13.0),
      (118.0, 21.0, 11.0),
      (132.0, 30.0,  9.0),
    ];
    for (final (x, y, r) in bumps) {
      final center = Offset(x * s, y * s);
      canvas.drawCircle(
        center, r * s,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.3, -0.5),
            colors: const [Color(0xFFFFBF40), _crestAmber, _crestAmberDk],
            stops: const [0.0, 0.55, 1.0],
          ).createShader(Rect.fromCircle(center: center, radius: r * s)),
      );
      canvas.drawCircle(center, r * s, _stroke(s, 1.6));
    }
  }

  // ── Head ────────────────────────────────────────────────────────────────────
  void _drawHead(Canvas canvas, double s) {
    const cx = 100.0; const cy = 84.0; const r = 62.0;
    final center = Offset(cx * s, cy * s);

    // Radial gradient: brighter upper-left, warmer lower-right
    canvas.drawCircle(
      center, r * s,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.28, -0.38),
          radius: 0.92,
          colors: const [Color(0xFFFFF07A), _bodyYellow, _bodyYellowDk],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: r * s)),
    );
    canvas.drawCircle(center, r * s, _stroke(s, 2.5));
  }

  // ── Cheek blush ─────────────────────────────────────────────────────────────
  void _drawCheeks(Canvas canvas, double s) {
    for (final x in [64.0, 136.0]) {
      canvas.drawCircle(
        Offset(x * s, 102 * s), 13 * s,
        Paint()..color = _blush.withOpacity(0.18),
      );
    }
  }

  // ── Eyes ────────────────────────────────────────────────────────────────────
  void _drawEyes(Canvas canvas, double s) {
    _drawOneEye(canvas, Offset(78 * s, 81 * s), s);
    _drawOneEye(canvas, Offset(122 * s, 81 * s), s);
  }

  void _drawOneEye(Canvas canvas, Offset c, double s) {
    final eyeRect = Rect.fromCenter(center: c, width: 28 * s, height: 33 * s);
    final irisC   = c.translate(0, 2 * s);
    final pupilC  = c.translate(0.5 * s, 2.5 * s);

    // 1. Sclera
    canvas.drawOval(eyeRect, Paint()..color = Colors.white);

    // 2. Iris (gradient for depth)
    canvas.drawCircle(
      irisC, 12 * s,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          colors: const [Color(0xFF66BB6A), _irisGreen, _irisGreenDk],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: irisC, radius: 12 * s)),
    );

    // 3. Pupil (slightly off-center for liveliness)
    canvas.drawCircle(
      pupilC, 7.5 * s,
      Paint()
        ..shader = RadialGradient(
          colors: const [Color(0xFF2D2020), _pupil],
        ).createShader(Rect.fromCircle(center: pupilC, radius: 7.5 * s)),
    );

    // 4. Main catchlight (upper-right, large)
    canvas.drawCircle(c.translate(3.5 * s, -1 * s), 4 * s, Paint()..color = Colors.white);
    // 5. Secondary catchlight (lower-left, tiny)
    canvas.drawCircle(c.translate(-3.5 * s, 4.5 * s), 1.8 * s, Paint()..color = Colors.white.withOpacity(0.75));

    // 6. Eye outline
    canvas.drawOval(eyeRect, _stroke(s, 1.8));
  }

  // ── Emotion-specific face ───────────────────────────────────────────────────
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

  // Happy: raised-cheek eyelids (soft arc masking top of eye), wide smile
  void _happy(Canvas canvas, double s) {
    for (final cx in [78.0, 122.0]) {
      _eyelid(canvas, s, cx, 81, upper: true, arcDepth: 9);
    }
    _smile(canvas, s, 80, 112, 120, 112, depth: 14);
  }

  // Sad: arched inner brows, downturned mouth, tears
  void _sad(Canvas canvas, double s) {
    _brow(canvas, s, 78, innerY: 58, outerY: 64, flip: false);
    _brow(canvas, s, 122, innerY: 58, outerY: 64, flip: true);
    _frown(canvas, s, 82, 112, 118, 112, depth: 10);
    // Tear drops
    for (final x in [74.0, 126.0]) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x * s, 97 * s), width: 5.5 * s, height: 9 * s),
        Paint()..color = _tearBlue.withOpacity(0.9),
      );
    }
  }

  // Angry: strong angled brows, squinted eyelids, flat mouth
  void _angry(Canvas canvas, double s) {
    _angryBrow(canvas, s, left: true);
    _angryBrow(canvas, s, left: false);
    // Lower eyelids (squint)
    for (final cx in [78.0, 122.0]) {
      _eyelid(canvas, s, cx, 81, upper: false, arcDepth: 8);
    }
    // Flat tight mouth
    _drawPath(
      canvas, s,
      Paint()
        ..color = _outline.withOpacity(0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.8 * s
        ..strokeCap = StrokeCap.round,
      (p) => p
        ..moveTo(83 * s, 112 * s)
        ..cubicTo(91 * s, 110 * s, 109 * s, 110 * s, 117 * s, 112 * s),
    );
  }

  // Scared: very wide eyes (open fully), high arched brows, O-mouth
  void _scared(Canvas canvas, double s) {
    _raisedBrow(canvas, s, 78, yOffset: -32);
    _raisedBrow(canvas, s, 122, yOffset: -32);
    _oMouth(canvas, s, 20, 17);
  }

  // Surprised: eyebrows very high, open rounded mouth
  void _surprised(Canvas canvas, double s) {
    _raisedBrow(canvas, s, 78, yOffset: -38);
    _raisedBrow(canvas, s, 122, yOffset: -38);
    _oMouth(canvas, s, 26, 22);
  }

  // Frustrated: asymmetric brows, wavy mouth
  void _frustrated(Canvas canvas, double s) {
    // Left brow angled down toward center
    _drawPath(canvas, s, _browPaint(s), (p) => p
      ..moveTo(64 * s, 62 * s)
      ..quadraticBezierTo(78 * s, 58 * s, 92 * s, 64 * s));
    // Right brow less severe
    _drawPath(canvas, s, _browPaint(s), (p) => p
      ..moveTo(108 * s, 62 * s)
      ..quadraticBezierTo(122 * s, 60 * s, 136 * s, 65 * s));
    // Wavy mouth
    _drawPath(canvas, s, _mouthPaint(s), (p) => p
      ..moveTo(82 * s, 110 * s)
      ..cubicTo(89 * s, 103 * s, 95 * s, 119 * s, 100 * s, 112 * s)
      ..cubicTo(105 * s, 105 * s, 111 * s, 120 * s, 118 * s, 112 * s));
  }

  // Proud: confident half-lidded eyes, knowing smile
  void _proud(Canvas canvas, double s) {
    for (final cx in [78.0, 122.0]) {
      _eyelid(canvas, s, cx, 81, upper: true, arcDepth: 7);
    }
    _smile(canvas, s, 82, 110, 118, 110, depth: 10);
  }

  // ── Drawing helpers ──────────────────────────────────────────────────────────

  // Eyelid: covers top (upper=true) or bottom of eye with face-colored arc
  void _eyelid(Canvas canvas, double s, double cx, double cy,
      {required bool upper, required double arcDepth}) {
    final y = cy * s;
    final paint = Paint()..color = _bodyYellow; // same as face color

    if (upper) {
      // Cover upper portion — arc masks the top of the sclera
      final lid = Path()
        ..moveTo((cx - 14) * s, y)
        ..quadraticBezierTo(cx * s, (cy - arcDepth) * s, (cx + 14) * s, y)
        ..lineTo((cx + 14) * s, (cy - 30) * s)
        ..lineTo((cx - 14) * s, (cy - 30) * s)
        ..close();
      canvas.drawPath(lid, paint);
      // Eyelash line on top of lid
      _drawPath(canvas, s, _stroke(s, 2.0), (p) => p
        ..moveTo((cx - 14) * s, y)
        ..quadraticBezierTo(cx * s, (cy - arcDepth) * s, (cx + 14) * s, y));
    } else {
      // Lower lid — covers bottom of eye
      final lid = Path()
        ..moveTo((cx - 14) * s, y)
        ..quadraticBezierTo(cx * s, (cy + arcDepth) * s, (cx + 14) * s, y)
        ..lineTo((cx + 14) * s, (cy + 30) * s)
        ..lineTo((cx - 14) * s, (cy + 30) * s)
        ..close();
      canvas.drawPath(lid, paint);
      _drawPath(canvas, s, _stroke(s, 1.8), (p) => p
        ..moveTo((cx - 14) * s, y)
        ..quadraticBezierTo(cx * s, (cy + arcDepth) * s, (cx + 14) * s, y));
    }
  }

  void _smile(Canvas canvas, double s, double x1, double y1, double x2, double y2,
      {required double depth}) {
    // Filled mouth interior
    final mouthFill = Path()
      ..moveTo(x1 * s, y1 * s)
      ..cubicTo(
          (x1 + (x2 - x1) * 0.33) * s, (y1 + depth) * s,
          (x1 + (x2 - x1) * 0.67) * s, (y1 + depth) * s,
          x2 * s, y2 * s)
      ..lineTo(x2 * s, y2 * s)
      ..close();
    canvas.drawPath(mouthFill, Paint()..color = _mouthPink.withOpacity(0.55));
    _drawPath(canvas, s, _mouthPaint(s), (p) => p
      ..moveTo(x1 * s, y1 * s)
      ..cubicTo(
          (x1 + (x2 - x1) * 0.33) * s, (y1 + depth) * s,
          (x1 + (x2 - x1) * 0.67) * s, (y1 + depth) * s,
          x2 * s, y2 * s));
  }

  void _frown(Canvas canvas, double s, double x1, double y1, double x2, double y2,
      {required double depth}) {
    _drawPath(canvas, s, _mouthPaint(s), (p) => p
      ..moveTo(x1 * s, y1 * s)
      ..cubicTo(
          (x1 + (x2 - x1) * 0.33) * s, (y1 - depth) * s,
          (x1 + (x2 - x1) * 0.67) * s, (y1 - depth) * s,
          x2 * s, y2 * s));
  }

  void _brow(Canvas canvas, double s, double cx,
      {required double innerY, required double outerY, required bool flip}) {
    // Sad/worried brow: inner corner higher
    final x1 = flip ? (cx - 14.0) : (cx - 14.0);
    final x2 = flip ? (cx + 14.0) : (cx + 14.0);
    final y1 = flip ? outerY : innerY;
    final y2 = flip ? innerY : outerY;
    _drawPath(canvas, s, _browPaint(s), (p) => p
      ..moveTo(x1 * s, y1 * s)
      ..quadraticBezierTo(cx * s, (innerY - 4) * s, x2 * s, y2 * s));
  }

  void _angryBrow(Canvas canvas, double s, {required bool left}) {
    // Angry: inner end pitched downward (toward nose)
    if (left) {
      _drawPath(canvas, s, _browPaint(s, width: 3.2), (p) => p
        ..moveTo(64 * s, 58 * s)
        ..quadraticBezierTo(78 * s, 64 * s, 92 * s, 58 * s));
    } else {
      _drawPath(canvas, s, _browPaint(s, width: 3.2), (p) => p
        ..moveTo(108 * s, 58 * s)
        ..quadraticBezierTo(122 * s, 64 * s, 136 * s, 58 * s));
    }
  }

  void _raisedBrow(Canvas canvas, double s, double cx, {required double yOffset}) {
    final y = 81 + yOffset;
    _drawPath(canvas, s, _browPaint(s), (p) => p
      ..moveTo((cx - 14) * s, y * s)
      ..quadraticBezierTo(cx * s, (y - 8) * s, (cx + 14) * s, y * s));
  }

  void _oMouth(Canvas canvas, double s, double w, double h) {
    final r = Rect.fromCenter(center: Offset(100 * s, 113 * s), width: w * s, height: h * s);
    canvas.drawOval(r, Paint()..color = _mouthPink.withOpacity(0.6));
    canvas.drawOval(r, _mouthPaint(s));
  }

  // ── Paint factories ──────────────────────────────────────────────────────────
  Paint _stroke(double s, double w) => Paint()
    ..color = _outline
    ..style = PaintingStyle.stroke
    ..strokeWidth = w * s
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Paint _mouthPaint(double s) => Paint()
    ..color = _outline.withOpacity(0.85)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.6 * s
    ..strokeCap = StrokeCap.round;

  Paint _browPaint(double s, {double width = 2.8}) => Paint()
    ..color = _outline.withOpacity(0.88)
    ..style = PaintingStyle.stroke
    ..strokeWidth = width * s
    ..strokeCap = StrokeCap.round;

  void _drawPath(Canvas canvas, double s, Paint paint, Path Function(Path) builder) {
    canvas.drawPath(builder(Path()), paint);
  }

  @override
  bool shouldRepaint(_SparksPainter old) => old.emotion != emotion;
}
