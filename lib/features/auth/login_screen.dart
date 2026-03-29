// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E11),
      body: Stack(
        children: [
          const _LoginBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white.withOpacity(0.08),
                          border: Border.all(
                            color: const Color(0xFF00F2FF).withOpacity(0.28),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Icon(
                              LucideIcons.heartPulse,
                              size: 44,
                              color: const Color(0xFF86FBFF),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Welcome to AuraHealth',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign in to continue to your dashboard',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.78),
                                  ),
                            ),
                            const SizedBox(height: 24),
                            _GlassInput(
                              hintText: 'Email',
                              icon: LucideIcons.mail,
                            ),
                            const SizedBox(height: 12),
                            _GlassInput(
                              hintText: 'Password',
                              icon: LucideIcons.lock,
                              obscureText: true,
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: () => context.go('/dashboard'),
                                icon: const Icon(LucideIcons.logIn),
                                label: const Text('Login'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00F2FF),
                                  foregroundColor: const Color(0xFF071014),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

class _GlassInput extends StatelessWidget {
  const _GlassInput({
    required this.hintText,
    required this.icon,
    this.obscureText = false,
  });

  final String hintText;
  final IconData icon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.62)),
        prefixIcon: Icon(icon, color: const Color(0xFF7CF9FF), size: 18),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: const Color(0xFF00F2FF).withOpacity(0.22),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: const Color(0xFF00F2FF).withOpacity(0.22),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF00F2FF)),
        ),
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F1721), Color(0xFF0B0E11), Color(0xFF08131B)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -40,
            top: -30,
            child: _GlowOrb(
              size: 180,
              color: const Color(0xFF00F2FF).withOpacity(0.28),
            ),
          ),
          Positioned(
            right: -20,
            bottom: 80,
            child: _GlowOrb(
              size: 140,
              color: const Color(0xFF4FF4FF).withOpacity(0.22),
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
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 48, spreadRadius: 2)],
      ),
    );
  }
}
