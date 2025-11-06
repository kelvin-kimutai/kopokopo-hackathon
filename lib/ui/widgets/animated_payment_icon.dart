import 'dart:math';
import 'package:flutter/material.dart';

/// An animated payment icon widget that pulses and glows
class AnimatedPaymentIcon extends StatefulWidget {
  final double size;
  final Color color;

  const AnimatedPaymentIcon({
    Key? key,
    this.size = 80,
    this.color = Colors.blueAccent,
  }) : super(key: key);

  @override
  State<AnimatedPaymentIcon> createState() => _AnimatedPaymentIconState();
}

class _AnimatedPaymentIconState extends State<AnimatedPaymentIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_glowAnimation.value),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              Icons.payment,
              size: widget.size * 0.6,
              color: widget.color,
            ),
          ),
        );
      },
    );
  }
}

/// An animated success checkmark with scale and fade animation
class AnimatedSuccessCheck extends StatefulWidget {
  final double size;

  const AnimatedSuccessCheck({
    Key? key,
    this.size = 100,
  }) : super(key: key);

  @override
  State<AnimatedSuccessCheck> createState() => _AnimatedSuccessCheckState();
}

class _AnimatedSuccessCheckState extends State<AnimatedSuccessCheck>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.2),
              border: Border.all(color: Colors.green, width: 3),
            ),
            child: Icon(
              Icons.check,
              size: widget.size * 0.6,
              color: Colors.green,
            ),
          ),
        );
      },
    );
  }
}

/// A loading animation with rotating payment icons
class AnimatedLoadingPayment extends StatefulWidget {
  const AnimatedLoadingPayment({Key? key}) : super(key: key);

  @override
  State<AnimatedLoadingPayment> createState() => _AnimatedLoadingPaymentState();
}

class _AnimatedLoadingPaymentState extends State<AnimatedLoadingPayment>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildOrbitingIcon(0, Icons.credit_card),
              _buildOrbitingIcon(120, Icons.phone_android),
              _buildOrbitingIcon(240, Icons.account_balance),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrbitingIcon(double degrees, IconData icon) {
    final radians = (degrees + (_controller.value * 360)) * (pi / 180);
    final x = 40 * cos(radians);
    final y = 40 * sin(radians);

    return Transform.translate(
      offset: Offset(x, y),
      child: Icon(
        icon,
        color: Colors.blueAccent,
        size: 24,
      ),
    );
  }
}

