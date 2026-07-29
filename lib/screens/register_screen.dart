import 'package:flutter/cupertino.dart';

import '../main.dart';
import '../services/auth_store.dart';
import '../widgets/auth_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.authStore});

  final AuthStore authStore;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (phone.isEmpty || password.isEmpty || _confirmController.text.isEmpty) {
      setState(
        () => _localError = 'Complete all fields to create your account.',
      );
      return;
    }
    if (password.length < 8) {
      setState(
        () => _localError = 'Password must contain at least 8 characters.',
      );
      return;
    }
    if (password != _confirmController.text) {
      setState(() => _localError = 'Passwords do not match.');
      return;
    }

    setState(() => _localError = null);
    final success = await widget.authStore.register(
      phone: phone,
      password: password,
    );
    if (success && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.authStore,
      builder: (context, _) {
        final error = _localError ?? widget.authStore.errorMessage;

        return AuthScaffold(
          title: 'Create your account',
          subtitle:
              'Use your Cambodian phone number. Your student ID will be assigned after you complete your profile.',
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: const Size(44, 44),
            onPressed: widget.authStore.isBusy
                ? null
                : () => Navigator.of(context).pop(),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.chevron_back, size: 22),
                SizedBox(width: 2),
                Text('Sign in'),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('PHONE NUMBER', style: _labelStyle),
              const SizedBox(height: 9),
              AppTextField(
                controller: _phoneController,
                placeholder: '012 345 678',
                icon: CupertinoIcons.phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              const Text('PASSWORD', style: _labelStyle),
              const SizedBox(height: 9),
              AppTextField(
                controller: _passwordController,
                placeholder: 'At least 8 characters',
                icon: CupertinoIcons.lock,
                obscureText: true,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              const Text('CONFIRM PASSWORD', style: _labelStyle),
              const SizedBox(height: 9),
              AppTextField(
                controller: _confirmController,
                placeholder: 'Enter password again',
                icon: CupertinoIcons.checkmark_shield,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
              if (error != null) ...[
                const SizedBox(height: 16),
                ErrorBanner(message: error),
              ],
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Create account',
                isLoading: widget.authStore.isBusy,
                onPressed: _submit,
              ),
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'By continuing, you agree to use this account according to the university student portal policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: Color(0xFF9BA2B2),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

const _labelStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.8,
  color: AppColors.secondary,
);
