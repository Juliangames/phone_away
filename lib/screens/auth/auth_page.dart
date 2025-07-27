import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_away/theme/theme.dart';
import 'auth_constants.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/db_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthService _authService = AuthService();
  final DBService _dbService = DBService();
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
        final userCredential = await _authService.register(
          email: _email.trim(),
          password: _password.trim(),
        );
        if (userCredential != null) {
          await _dbService.createDefaultUser(userCredential.uid);
        } else {
          throw Exception(AuthConstants.registrationFailureMessage);
        }
      }
      // On success, Firebase automatically keeps user logged in
      // You can navigate away or rebuild based on auth state
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _error = AppStrings.unknownErrorMessage;
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
            top: AuthConstants.circle1Top,
            left: AuthConstants.circle1Left,
            child: _buildCircle(
              AuthConstants.circle1Size,
              AppColors.primaryColor.withOpacity(AuthConstants.circle1Opacity),
            ),
          ),
          Positioned(
            top: AuthConstants.circle2Top,
            right: AuthConstants.circle2Right,
            child: _buildCircle(
              AuthConstants.circle2Size,
              AppColors.primaryContainerColor.withOpacity(
                AuthConstants.circle2Opacity,
              ),
            ),
          ),
          Positioned(
            top: AuthConstants.circle3Top,
            left: AuthConstants.circle3Left,
            child: _buildCircle(
              AuthConstants.circle3Size,
              AppColors.primaryColor.withOpacity(AuthConstants.circle3Opacity),
            ),
          ),
          Positioned(
            top: AuthConstants.circle4Top,
            left: AuthConstants.circle4Left,
            child: _buildCircle(
              AuthConstants.circle4Size,
              AppColors.secondaryContainerColor.withOpacity(
                AuthConstants.circle4Opacity,
              ),
            ),
          ),
          Positioned(
            top: AuthConstants.circle5Top,
            right: AuthConstants.circle5Right,
            child: _buildCircle(
              AuthConstants.circle5Size,
              AppColors.primaryColor.withOpacity(AuthConstants.circle5Opacity),
            ),
          ),
          Positioned(
            top: AuthConstants.circle6Top,
            left:
                MediaQuery.of(context).size.width / 2 -
                AuthConstants.circle6CenterOffset,
            child: _buildCircle(
              AuthConstants.circle6Size,
              AppColors.primaryColor.withOpacity(AuthConstants.circle6Opacity),
            ),
          ),

          // Main content
          Column(
            children: [
              // Big centered title
              Expanded(
                flex: AppValues.titleFlexValue,
                child: Center(
                  child: Text(
                    AuthConstants.appTitle,
                    style: const TextStyle(
                      fontSize: AppTypography.titleFontSize,
                      fontWeight: AppTypography.titleFontWeight,
                      color: AppColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Form fields
              Expanded(
                flex: AppValues.formFlexValue,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.largeSpacing,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          key: const ValueKey(AppStrings.emailFieldKey),
                          decoration: InputDecoration(
                            labelText: AuthConstants.emailLabel,
                            labelStyle: const TextStyle(
                              color: AppColors.onSurfaceVariantColor,
                            ),
                            filled: true,
                            fillColor: AppColors.primaryContainerColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadius,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return AuthConstants.emailValidationError;
                            }
                            return null;
                          },
                          onSaved: (value) => _email = value ?? '',
                        ),
                        const SizedBox(height: AppDimensions.textFieldSpacing),
                        TextFormField(
                          key: const ValueKey(AppStrings.passwordFieldKey),
                          decoration: InputDecoration(
                            labelText: AuthConstants.passwordLabel,
                            labelStyle: const TextStyle(
                              color: AppColors.onSurfaceVariantColor,
                            ),
                            filled: true,
                            fillColor: AppColors.primaryContainerColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadius,
                              ),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                value.length <
                                    AppValues.minimumPasswordLength) {
                              return AuthConstants.passwordValidationError;
                            }
                            return null;
                          },
                          onSaved: (value) => _password = value ?? '',
                        ),
                        const SizedBox(height: AppDimensions.largeSpacing),
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
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadius,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimensions.buttonVerticalPadding,
                              ),
                            ),
                            child: Text(
                              _isLogin
                                  ? AuthConstants.loginButtonText
                                  : AuthConstants.registerButtonText,
                              style: const TextStyle(
                                fontSize: AppTypography.buttonFontSize,
                              ),
                            ),
                          ),
                        const SizedBox(height: AppDimensions.smallSpacing),
                        TextButton(
                          onPressed: () => setState(() => _isLogin = !_isLogin),
                          child: Text(
                            _isLogin
                                ? AuthConstants.noAccountText
                                : AuthConstants.haveAccountText,
                            style: const TextStyle(
                              fontSize: AppTypography.bodyFontSize,
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
