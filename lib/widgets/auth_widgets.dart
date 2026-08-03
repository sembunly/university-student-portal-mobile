import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../theme/app_colors.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.leading,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      child: Stack(
        children: [
          const Positioned(
            top: -110,
            right: -80,
            child: _Glow(size: 300, color: Color(0x335FD4E8)),
          ),
          const Positioned(
            top: 100,
            left: -130,
            child: _Glow(size: 280, color: Color(0x222457D6)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.sizeOf(context).height - 88,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 44,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: leading ?? const UspMark(),
                      ),
                    ),
                    const SizedBox(height: 54),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 34,
                        height: 1.08,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1.2,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.45,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 36),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UspMark extends StatelessWidget {
  const UspMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.cyan, AppColors.blue],
            ),
            borderRadius: BorderRadius.circular(13),
            boxShadow: const [
              BoxShadow(
                color: Color(0x332457D6),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            CupertinoIcons.book_fill,
            color: CupertinoColors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 11),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'USP',
              style: TextStyle(
                fontSize: 18,
                height: 1,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'STUDENT',
              style: TextStyle(
                fontSize: 9,
                height: 1,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.6,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String placeholder;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: widget.controller,
      placeholder: widget.placeholder,
      prefix: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Icon(widget.icon, size: 20, color: AppColors.secondary),
      ),
      suffix: widget.obscureText
          ? CupertinoButton(
              minimumSize: const Size(44, 44),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              onPressed: () => setState(() => _obscure = !_obscure),
              child: Icon(
                _obscure ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                size: 20,
                color: AppColors.secondary,
              ),
            )
          : null,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      autocorrect: false,
      enableSuggestions: !widget.obscureText,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
      style: const TextStyle(fontSize: 16, color: AppColors.ink),
      placeholderStyle: const TextStyle(fontSize: 16, color: Color(0xFF9BA2B2)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F1D3A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(17),
        color: AppColors.blue,
        disabledColor: const Color(0xFF9BB0E6),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CupertinoActivityIndicator(color: CupertinoColors.white)
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: CupertinoColors.white,
                ),
              ),
      ),
    );
  }
}

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEF1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFCED7)),
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.exclamationmark_circle_fill,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 14,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
