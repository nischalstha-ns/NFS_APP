import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedRing extends StatefulWidget {
  final Widget child;

  const AnimatedRing({super.key, required this.child});

  @override
  State<AnimatedRing> createState() => _AnimatedRingState();
}

class _AnimatedRingState extends State<AnimatedRing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF000000)],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: RotationTransition(
              turns: _controller,
              child: SizedBox(
                width: 384,
                height: 384,
                child: Stack(
                  children: List.generate(12, (i) {
                    final angle = i * 30.0 * pi / 180;
                    final isCyan = i % 2 == 0;
                    return Positioned(
                      left: 192 - 8,
                      top: 192 - 8,
                      child: Transform.rotate(
                        angle: angle,
                        child: Transform.translate(
                          offset: const Offset(0, -192),
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: isCyan
                                    ? [const Color(0xFF00BCD4), const Color(0xFF0097A7)]
                                    : [const Color(0xFF2196F3), const Color(0xFF1976D2)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isCyan ? const Color(0xFF00BCD4) : const Color(0xFF2196F3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}
