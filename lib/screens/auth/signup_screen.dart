import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/responsive_center.dart';

/// Screen 2: Sign Up. UI only in Step 2, no real account is created.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  void _createAccount() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: ResponsiveCenter(
            maxWidth: 420,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Create your SUPazar account',
                    style: AppTextStyles.title,
                  ),
                  const Text(
                    'Buyers will see your name and contact info on your listings.',
                    style: AppTextStyles.caption,
                  ),
                  AppSpacing.gapLg,
                  AppTextField(
                    label: 'Full name',
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.person_outline,
                    validator: (v) => Validators.required(v, 'Full name'),
                  ),
                  AppTextField(
                    label: 'Email',
                    hint: 'name@sabanciuniv.edu',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.email,
                  ),
                  AppTextField(
                    label: 'Phone (optional)',
                    hint: '05xx xxx xx xx',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.phone_outlined,
                    validator: Validators.optionalPhone,
                  ),
                  AppTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.lock_outline,
                    validator: Validators.password,
                  ),
                  AppTextField(
                    label: 'Confirm password',
                    controller: _confirmController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.lock_outline,
                    validator: _validateConfirm,
                  ),
                  AppSpacing.gapSm,
                  FilledButton(
                    onPressed: _createAccount,
                    child: const Text('Create account'),
                  ),
                  AppSpacing.gapSm,
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: AppTextStyles.body,
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Log in', style: AppTextStyles.link),
                      ),
                    ],
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
