import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/screens/auth_gateway/auth_gateway.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // Colors (match the mock)
  static const Color kBg = Color.fromARGB(255, 236, 233, 233);
  static const Color kCard = Color(0xFFFDF6F2);
  static const Color kText = Color(0xFF1B1B1B);
  static const Color kMuted = Color(0xFF6B6B6B);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Responsive scale based on screen width (reference 390)
    final Size screen = MediaQuery.of(context).size; // width/height [7]
    final double s = (screen.width / 390).clamp(
      0.85,
      1.25,
    ); // guard extremes [1]

    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          // subtle decorative circles (scaled)
          _SoftCircle(top: 48 * s, left: 24 * s, size: 28 * s),
          _SoftCircle(top: 140 * s, left: 160 * s, size: 18 * s),
          _SoftCircle(top: 70 * s, right: 160 * s, size: 32 * s),
          _SoftCircle(top: 250 * s, right: 40 * s, size: 32 * s),
          _SoftCircle(bottom: 32 * s, right: 32 * s, size: 22 * s),
          _SoftCircle(bottom: 70 * s, left: 48 * s, size: 22 * s),

          // main content
          SafeArea(
            // respects notches and system UI [2]
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24 * s),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 24 * s),

                      // title and subtitle
                      Text(
                        'Task',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: kText,
                          fontSize: 32 * s,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1 * s,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4 * s),
                      Text(
                        'Manager',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: const Color.fromARGB(255, 59, 59, 59),
                          letterSpacing: 2.2 * s,
                          fontSize: 20 * s,
                        ),
                      ),
                      SizedBox(height: 20 * s),
                      Text(
                        'Your all task managed and\nplanned here effortlessly',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color.fromARGB(255, 59, 59, 59),
                          height: 1.4,
                          fontSize: 16 * s,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 60 * s),

                      // Get Started button (soft neumorphic)
                      _NeumorphicButton(
                        label: 'Get Started',
                        onTap: () {
                          Get.offAll(const AuthGateway());
                        },
                      ),

                      SizedBox(height: 32 * s),

                      // footer
                      Opacity(
                        opacity: 0.9,
                        child: Text(
                          'Version 1.0 • Made with ♡',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color.fromARGB(255, 41, 40, 40),
                            fontSize: 15 * s,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 24 * s),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  final double size;
  final double? top, left, right, bottom;
  const _SoftCircle({
    this.size = 24,
    this.top,
    this.left,
    this.right,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 240, 143, 143).withOpacity(0.25),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
      ),
    );
  }
}

class _NeumorphicButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NeumorphicButton({required this.label, required this.onTap});

  @override
  State<_NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<_NeumorphicButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final double s = (MediaQuery.of(context).size.width / 390).clamp(
      0.85,
      1.25,
    ); // [7]
    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(horizontal: 24 * s, vertical: 16 * s),
          decoration: BoxDecoration(
            color: SplashScreen.kCard,
            borderRadius: BorderRadius.circular(14 * s),
            boxShadow: _pressed
                ? [
                    BoxShadow(
                      color: const Color.fromARGB(255, 248, 134, 134),
                      blurRadius: 4 * s,
                      offset: Offset(0, 2 * s),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: const Color.fromARGB(255, 248, 134, 134),
                      blurRadius: 16 * s,
                      spreadRadius: 1 * s,
                      offset: Offset(0, 6 * s),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 12 * s,
                      offset: Offset(-2 * s, -2 * s),
                    ),
                  ],
          ),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: SplashScreen.kText,
              fontSize: 20 * s,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
