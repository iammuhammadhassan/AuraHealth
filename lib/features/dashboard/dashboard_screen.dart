// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const double _screenPadding = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const _DashboardHeader(),
          SliverPadding(
            padding: const EdgeInsets.all(_screenPadding),
            sliver: SliverToBoxAdapter(child: const _DailyInsightCard()),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              _screenPadding,
              0,
              _screenPadding,
              20,
            ),
            sliver: const SliverToBoxAdapter(child: _QuickActionsRow()),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              _screenPadding,
              0,
              _screenPadding,
              _screenPadding,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 260,
                childAspectRatio: 1.02,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              delegate: SliverChildListDelegate(const [
                _VitalRingTile(metric: _VitalMetric.sleep),
                _VitalRingTile(metric: _VitalMetric.heartRate),
                _VitalRingTile(metric: _VitalMetric.activity),
                _LogoutTile(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _NavActionButton(
            label: 'AI Doctor Chat',
            icon: LucideIcons.sparkles,
            onTap: () => context.push('/chat'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _NavActionButton(
            label: 'Vitals Detail',
            icon: LucideIcons.activity,
            onTap: () => context.push('/vitals'),
          ),
        ),
      ],
    );
  }
}

class _NavActionButton extends StatelessWidget {
  const _NavActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: const Color(0xFF00F2FF).withOpacity(0.24)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00F2FF).withOpacity(0.16),
              blurRadius: 12,
              spreadRadius: -5,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF8AFBFF)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 132,
      toolbarHeight: 64,
      backgroundColor: Colors.black.withOpacity(0.2),
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsetsDirectional.only(start: 20, bottom: 12),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AuraHealth',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              'Your wellness command center',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.78),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            const _HeaderGlowBackground(),
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(color: Colors.black.withOpacity(0.15)),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.12),
                    Colors.transparent,
                    Colors.black.withOpacity(0.24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderGlowBackground extends StatelessWidget {
  const _HeaderGlowBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F1721), Color(0xFF0B0E11), Color(0xFF0A1118)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -40,
            top: -30,
            child: _GlowOrb(
              size: 160,
              color: const Color(0xFF00F2FF).withOpacity(0.30),
            ),
          ),
          Positioned(
            right: 18,
            top: 48,
            child: _GlowOrb(
              size: 90,
              color: const Color(0xFF6FF7FF).withOpacity(0.32),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 45, spreadRadius: 4)],
      ),
    );
  }
}

class _DailyInsightCard extends StatelessWidget {
  const _DailyInsightCard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GlassmorphicContainer(
          width: width,
          height: 188,
          borderRadius: 24,
          blur: 18,
          alignment: Alignment.bottomCenter,
          border: 1.2,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.14),
              Colors.white.withOpacity(0.04),
            ],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF00F2FF).withOpacity(0.45),
              Colors.white.withOpacity(0.08),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: RadialGradient(
                      center: Alignment.topLeft,
                      radius: 1.2,
                      colors: [
                        const Color(0xFF00F2FF).withOpacity(0.13),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00F2FF).withOpacity(0.16),
                        blurRadius: 24,
                        spreadRadius: -8,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.sparkles,
                          color: const Color(0xFF7CF9FF),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Daily AI Insight',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your sleep recovery improved by 11% after earlier wind-down.'
                      ' Keep your bedtime consistency streak tonight to unlock optimal'
                      ' heart-rate variability tomorrow.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.88),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VitalRingTile extends StatelessWidget {
  const _VitalRingTile({required this.metric});

  final _VitalMetric metric;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: metric.ringColor.withOpacity(0.25), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(metric.icon, color: metric.ringColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  metric.label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CustomPaint(
                    painter: _NeonRingPainter(
                      progress: metric.progress,
                      color: metric.ringColor,
                    ),
                    child: Center(
                      child: Text(
                        metric.reading,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutTile extends StatelessWidget {
  const _LogoutTile();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/login'),
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFFF6B81).withOpacity(0.28),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF6B81).withOpacity(0.12),
                  border: Border.all(
                    color: const Color(0xFFFF6B81).withOpacity(0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B81).withOpacity(0.35),
                      blurRadius: 16,
                      spreadRadius: -6,
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.logOut,
                  color: Color(0xFFFF9AA9),
                  size: 24,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Log Out',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NeonRingPainter extends CustomPainter {
  _NeonRingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final stroke = size.shortestSide * 0.095;
    final radius = (size.shortestSide / 2) - stroke;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = Colors.white.withOpacity(0.12);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke
      ..color = color.withOpacity(0.92)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: (math.pi * 2) - (math.pi / 2),
        colors: [color.withOpacity(0.65), color, color.withOpacity(0.8)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, trackPaint);

    final sweep = (math.pi * 2) * progress.clamp(0, 1);
    final arcRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(arcRect, -math.pi / 2, sweep, false, glowPaint);
    canvas.drawArc(arcRect, -math.pi / 2, sweep, false, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _NeonRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class _VitalMetric {
  const _VitalMetric({
    required this.label,
    required this.reading,
    required this.icon,
    required this.progress,
    required this.ringColor,
  });

  final String label;
  final String reading;
  final IconData icon;
  final double progress;
  final Color ringColor;

  static const _VitalMetric sleep = _VitalMetric(
    label: 'Sleep',
    reading: '7h 48m',
    icon: LucideIcons.moon,
    progress: 0.82,
    ringColor: Color(0xFF00F2FF),
  );

  static const _VitalMetric heartRate = _VitalMetric(
    label: 'Heart Rate',
    reading: '64 bpm',
    icon: LucideIcons.heart,
    progress: 0.66,
    ringColor: Color(0xFF39FFC6),
  );

  static const _VitalMetric activity = _VitalMetric(
    label: 'Activity',
    reading: '9.2k',
    icon: LucideIcons.activity,
    progress: 0.74,
    ringColor: Color(0xFF66E6FF),
  );
}
