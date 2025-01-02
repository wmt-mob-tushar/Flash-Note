import 'dart:math' as math;
import 'package:flash_note/resources/res_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedCircularButton extends StatefulWidget {
  final VoidCallback onTap;
  final double size;
  final int currentPage;
  final int totalPages;

  AnimatedCircularButton({
    Key? key,
    required this.onTap,
    required this.currentPage,
    required this.totalPages,
    this.size = 48.0,
  }) : super(key: key);

  @override
  State<AnimatedCircularButton> createState() => _AnimatedCircularButtonState();
}

class _AnimatedCircularButtonState extends State<AnimatedCircularButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  int _lastPage = 0;

  @override
  void initState() {
    super.initState();
    _lastPage = widget.currentPage;
    _setupAnimation();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _updateProgress();
    _controller.forward();
  }

  void _updateProgress() {
    final newProgress = (widget.currentPage + 1) / widget.totalPages;
    final oldProgress = (_lastPage + 1) / widget.totalPages;

    _progressAnimation = Tween<double>(
      begin: oldProgress,
      end: newProgress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AnimatedCircularButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPage != widget.currentPage) {
      _lastPage = oldWidget.currentPage;
      _controller.reset();
      _updateProgress();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration:const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: Stack(
          children: [
            // Progress circle
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: CircularProgressPainter(
                    progress: _progressAnimation.value,
                    isReversed: widget.currentPage < _lastPage,
                  ),
                );
              },
            ),
            // Center yellow circle with arrow
            Padding(
              padding: EdgeInsets.all(widget.size * 0.15),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ResColors.white,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                    size: widget.size * 0.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final bool isReversed;

  CircularProgressPainter({
    required this.progress,
    this.isReversed = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ResColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (paint.strokeWidth / 2);

    // Draw background circle with reduced opacity
    canvas.drawCircle(
      center,
      radius,
      paint..color = ResColors.white.withAlpha(100),
    );

    // Draw progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Always draw from top (-pi/2) with the current progress
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint..color = ResColors.white,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}