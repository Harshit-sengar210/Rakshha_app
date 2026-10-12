import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'package:rakshaa/features/auth/providers/registration_provider.dart';

import 'widgets/rakshaa_brand_header.dart';
import 'widgets/login_illustration.dart';
import 'widgets/login_method_selector.dart';
import 'widgets/auth_input_field.dart';
import 'widgets/remember_forgot_row.dart';
import 'widgets/login_button.dart';
import 'widgets/social_login_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _welcomeTitleOpacity;
  late Animation<double> _welcomeTitleTranslate;
  late Animation<double> _welcomeSubtitleOpacity;
  late Animation<double> _welcomeSubtitleTranslate;

  late Animation<double> _cardOpacity;
  late Animation<double> _cardTranslate;

  late Animation<double> _methodSelectorOpacity;
  late Animation<double> _inputsOpacity;
  late Animation<double> _buttonOpacity;
  late Animation<double> _footerOpacity;

  LoginMethod _selectedMethod = LoginMethod.phone;
  bool _rememberMe = true;
  bool _isLoading = false;

  String? _phoneError;
  String? _emailError;
  String? _passwordError;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Welcome Section Animations
    _welcomeTitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.25, 0.55, curve: Curves.easeOut)),
    );
    _welcomeTitleTranslate = Tween<double>(begin: 14.0, end: 0.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.25, 0.55, curve: Curves.easeOut)),
    );
    
    _welcomeSubtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.32, 0.60, curve: Curves.easeOut)),
    );
    _welcomeSubtitleTranslate = Tween<double>(begin: 8.0, end: 0.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.32, 0.60, curve: Curves.easeOut)),
    );

    // Card Animation
    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.64, 0.85, curve: Curves.easeOutCubic)),
    );
    _cardTranslate = Tween<double>(begin: 25.0, end: 0.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.64, 0.85, curve: Curves.easeOutCubic)),
    );

    // Inner Card Elements
    _methodSelectorOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.75, 0.90, curve: Curves.easeIn)),
    );
    _inputsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.82, 0.95, curve: Curves.easeIn)),
    );
    _buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.89, 1.0, curve: Curves.easeIn)),
    );
    _footerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.95, 1.0, curve: Curves.easeIn)),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _phoneError = null;
      _emailError = null;
      _passwordError = null;
    });

    bool isValid = true;

    if (_selectedMethod == LoginMethod.phone) {
      if (_phoneController.text.trim().isEmpty) {
        _phoneError = "Phone number is required";
        isValid = false;
      } else if (_phoneController.text.length < 10) {
        _phoneError = "Enter a valid phone number";
        isValid = false;
      }
    } else {
      if (_emailController.text.trim().isEmpty) {
        _emailError = "Email is required";
        isValid = false;
      } else if (!_emailController.text.contains('@')) {
        _emailError = "Enter a valid email address";
        isValid = false;
      }
    }

    if (_passwordController.text.length < 6) {
      _passwordError = "Password must be at least 6 characters";
      isValid = false;
    }

    if (isValid) {
      setState(() { _isLoading = true; });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (mounted) context.go('/home');
      } on FirebaseAuthException catch (e) {
        setState(() { _isLoading = false; });
        String message = "Login failed. Please check your credentials.";
        if (e.code == 'user-not-found') message = "No account found with this email.";
        if (e.code == 'wrong-password') message = "Incorrect password.";
        if (e.code == 'invalid-credential') message = "Invalid email or password.";
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red.shade400),
          );
        }
      } catch (e) {
        setState(() { _isLoading = false; });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red.shade400),
          );
        }
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    
    try {
      UserCredential userCredential;
      
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        userCredential = await FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        
        if (googleUser == null) {
          setState(() => _isLoading = false);
          return; // User canceled the sign-in flow
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      }
      
      if (!mounted) return;
      
      setState(() => _isLoading = false);
      
      // If it's a new user, pre-fill some info and go to signup flow
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        final user = userCredential.user;
        if (user != null) {
          ref.read(registrationProvider.notifier).updatePersonalInfo(
            fullName: user.displayName ?? "",
            mobileNumber: user.phoneNumber ?? "", // Usually null from Google
          );
          // Assuming email is added in personal info or we just want them to start the flow
        }
        context.go('/signup');
      } else {
        // Existing user, go to home
        context.go('/home');
      }
      
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Google Sign-In failed: ${e.toString().split(']').last}", style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _showForgotSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Password recovery will be available soon.", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.deepNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RakshaaBrandHeader(entranceController: _entranceController),
                      
                      const SizedBox(height: 32),
                      

                      
                      LoginIllustration(entranceController: _entranceController),
                      
                      const SizedBox(height: 20),
                      
                      // Login Card
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _entranceController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _cardOpacity.value,
                              child: Transform.translate(
                                offset: Offset(0, _cardTranslate.value),
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.deepNavy.withOpacity(0.04),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Opacity(
                                        opacity: _methodSelectorOpacity.value,
                                        child: LoginMethodSelector(
                                          selectedMethod: _selectedMethod,
                                          onMethodChanged: (method) {
                                            setState(() {
                                              _selectedMethod = method;
                                              _phoneError = null;
                                              _emailError = null;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      
                                      Opacity(
                                        opacity: _inputsOpacity.value,
                                        child: AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 300),
                                          child: _selectedMethod == LoginMethod.phone
                                              ? AuthInputField(
                                                  key: const ValueKey('phone'),
                                                  hintText: "+91 98765 43210",
                                                  prefixIcon: Icons.phone_outlined,
                                                  keyboardType: TextInputType.phone,
                                                  errorText: _phoneError,
                                                  onChanged: (v) {
                                                    _phoneController.text = v;
                                                    if (_phoneError != null) setState(() => _phoneError = null);
                                                  },
                                                )
                                              : AuthInputField(
                                                  key: const ValueKey('email'),
                                                  hintText: "Enter your email address",
                                                  prefixIcon: Icons.email_outlined,
                                                  keyboardType: TextInputType.emailAddress,
                                                  errorText: _emailError,
                                                  onChanged: (v) {
                                                    _emailController.text = v;
                                                    if (_emailError != null) setState(() => _emailError = null);
                                                  },
                                                ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      
                                      Opacity(
                                        opacity: _inputsOpacity.value,
                                        child: AuthInputField(
                                          hintText: "Password",
                                          prefixIcon: Icons.lock_outline,
                                          isPassword: true,
                                          errorText: _passwordError,
                                          onChanged: (v) {
                                            _passwordController.text = v;
                                            if (_passwordError != null) setState(() => _passwordError = null);
                                          },
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 16),
                                      
                                      Opacity(
                                        opacity: _inputsOpacity.value,
                                        child: RememberForgotRow(
                                          rememberMe: _rememberMe,
                                          onRememberChanged: (val) {
                                            setState(() {
                                              _rememberMe = val;
                                            });
                                          },
                                          onForgotPressed: _showForgotSnackbar,
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 24),
                                      
                                      Opacity(
                                        opacity: _buttonOpacity.value,
                                        child: LoginButton(
                                          onPressed: _handleLogin,
                                          isLoading: _isLoading,
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 24),
                                      
                                      Opacity(
                                        opacity: _footerOpacity.value,
                                        child: Row(
                                          children: [
                                            Expanded(child: Divider(color: const Color(0xFFE9EAF0), thickness: 1)),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 16),
                                              child: Text(
                                                "OR",
                                                style: TextStyle(
                                                  color: Color(0xFF8A98B0),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Expanded(child: Divider(color: const Color(0xFFE9EAF0), thickness: 1)),
                                          ],
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 24),
                                      
                                      Opacity(
                                        opacity: _footerOpacity.value,
                                        child: SocialLoginButton(
                                          onPressed: _handleGoogleSignIn,
                                        ),
                                      ),
                                      
                                      const Spacer(),
                                      const SizedBox(height: 16),
                                      
                                      Opacity(
                                        opacity: _footerOpacity.value,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Don't have an account? ",
                                              style: TextStyle(
                                                color: Color(0xFF8A98B0),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                context.go('/signup');
                                              },
                                              child: const Text(
                                                "Sign Up",
                                                style: TextStyle(
                                                  color: AppColors.rakshaaCoral,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
