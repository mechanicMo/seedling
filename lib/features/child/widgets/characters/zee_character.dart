// Zee — teal octopus with purple shimmer. Curious, explorer, bridge character.
// Design: dome-shaped mantle, enormous curious eyes, 8 flowing tentacles,
// radial gradient body with subtle shimmer overlay, sucker dots on tentacles.
// Virtual canvas: 200×220. Scale: s = size.width / 200.

import 'dart:math' as math;
import 'package:flutter/material.dart';

class ZeeCharacter extends StatelessWidget {
  const ZeeCharacter({this.emotion = 'happy', this.size = 140, super.key});
  final String emotion;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ZeePainter(emotion)),
    );
  }
}

class _ZeePainter extends CustomPainter {
  const _ZeePainter(this.emotion);
  final String emotion;

  // Palette
  static const _teal        = Color(0xFF00AABB);
  static const _tealLight   = Color(0xFF40D4E8);
  static const _tealDark    = Color(0xFF007A88);
  static const _tealVDark   = Color(0xFF005566);
  static const _shimmer     = Color(0xFF9B59B6); // purple shimmer
  static const _outline     = Color(0xFF003C47);
  static const _irisBlue    = Color(0xFF1565C0);
  static const _irisBlueLt  = Color(0xFF42A5F5);
  static const _pupil       = Color(0xFF0D0D1A);
  static const _sucker      = Color(0xFF006A78);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 200;
    _drawShadow(canvas, s);
    // Draw back tentacles first (behind body)
    _drawBackTentacles(canvas, s);
    _drawMantle(canvas, s);
    // Front tentacles overlap edges of the mantle
    _drawFrontTentacles(canvas, s);
    _drawShimmer(canvas, s);
    _drawEyes(canvas, s);
    _drawEmotion(canvas, s);
  }

  // ── Shadow ───────────────────────────────────────────────────────────────────
  void _drawShadow(Canvas canvas, double s) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(100 * s, 218 * s), width: 90 * s, height: 10 * s),
      Paint()
        ..color = const Color(0x18000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }

  // ── Back tentacles (4, slightly muted — appear behind body) ─────────────────
  void _drawBackTentacles(Canvas canvas, double s) {
    final backColor = _tealDark;
    final backDark  = _tealVDark;

    // Each: (startX, startY, ctrl1X, ctrl1Y, ctrl2X, ctrl2Y, endX, endY)
    final tentacles = <List<double>>[
      [58.0,  148.0,  32.0, 170.0,  14.0, 196.0,  12.0, 210.0],
      [76.0,  152.0,  60.0, 175.0,  48.0, 200.0,  52.0, 215.0],
      [124.0, 152.0, 140.0, 175.0, 152.0, 200.0, 148.0, 215.0],
      [142.0, 148.0, 168.0, 170.0, 186.0, 196.0, 188.0, 210.0],
    ];

    for (final t in tentacles) {
      _tentacle(canvas, s, t, backColor, backDark, suckers: false);
    }
  }

  // ── Mantle (body dome) ───────────────────────────────────────────────────────
  void _drawMantle(Canvas canvas, double s) {
    // Dome-shaped — slightly wider than tall, flat at bottom where tentacles begin
    final mantleRect = Rect.fromCenter(
      center: Offset(100 * s, 95 * s),
      width: 110 * s,
      height: 116 * s,
    );

    final path = Path()
      ..moveTo(54 * s, 148 * s)
      ..cubicTo(38 * s, 148 * s, 28 * s, 126 * s, 28 * s, 100 * s)
      ..cubicTo(28 * s,  52 * s, 60 * s,  18 * s, 100 * s,  18 * s)
      ..cubicTo(140 * s, 18 * s, 172 * s,  52 * s, 172 * s, 100 * s)
      ..cubicTo(172 * s, 126 * s, 162 * s, 148 * s, 146 * s, 148 * s)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.2, -0.45),
          radius: 0.88,
          colors: const [_tealLight, _teal, _tealDark],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(mantleRect),
    );

    // Subtle inner body shading (darker bottom to suggest volume)
    final bottomShade = Path()
      ..moveTo(54 * s, 148 * s)
      ..cubicTo(38 * s, 148 * s, 28 * s, 126 * s, 28 * s, 115 * s)
      ..cubicTo(28 * s, 125 * s, 60 * s, 148 * s, 100 * s, 148 * s)
      ..cubicTo(140 * s, 148 * s, 172 * s, 125 * s, 172 * s, 115 * s)
      ..cubicTo(172 * s, 126 * s, 162 * s, 148 * s, 146 * s, 148 * s)
      ..close();
    canvas.drawPath(bottomShade, Paint()..color = _tealVDark.withOpacity(0.22));

    canvas.drawPath(path, _stroke(s, 2.5));
  }

  // ── Front tentacles (4, full color — on top of body edge) ───────────────────
  void _drawFrontTentacles(Canvas canvas, double s) {
    final tentacles = <List<double>>[
      [60.0,  150.0,  30.0, 172.0,  10.0, 198.0,  16.0, 212.0],
      [78.0,  152.0,  58.0, 178.0,  44.0, 205.0,  50.0, 216.0],
      [122.0, 152.0, 142.0, 178.0, 156.0, 205.0, 150.0, 216.0],
      [140.0, 150.0, 170.0, 172.0, 190.0, 198.0, 184.0, 212.0],
    ];

    for (final t in tentacles) {
      _tentacle(canvas, s, t, _teal, _tealDark, suckers: true);
    }
  }

  // Draws a single tentacle as a tapered filled path
  void _tentacle(Canvas canvas, double s, List<double> t, Color fill, Color dark,
      {required bool suckers}) {
    final x1 = t[0]; final y1 = t[1];
    final cx1 = t[2]; final cy1 = t[3];
    final cx2 = t[4]; final cy2 = t[5];
    final x2 = t[6]; final y2 = t[7];

    // Build tapered path: draw both sides of the tentacle
    // Side thickness from baseW at start to 2 at tip
    const baseW = 10.0;

    // Compute a perpendicular at the start point direction
    final dx = cx1 - x1; final dy = cy1 - y1;
    final len = math.sqrt(dx * dx + dy * dy);
    final px = (-dy / len) * baseW;
    final py = (dx / len) * baseW;

    final path = Path()
      ..moveTo((x1 + px) * s, (y1 + py) * s)
      ..cubicTo(
        (cx1 + px * 0.6) * s, (cy1 + py * 0.6) * s,
        (cx2 + px * 0.2) * s, (cy2 + py * 0.2) * s,
        x2 * s, y2 * s,
      )
      ..cubicTo(
        (cx2 - px * 0.2) * s, (cy2 - py * 0.2) * s,
        (cx1 - px * 0.6) * s, (cy1 - py * 0.6) * s,
        (x1 - px) * s, (y1 - py) * s,
      )
      ..close();

    final r = Rect.fromCenter(
      center: Offset(((x1 + x2) / 2) * s, ((y1 + y2) / 2) * s),
      width: 20 * s, height: (y2 - y1 + 20) * s,
    );
    canvas.drawPath(path, Paint()
      ..shader = LinearGradient(
        colors: [fill, dark],
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
      ).createShader(r));
    canvas.drawPath(path, Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round);

    // Sucker dots along the tentacle
    if (suckers) {
      for (double t2 = 0.25; t2 <= 0.85; t2 += 0.22) {
        final sx = _cubic(x1, cx1, cx2, x2, t2);
        final sy = _cubic(y1, cy1, cy2, y2, t2);
        canvas.drawCircle(
          Offset(sx * s, sy * s), 2.5 * s,
          Paint()..color = _sucker,
        );
      }
    }
  }

  // Cubic bezier at parameter t
  double _cubic(double p0, double p1, double p2, double p3, double t) {
    final u = 1 - t;
    return u * u * u * p0 + 3 * u * u * t * p1 + 3 * u * t * t * p2 + t * t * t * p3;
  }

  // ── Purple shimmer overlay ───────────────────────────────────────────────────
  void _drawShimmer(Canvas canvas, double s) {
    // Subtle diagonal shimmer band across the mantle
    final r = Rect.fromCenter(center: Offset(130 * s, 70 * s), width: 60 * s, height: 60 * s);
    canvas.drawOval(r, Paint()..color = _shimmer.withOpacity(0.11));
    // Second shimmer spot
    final r2 = Rect.fromCenter(center: Offset(75 * s, 110 * s), width: 30 * s, height: 30 * s);
    canvas.drawOval(r2, Paint()..color = _shimmer.withOpacity(0.08));
  }

  // ── Eyes (VERY large — most distinctive feature) ────────────────────────────
  void _drawEyes(Canvas canvas, double s) {
    _eye(canvas, Offset(74 * s, 88 * s), s);
    _eye(canvas, Offset(126 * s, 88 * s), s);
  }

  void _eye(Canvas canvas, Offset c, double s) {
    // Extra large oval eyes — Zee is defined by curiosity
    final eyeR = Rect.fromCenter(center: c, width: 34 * s, height: 40 * s);
    final irisC = c.translate(0, 2 * s);
    final pupilC = c.translate(1 * s, 3 * s);

    // Sclera — white oval
    canvas.drawOval(eyeR, Paint()..color = Colors.white);

    // Iris — deep blue gradient
    canvas.drawCircle(irisC, 14 * s, Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: const [_irisBlueLt, _irisBlue, Color(0xFF0D47A1)],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: irisC, radius: 14 * s)));

    // Pupil
    canvas.drawCircle(pupilC, 8.5 * s, Paint()
      ..shader = RadialGradient(
        colors: const [Color(0xFF1A1A2E), _pupil],
      ).createShader(Rect.fromCircle(center: pupilC, radius: 8.5 * s)));

    // Large main catchlight
    canvas.drawCircle(c.translate(4 * s, -2 * s), 4.5 * s, Paint()..color = Colors.white);
    // Secondary sparkle
    canvas.drawCircle(c.translate(-4.5 * s, 5 * s), 2 * s, Paint()..color = Colors.white.withOpacity(0.8));

    // Eye outline
    canvas.drawOval(eyeR, _stroke(s, 2.0));
  }

  // ── Emotion expressions ──────────────────────────────────────────────────────
  void _drawEmotion(Canvas canvas, double s) {
    switch (emotion) {
      case 'happy':      _happy(canvas, s);       break;
      case 'sad':        _sad(canvas, s);          break;
      case 'angry':      _angry(canvas, s);        break;
      case 'scared':     _scared(canvas, s);       break;
      case 'surprised':  _surprised(canvas, s);    break;
      case 'frustrated': _frustrated(canvas, s);   break;
      case 'proud':      _proud(canvas, s);        break;
      default:           _happy(canvas, s);
    }
  }

  void _happy(Canvas canvas, double s) {
    for (final cx in [74.0, 126.0]) { _upperLid(canvas, s, cx, 88, 10); }
    _smile(canvas, s, 86, 116, 114, 116, depth: 12);
  }

  void _sad(Canvas canvas, double s) {
    _sadBrow(canvas, s, 74, flip: false);
    _sadBrow(canvas, s, 126, flip: true);
    _frown(canvas, s, 88, 118, 112, 118, depth: 10);
    // Tears
    for (final x in [68.0, 132.0]) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x * s, 104 * s), width: 5 * s, height: 8 * s),
        Paint()..color = const Color(0xFF90CAF9).withOpacity(0.9),
      );
    }
  }

  void _angry(Canvas canvas, double s) {
    _angryBrow(canvas, s, left: true);
    _angryBrow(canvas, s, left: false);
    for (final cx in [74.0, 126.0]) { _lowerLid(canvas, s, cx, 88, 9); }
    _drawPath(canvas, s, _mouthPaint(s), (p) => p
      ..moveTo(88 * s, 118 * s)
      ..cubicTo(94 * s, 116 * s, 106 * s, 116 * s, 112 * s, 118 * s));
  }

  void _scared(Canvas canvas, double s) {
    _raisedBrow(canvas, s, 74, -34);
    _raisedBrow(canvas, s, 126, -34);
    _oMouth(canvas, s, 20, 16);
  }

  void _surprised(Canvas canvas, double s) {
    _raisedBrow(canvas, s, 74, -40);
    _raisedBrow(canvas, s, 126, -40);
    _oMouth(canvas, s, 26, 22);
  }

  void _frustrated(Canvas canvas, double s) {
    _drawPath(canvas, s, _browPaint(s), (p) => p
      ..moveTo(60 * s, 66 * s)
      ..quadraticBezierTo(74 * s, 62 * s, 88 * s, 68 * s));
    _drawPath(canvas, s, _browPaint(s), (p) => p
      ..moveTo(112 * s, 66 * s)
      ..quadraticBezierTo(126 * s, 64 * s, 140 * s, 68 * s));
    _drawPath(canvas, s, _mouthPaint(s), (p) => p
      ..moveTo(88 * s, 116 * s)
      ..cubicTo(94 * s, 109 * s, 100 * s, 122 * s, 100 * s, 116 * s)
      ..cubicTo(100 * s, 110 * s, 106 * s, 122 * s, 112 * s, 116 * s));
  }

  void _proud(Canvas canvas, double s) {
    for (final cx in [74.0, 126.0]) { _upperLid(canvas, s, cx, 88, 8); }
    _smile(canvas, s, 88, 114, 112, 114, depth: 9);
  }

  // ── Expression helpers ───────────────────────────────────────────────────────

  void _upperLid(Canvas canvas, double s, double cx, double cy, double depth) {
    final lid = Path()
      ..moveTo((cx - 17) * s, cy * s)
      ..quadraticBezierTo(cx * s, (cy - depth) * s, (cx + 17) * s, cy * s)
      ..lineTo((cx + 17) * s, (cy - 35) * s)
      ..lineTo((cx - 17) * s, (cy - 35) * s)
      ..close();
    canvas.drawPath(lid, Paint()..color = _teal);
    _drawPath(canvas, s, _stroke(s, 2.0), (p) => p
      ..moveTo((cx - 17) * s, cy * s)
      ..quadraticBezierTo(cx * s, (cy - depth) * s, (cx + 17) * s, cy * s));
  }

  void _lowerLid(Canvas canvas, double s, double cx, double cy, double depth) {
    final lid = Path()
      ..moveTo((cx - 17) * s, cy * s)
      ..quadraticBezierTo(cx * s, (cy + depth) * s, (cx + 17) * s, cy * s)
      ..lineTo((cx + 17) * s, (cy + 35) * s)
      ..lineTo((cx - 17) * s, (cy + 35) * s)
      ..close();
    canvas.drawPath(lid, Paint()..color = _teal);
    _drawPath(canvas, s, _stroke(s, 2.0), (p) => p
      ..moveTo((cx - 17) * s, cy * s)
      ..quadraticBezierTo(cx * s, (cy + depth) * s, (cx + 17) * s, cy * s));
  }

  void _smile(Canvas canvas, double s, double x1, double y1, double x2, double y2,
      {required double depth}) {
    final fill = Path()
      ..moveTo(x1 * s, y1 * s)
      ..cubicTo(
        (x1 + (x2 - x1) * 0.33) * s, (y1 + depth) * s,
        (x1 + (x2 - x1) * 0.67) * s, (y1 + depth) * s,
        x2 * s, y2 * s)
      ..close();
    canvas.drawPath(fill, Paint()..color = const Color(0xFF006070).withOpacity(0.45));
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

  void _sadBrow(Canvas canvas, double s, double cx, {required bool flip}) {
    final innerX = flip ? cx + 17.0 : cx - 17.0;
    final outerX = flip ? cx - 17.0 : cx + 17.0;
    _drawPath(canvas, s, _browPaint(s), (p) => p
      ..moveTo(outerX * s, 66 * s)
      ..quadraticBezierTo(cx * s, 62 * s, innerX * s, 56 * s));
  }

  void _angryBrow(Canvas canvas, double s, {required bool left}) {
    if (left) {
      _drawPath(canvas, s, _browPaint(s, width: 3.2), (p) => p
        ..moveTo(57 * s, 60 * s)
        ..quadraticBezierTo(74 * s, 68 * s, 91 * s, 60 * s));
    } else {
      _drawPath(canvas, s, _browPaint(s, width: 3.2), (p) => p
        ..moveTo(109 * s, 60 * s)
        ..quadraticBezierTo(126 * s, 68 * s, 143 * s, 60 * s));
    }
  }

  void _raisedBrow(Canvas canvas, double s, double cx, double yOffset) {
    final y = 88 + yOffset;
    _drawPath(canvas, s, _browPaint(s), (p) => p
      ..moveTo((cx - 17) * s, y * s)
      ..quadraticBezierTo(cx * s, (y - 9) * s, (cx + 17) * s, y * s));
  }

  void _oMouth(Canvas canvas, double s, double w, double h) {
    final r = Rect.fromCenter(center: Offset(100 * s, 118 * s), width: w * s, height: h * s);
    canvas.drawOval(r, Paint()..color = const Color(0xFF004455).withOpacity(0.55));
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
    ..color = _outline.withOpacity(0.9)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.4 * s
    ..strokeCap = StrokeCap.round;

  Paint _browPaint(double s, {double width = 2.6}) => Paint()
    ..color = _outline.withOpacity(0.88)
    ..style = PaintingStyle.stroke
    ..strokeWidth = width * s
    ..strokeCap = StrokeCap.round;

  void _drawPath(Canvas canvas, double s, Paint paint, Path Function(Path) builder) {
    canvas.drawPath(builder(Path()), paint);
  }

  @override
  bool shouldRepaint(_ZeePainter old) => old.emotion != emotion;
}
