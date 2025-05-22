import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phone_away/theme/theme.dart';
import '../services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true; // toggle between login/register
  bool _loading = false;
  String _email = '';
  String _password = '';
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    _formKey.currentState!.save();

    try {
      if (_isLogin) {
        await _authService.signIn(
          email: _email.trim(),
          password: _password.trim(),
        );
      } else {
        await _authService.register(
          email: _email.trim(),
          password: _password.trim(),
        );
      }
      // On success, Firebase automatically keeps user logged in
      // You can navigate away or rebuild based on auth state
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _error = "An unknown error occurred.";
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      body: Stack(
        children: [
          // Background decorative circles
          Positioned(
            top: -60,
            left: -40,
            child: _buildCircle(120, AppColors.primaryColor.withOpacity(0.8)),
          ),
          Positioned(
            top: -40,
            right: -50,
            child: _buildCircle(
              250,
              AppColors.primaryContainerColor.withOpacity(1),
            ),
          ),
          Positioned(
            top: -200,
            left: 75,
            child: _buildCircle(340, AppColors.primaryColor.withOpacity(0.8)),
          ),
          Positioned(
            top: 100,
            left: -70,
            child: _buildCircle(
              90,
              AppColors.secondaryContainerColor.withOpacity(0.35),
            ),
          ),
          Positioned(
            top: 160,
            right: -60,
            child: _buildCircle(70, AppColors.primaryColor.withOpacity(0.25)),
          ),
          Positioned(
            top: 60,
            left: MediaQuery.of(context).size.width / 2 - 150,
            child: _buildCircle(100, AppColors.primaryColor.withOpacity(0.25)),
          ),

          // Main content
          Column(
            children: [
              // Big centered title
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    'PhoneAway',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Form fields
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          key: const ValueKey('email'),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(
                              color: AppColors.onSurfaceVariantColor,
                            ),
                            filled: true,
                            fillColor: AppColors.primaryContainerColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (value) => _email = value ?? '',
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const ValueKey('password'),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              color: AppColors.onSurfaceVariantColor,
                            ),
                            filled: true,
                            fillColor: AppColors.primaryContainerColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onSaved: (value) => _password = value ?? '',
                        ),
                        const SizedBox(height: 24),
                        if (_error != null)
                          Text(
                            _error!,
                            style: const TextStyle(color: AppColors.errorColor),
                            textAlign: TextAlign.center,
                          ),
                        if (_loading)
                          const Center(child: CircularProgressIndicator())
                        else
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: AppColors.onPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              _isLogin ? 'Login' : 'Register',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => setState(() => _isLogin = !_isLogin),
                          child: Text(
                            _isLogin
                                ? 'Don’t have an account? Register'
                                : 'Already have an account? Login',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper to build decorative circle
  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
