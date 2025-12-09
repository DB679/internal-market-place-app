import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'main_navigation.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  final _passwordPattern = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]).{8,}$',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

void _submit() {
  if (_formKey.currentState?.validate() ?? false) {
    // instead of just showing a SnackBar, navigate to main navigation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigation(initialIndex: 0), // Home tab
      ),
    );
  }
}


  void _onForgotPassword() {
    // TODO: navigate to Forgot Password page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Forgot password clicked (TODO: implement flow)'),
      ),
    );
  }

  void _goToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;

          final form = Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter your details to access your company marketplace.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),

                      // Email
                      const Text('Email', style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter your work email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password
                      const Text('Password', style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (!_passwordPattern.hasMatch(value)) {
                            return 'Password must be 8+ chars,\ninclude upper, lower, number & symbol.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Password must be at least 8 characters and include:\n• 1 uppercase • 1 lowercase • 1 number • 1 special character',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),

                      // Remember me & forgot password
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                          const Text('Remember me'),
                          const Spacer(),
                          TextButton(
                            onPressed: _onForgotPassword,
                            child: const Text('Forgot your password?'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: const Color(0xFF4C6FFF),
                          ),
                          child: const Text(
                            'Log in',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Or divider (optional)
                      Row(
                        children: const [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'or',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Placeholder for SSO button
                     SizedBox(
                       width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Microsoft SSO (TODO: integrate Azure AD)'),
                          ),
                        );
                      },
    icon: const Icon(Icons.window), // or Icons.account_circle as placeholder
    label: const Text('Sign in with Microsoft'),
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
),

                      const SizedBox(height: 16),

                      // Signup link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don’t have an account?",
                            style: TextStyle(fontSize: 13),
                          ),
                          TextButton(
                            onPressed: _goToSignup,
                            child: const Text(
                              'Sign up',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

          final rightPanel = isWide
              ? Expanded(
                  child: Container(
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4C6FFF), Color(0xFF8F5BFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Simple geometric decoration to mimic your reference
                        Positioned(
                          top: 40,
                          left: 40,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 80,
                          right: 40,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.12),
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Company\nMarketplace',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink();

          if (isWide) {
            return Row(
              children: [
                Expanded(child: form),
                rightPanel,
              ],
            );
          } else {
            // Mobile: stack vertically
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  form,
                  Container(
                    height: 200,
                    margin: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4C6FFF), Color(0xFF8F5BFF)],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: const Center(
                      child: Text(
                        'Company Marketplace',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
