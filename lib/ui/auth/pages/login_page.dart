import 'package:cric_spot/bloc/auth/auth_cubit.dart';
import 'package:cric_spot/bloc/auth/auth_state.dart';
import 'package:cric_spot/config/routes_name.dart';
import 'package:cric_spot/core/extensions/color_extension.dart';
import 'package:cric_spot/core/extensions/text_style_extensions.dart';
import 'package:cric_spot/core/widgtes/cric_widgets/cric_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            GoRouter.of(context).go(RoutesName.landing.path);
          } else if (state.status == AuthStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Icon(
                  Icons.sports_cricket,
                  size: 80,
                  color: context.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome to Cric Spot',
                  style: context.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to share live scores and track stats',
                  style: context.bodyMedium?.copyWith(color: context.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CricTextFormField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email is required';
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CricTextFormField(
                  controller: _passwordController,
                  hintText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password is required';
                    if (value.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return FilledButton(
                      onPressed: state.status == AuthStatus.loading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().signInWithEmail(
                                      _emailController.text.trim(),
                                      _passwordController.text,
                                    );
                              }
                            },
                      child: state.status == AuthStatus.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign In'),
                    );
                  },
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    context.read<AuthCubit>().signInWithGoogle();
                  },
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text('Sign in with Google'),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).push(RoutesName.signup.path);
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
