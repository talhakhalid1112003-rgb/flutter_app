import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scoring_app/features/auth/providers/auth_provider.dart';
import 'package:scoring_app/features/auth/widgets/custom_button.dart';
import 'package:scoring_app/features/auth/widgets/custom_text_field.dart';
import 'package:scoring_app/features/auth/widgets/loading_widget.dart';
import 'package:scoring_app/features/auth/widgets/google_sign_in_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscure = true;
  bool _confirmObscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passCtrl.text != _confirmPassCtrl.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    final auth = ref.read(authControllerProvider.notifier);
    try {
      await auth.signUp(
        _nameCtrl.text.trim(),
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully')),
        );
        context.go('/sport-selection');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Signup failed: $e')));
      }
    }
  }

  Future<void> _googleSignUp() async {
    final auth = ref.read(authControllerProvider.notifier);
    try {
      await auth.signInWithGoogle();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-up successful')),
        );
        context.go('/sport-selection');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Google sign-up failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Join Easy Sport Scorer',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create an account to get started',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  Card(
                    color: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              label: 'Name',
                              controller: _nameCtrl,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'Please enter your name';
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Email',
                              controller: _emailCtrl,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'Please enter email';
                                if (!RegExp(
                                  r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}",
                                ).hasMatch(v.trim()))
                                  return 'Invalid email';
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Password',
                              controller: _passCtrl,
                              obscureText: _obscure,
                              suffix: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Please enter password';
                                if (v.length < 6)
                                  return 'Password must be at least 6 characters';
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Confirm Password',
                              controller: _confirmPassCtrl,
                              obscureText: _confirmObscure,
                              suffix: IconButton(
                                icon: Icon(
                                  _confirmObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () => setState(
                                  () => _confirmObscure = !_confirmObscure,
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Please confirm password';
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            if (authState.isLoading)
                              const LoadingWidget(text: 'Creating account...')
                            else
                              CustomButton(
                                label: 'Create Account',
                                onPressed: _signup,
                              ),
                            const SizedBox(height: 16),
                            // Divider with text
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(color: Colors.grey.shade600),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    'OR',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GoogleSignInButton(
                              isLoading: authState.isLoading,
                              onPressed: _googleSignUp,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account? '),
                                TextButton(
                                  onPressed: () => context.pop(),
                                  child: const Text('Login here'),
                                ),
                              ],
                            ),
                          ],
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
    );
  }
}
