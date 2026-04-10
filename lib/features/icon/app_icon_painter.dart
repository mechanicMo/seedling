import 'package:flutter/material.dart';

// ── Colors ────────────────────────────────────────────────────────────────────
const _green = Color(0xFF4A7C59);
const _cream = Color(0xFFFAF7F0);
const _amber = Color(0xFFE8C99A);

// ── Preview screen ────────────────────────────────────────────────────────────

class AppIconPreviewScreen extends StatelessWidget {
  const AppIconPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(title: const Text('Icon Options')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              _IconPreviewTile(
                label: 'Option A — Side by Side',
                painter: const SeedlingIconA(),
              ),
              const SizedBox(height: 32),
              _IconPreviewTile(
                label: 'Option B — Nurture',
                painter: const SeedlingIconB(),
              ),
              const SizedBox(height: 32),
              _IconPreviewTile(
                label: 'Option C — Together (cream bg)',
                painter: const SeedlingIconC(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconPreviewTile extends StatelessWidget {
  const _IconPreviewTile({required this.label, required this.painter});
  final String label;
  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large preview
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: CustomPaint(painter: painter, size: const Size(200, 200)),
            ),
            const SizedBox(width: 24),
            // Small preview (phone home screen size)
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CustomPaint(painter: painter, size: const Size(80, 80)),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomPaint(painter: painter, size: const Size(48, 48)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54)),
      ],
    );
  }
}

// ── Option A: Airy ────────────────────────────────────────────────────────
// Cream bg. Two clearly-separated figures (no touching arms/bodies).
// Parent left, child right, sprout growing tall from center between them.
// Simplest possible silhouettes — circle head + egg body.

class SeedlingIconA extends CustomPainter {
  const SeedlingIconA();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    _drawBackground(canvas, size, _cream);

    // ── Sprout (drawn first so figures overlap it slightly at base) ──
    _drawSprout(
      canvas,
      cx: w * 0.50,
      baseY: h * 0.76,
      topY: h * 0.08,
      leafSpan: w * 0.14,
      stemWidth: w * 0.025,
      color: _green,
    );

    // ── Parent (left, taller) ──────────────────────────────────────────
    // Head circle + rounded-bottom egg body. Bodies are narrow so they
    // don't crowd center — inner edge of body at ~x=0.30.
    _drawSimpleFigure(
      canvas,
      color: _green,
      cx: w * 0.225,
      headR: w * 0.082,
      headCenterY: h * 0.295,
      bodyHalfW: w * 0.075,
      bodyBottom: h * 0.76,
    );

