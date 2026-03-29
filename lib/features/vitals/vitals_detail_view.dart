// ignore_for_file: deprecated_member_use

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons/lucide_icons.dart';

class VitalsDetailView extends StatefulWidget {
  const VitalsDetailView({super.key});

  @override
  State<VitalsDetailView> createState() => _VitalsDetailViewState();
}

class _VitalsDetailViewState extends State<VitalsDetailView> {
  static const double _kPadding = 20;
  static const double _riskScore = 72;

  bool _isGenerating = false;

  final List<FlSpot> _bloodPressurePoints = const [
    FlSpot(0, 122),
    FlSpot(1, 120),
    FlSpot(2, 126),
    FlSpot(3, 118),
    FlSpot(4, 124),
    FlSpot(5, 119),
    FlSpot(6, 121),
  ];

  final List<FlSpot> _cholesterolPoints = const [
    FlSpot(0, 198),
    FlSpot(1, 194),
    FlSpot(2, 201),
    FlSpot(3, 189),
    FlSpot(4, 192),
    FlSpot(5, 186),
    FlSpot(6, 183),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E11),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/dashboard'),
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back to dashboard',
        ),
        title: const Text('Vitals Detail'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(_kPadding),
        children: [
          _VitalsTrendChart(
            bloodPressurePoints: _bloodPressurePoints,
            cholesterolPoints: _cholesterolPoints,
          ),
          const SizedBox(height: 24),
          const _RiskAssessmentGauge(score: _riskScore),
          const SizedBox(height: 28),
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generateReport,
              icon: const Icon(LucideIcons.sparkles),
              label: Text(
                _isGenerating ? 'Generating...' : 'Generate AI Report',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00F2FF),
                foregroundColor: const Color(0xFF071014),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateReport() async {
    setState(() {
      _isGenerating = true;
    });

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF11161D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Lottie.asset(
                    'assets/lottie/ai_report_loading.json',
                    repeat: true,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Generating AI report...',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
    setState(() {
      _isGenerating = false;
    });
  }
}

class _VitalsTrendChart extends StatelessWidget {
  const _VitalsTrendChart({
    required this.bloodPressurePoints,
    required this.cholesterolPoints,
  });

  final List<FlSpot> bloodPressurePoints;
  final List<FlSpot> cholesterolPoints;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vitals Trend',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Blood Pressure vs Cholesterol',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.72),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 240,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 6,
                minY: 110,
                maxY: 210,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 20,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.08),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.06),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const labels = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];
                        final index = value.toInt();
                        if (index < 0 || index > 6) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            labels[index],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.65),
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: bloodPressurePoints,
                    isCurved: true,
                    color: const Color(0xFF00F2FF),
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    shadow: const Shadow(
                      color: Color(0xFF00F2FF),
                      blurRadius: 14,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF00F2FF).withOpacity(0.25),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: cholesterolPoints,
                    isCurved: true,
                    color: const Color(0xFFFFB347),
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    shadow: const Shadow(
                      color: Color(0xFFFFB347),
                      blurRadius: 14,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFB347).withOpacity(0.24),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _LegendRow(),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: const [
        _LegendItem(color: Color(0xFF00F2FF), label: 'Blood Pressure'),
        _LegendItem(color: Color(0xFFFFB347), label: 'Cholesterol'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.7), blurRadius: 8),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.85))),
      ],
    );
  }
}

class _RiskAssessmentGauge extends StatelessWidget {
  const _RiskAssessmentGauge({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    final normalized = (score.clamp(0, 100) / 100).toDouble();
    final gaugeColor = Color.lerp(
      const Color(0xFF2EF07D),
      const Color(0xFFFF4A4A),
      normalized,
    )!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Risk Assessment',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 18,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(color: Colors.white.withOpacity(0.1)),
                  ),
                  FractionallySizedBox(
                    widthFactor: normalized,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF2EF07D),
                            Color(0xFFE2DD46),
                            Color(0xFFFF4A4A),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: gaugeColor.withOpacity(0.65),
                            blurRadius: 12,
                            spreadRadius: -3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '${score.toInt()}/100',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: gaugeColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                _labelForScore(score),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 64,
            child: CustomPaint(
              painter: _GaugeNeedlePainter(
                normalized: normalized,
                color: gaugeColor,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }

  String _labelForScore(double score) {
    if (score < 35) {
      return 'Low';
    }
    if (score < 70) {
      return 'Moderate';
    }
    return 'High';
  }
}

class _GaugeNeedlePainter extends CustomPainter {
  _GaugeNeedlePainter({required this.normalized, required this.color});

  final double normalized;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.95);
    final radius = math.min(size.width / 2, size.height) - 4;
    final start = math.pi;
    final sweep = math.pi;

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = Colors.white.withOpacity(0.14);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      arcPaint,
    );

    final angle = math.pi + (math.pi * normalized);
    final needleLength = radius - 4;
    final end = Offset(
      center.dx + needleLength * math.cos(angle),
      center.dy + needleLength * math.sin(angle),
    );

    final needlePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawLine(center, end, needlePaint);
    canvas.drawCircle(center, 5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _GaugeNeedlePainter oldDelegate) {
    return oldDelegate.normalized != normalized || oldDelegate.color != color;
  }
}
