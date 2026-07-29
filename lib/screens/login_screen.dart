import 'package:flutter/cupertino.dart';

import '../main.dart';
import '../services/auth_store.dart';
import '../widgets/auth_widgets.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.authStore});

  final AuthStore authStore;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_loginController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(
        () => _localError = 'Enter your phone or student ID and password.',
      );
      return;
    }

    setState(() => _localError = null);
    await widget.authStore.login(
      login: _loginController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.authStore,
      builder: (context, _) {
        final error = _localError ?? widget.authStore.errorMessage;

        return AuthScaffold(
          title: 'Welcome back',
          subtitle:
              'Sign in to continue to your student space and stay connected with USP.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('PHONE OR STUDENT ID', style: _labelStyle),
              const SizedBox(height: 9),
              AppTextField(
                controller: _loginController,
                placeholder: '012 345 678 or 0001',
                icon: CupertinoIcons.person,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              const Text('PASSWORD', style: _labelStyle),
              const SizedBox(height: 9),
              AppTextField(
                controller: _passwordController,
                placeholder: 'Enter your password',
                icon: CupertinoIcons.lock,
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
                label: 'Sign in',
                isLoading: widget.authStore.isBusy,
                onPressed: _submit,
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'New to USP?',
                    style: TextStyle(color: AppColors.secondary),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.only(left: 6),
                    minimumSize: const Size(36, 36),
                    onPressed: widget.authStore.isBusy
                        ? null
                        : () {
                            Navigator.of(context).push(
                              CupertinoPageRoute<void>(
                                builder: (_) =>
                                    RegisterScreen(authStore: widget.authStore),
                              ),
                            );
                          },
                    child: const Text(
                      'Create account',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Center(
                child: Text(
                  'University of Saint Paul · Student Portal',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9BA2B2)),
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