    // ── Child (right, shorter) ─────────────────────────────────────────
    // Inner edge at ~x=0.70.
    _drawSimpleFigure(
      canvas,
      color: _green,
      cx: w * 0.775,
      headR: w * 0.065,
      headCenterY: h * 0.405,
      bodyHalfW: w * 0.060,
      bodyBottom: h * 0.76,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ── Option B: Shelter ─────────────────────────────────────────────────────
// Green bg, cream figures. Parent stands tall on left. Child stands close on
// right, tucked slightly under the parent's arm arc (no bodies touching).
// A single bold arc from parent shoulder sweeps over child — reads as
// "sheltering arm" with one shape, no cluttered lines.
// Amber sprout grows in front of them at center.

class SeedlingIconB extends CustomPainter {
  const SeedlingIconB();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    _drawBackground(canvas, size, _green);

    // ── Parent (left) ─────────────────────────────────────────────────
    final pX = w * 0.32;
    final pHeadR = w * 0.088;
    final pHeadY = h * 0.26;
    _drawSimpleFigure(
      canvas,
      color: _cream,
      cx: pX,
      headR: pHeadR,
      headCenterY: pHeadY,
      bodyHalfW: w * 0.076,
      bodyBottom: h * 0.78,
    );

    // ── Child (right) ──────────────────────────────────────────────────
    final cX = w * 0.62;
    final cHeadR = w * 0.065;
    final cHeadY = h * 0.40;
    _drawSimpleFigure(
      canvas,
      color: _cream,
      cx: cX,
      headR: cHeadR,
      headCenterY: cHeadY,
      bodyHalfW: w * 0.058,
      bodyBottom: h * 0.78,
    );

    // ── Sheltering arm — single arc from parent shoulder over child ───
    final armPaint = Paint()
      ..color = _cream
      ..strokeWidth = w * 0.055
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final armPath = Path()
      ..moveTo(pX + w * 0.076, pHeadY + pHeadR * 0.5)
      ..quadraticBezierTo(
        w * 0.56, h * 0.22,              // arc peaks above child head
        cX + w * 0.055, cHeadY - cHeadR * 0.3, // lands on child far shoulder
      );
    canvas.drawPath(armPath, armPaint);

    // ── Sprout (center-left of figures, grows tall) ────────────────────
    _drawSprout(
      canvas,
      cx: w * 0.50,
      baseY: h * 0.80,
      topY: h * 0.07,
      leafSpan: w * 0.11,
      stemWidth: w * 0.022,
      color: _amber,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ── Option C: Beside ──────────────────────────────────────────────────────
// Cream bg. Minimal — two well-separated figures flanking a central sprout.
// No arms, no connecting elements. Pure negative space between them.
// Figures pushed to outer thirds so the center breathes.

class SeedlingIconC extends CustomPainter {
  const SeedlingIconC();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    _drawBackground(canvas, size, _cream);

    // Sprout first (figures sit in front at base)
    _drawSprout(
      canvas,
      cx: w * 0.50,
      baseY: h * 0.80,
      topY: h * 0.07,
      leafSpan: w * 0.13,
      stemWidth: w * 0.024,
      color: _amber,
    );

    // ── Parent (left outer third) ──────────────────────────────────────
    _drawSimpleFigure(
      canvas,
      color: _green,
      cx: w * 0.23,
      headR: w * 0.082,
      headCenterY: h * 0.285,
      bodyHalfW: w * 0.070,
      bodyBottom: h * 0.80,
    );

    // ── Child (right outer third) ──────────────────────────────────────
    _drawSimpleFigure(
      canvas,
      color: _green,
      cx: w * 0.77,
      headR: w * 0.062,
      headCenterY: h * 0.415,
      bodyHalfW: w * 0.054,
      bodyBottom: h * 0.80,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ── Simple figure helper ──────────────────────────────────────────────────────
// Circle head + rounded pill body. Body is intentionally NARROWER than head
// so figures stay slim and don't crowd each other. The head circle sitting on
// top of the pill is the universal "person" read at icon sizes.

void _drawSimpleFigure(
  Canvas canvas, {
  required Color color,
  required double cx,
  required double headR,
  required double headCenterY,
  required double bodyHalfW,   // should be slightly less than headR
  required double bodyBottom,
}) {
  final paint = Paint()..color = color;

  // Body pill — drawn first so head overlaps the top
  final bodyTop = headCenterY + headR * 0.45;
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTRB(cx - bodyHalfW, bodyTop, cx + bodyHalfW, bodyBottom),
      Radius.circular(bodyHalfW),
    ),
    paint,
  );

  // Head — drawn on top, slightly overlapping body for seamless join
  canvas.drawCircle(Offset(cx, headCenterY), headR, paint);
}

// ── Shared helpers ────────────────────────────────────────────────────────────

void _drawBackground(Canvas canvas, Size size, Color color) {
  final paint = Paint()..color = color;
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.width * 0.22),
    ),
    paint,
  );
}

void _drawSprout(
  Canvas canvas, {
  required double cx,
  required double baseY,
  required double topY,
  required double leafSpan,
  required double stemWidth,
  required Color color,
}) {
  final stemPaint = Paint()
    ..color = color
    ..strokeWidth = stemWidth
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  final leafPaint = Paint()
    ..color = color
    ..style = PaintingStyle.fill;

  // Stem — gentle S-curve
  final stemPath = Path()
    ..moveTo(cx, baseY)
    ..cubicTo(
      cx - stemWidth * 1.5, baseY - (baseY - topY) * 0.4,
      cx + stemWidth * 1.5, baseY - (baseY - topY) * 0.7,
      cx, topY,
    );
  canvas.drawPath(stemPath, stemPaint);

  // Left leaf — grows from ~40% up the stem
  final leafMidY = baseY - (baseY - topY) * 0.42;
  final leftLeaf = Path()
    ..moveTo(cx, leafMidY)
    ..quadraticBezierTo(
        cx - leafSpan * 1.1, leafMidY - (baseY - topY) * 0.18,
        cx - leafSpan * 0.6, leafMidY - (baseY - topY) * 0.36)
    ..quadraticBezierTo(
        cx - leafSpan * 0.1, leafMidY - (baseY - topY) * 0.08,
        cx, leafMidY)
    ..close();
  canvas.drawPath(leftLeaf, leafPaint);

  // Right leaf — grows from ~60% up the stem
  final leafHighY = baseY - (baseY - topY) * 0.60;
  final rightLeaf = Path()
    ..moveTo(cx, leafHighY)
    ..quadraticBezierTo(
        cx + leafSpan * 1.1, leafHighY - (baseY - topY) * 0.16,
        cx + leafSpan * 0.55, leafHighY - (baseY - topY) * 0.32)
    ..quadraticBezierTo(
        cx + leafSpan * 0.08, leafHighY - (baseY - topY) * 0.06,
        cx, leafHighY)
    ..close();
  canvas.drawPath(rightLeaf, leafPaint);
}
