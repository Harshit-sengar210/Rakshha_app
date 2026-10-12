import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import '../providers/registration_provider.dart';
import 'widgets/rakshaa_brand_header.dart';
import 'widgets/registration_progress.dart';
import 'widgets/auth_input_field.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;

  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _gender = 'Female';

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Pre-fill if going back
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(registrationProvider);
      if (state.fullName.isNotEmpty) _nameController.text = state.fullName;
      if (state.age.isNotEmpty) _ageController.text = state.age;
      if (state.address.isNotEmpty) _addressController.text = state.address;
      if (state.mobileNumber.isNotEmpty) _mobileController.text = state.mobileNumber;
      if (state.email.isNotEmpty) _emailController.text = state.email;
      if (state.password.isNotEmpty) {
        _passwordController.text = state.password;
        _confirmPasswordController.text = state.password;
      }
      if (state.gender.isNotEmpty) {
        setState(() {
          _gender = state.gender;
        });
      }
      _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isSendingOtp = false;

  void _handleContinue() async {
    if (_formKey.currentState!.validate()) {
      if (_emailController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email is required for account creation"), backgroundColor: Colors.red),
        );
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match"), backgroundColor: Colors.red),
        );
        return;
      }

      setState(() => _isSendingOtp = true);

      ref.read(registrationProvider.notifier).updatePersonalInfo(
        fullName: _nameController.text.trim(),
        age: _ageController.text.trim(),
        gender: _gender,
        address: _addressController.text.trim(),
        mobileNumber: _mobileController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      try {
        await ref.read(registrationProvider.notifier).sendWhatsAppOtp();
      } catch (e) {
        debugPrint("OTP Send Error: $e");
      }

      setState(() => _isSendingOtp = false);
      if (mounted) _showOtpBottomSheet();
    }
  }

  void _showOtpBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OtpBottomSheet(mobileNumber: _mobileController.text.trim()),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: const Color(0xFFE9EAF0)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFC),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            physics: const BouncingScrollPhysics(),
            child: FadeTransition(
              opacity: _entranceController,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(
                  CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RakshaaBrandHeader(entranceController: _entranceController),
                    const SizedBox(height: 24),
                    const RegistrationProgress(currentStep: 1),
                    const SizedBox(height: 24),
                    
                    const Text(
                      "Create Your Account",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepNavy,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Let's get you started with a safer, more connected Rakshaa experience.",
                      style: TextStyle(fontSize: 14, color: Color(0xFF71809A)),
                    ),
                    
                    _buildSectionTitle("Personal Details"),
                    AuthInputField(
                      hintText: "Enter your full name",
                      prefixIcon: Icons.person_outline,
                      onChanged: (v) => _nameController.text = v,
                      errorText: _nameController.text.isEmpty ? null : null, // Handle via form validation visually ideally
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AuthInputField(
                            hintText: "Age",
                            prefixIcon: Icons.calendar_today_outlined,
                            keyboardType: TextInputType.number,
                            onChanged: (v) => _ageController.text = v,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 54,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE9EAF0)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _gender,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF8A98B0)),
                                items: ['Female', 'Male', 'Other', 'Prefer not to say'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.deepNavy)),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _gender = val);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    _buildSectionTitle("Contact Details"),
                    AuthInputField(
                      hintText: "Mobile Number",
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      onChanged: (v) {
                        // Ensure we format it for Indian numbers as requested
                        _mobileController.text = v.startsWith('+91') ? v : '+91 $v';
                      },
                    ),
                    const SizedBox(height: 16),
                    AuthInputField(
                      hintText: "Email Address",
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (v) => _emailController.text = v,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Used for account recovery and important updates.",
                      style: TextStyle(fontSize: 11, color: Color(0xFF8A98B0)),
                    ),

                    _buildSectionTitle("Address"),
                    AuthInputField(
                      hintText: "House / Flat / Building, Area, City...",
                      prefixIcon: Icons.location_on_outlined,
                      onChanged: (v) => _addressController.text = v,
                    ),

                    _buildSectionTitle("Security"),
                    AuthInputField(
                      hintText: "Create Password",
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      onChanged: (v) {
                        _passwordController.text = v;
                        setState(() {});
                      },
                    ),
                    // Password strength indicator
                    if (_passwordController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4, bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              _passwordController.text.length < 6 ? "Weak" : _passwordController.text.length < 9 ? "Medium" : "Strong",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _passwordController.text.length < 6 ? Colors.orange : AppColors.softGreen,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 4,
                                decoration: BoxDecoration(
                                  color: _passwordController.text.length < 6 ? Colors.orange : AppColors.softGreen,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                      ),

                    const SizedBox(height: 16),
                    AuthInputField(
                      hintText: "Confirm Password",
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      onChanged: (v) {
                        _confirmPasswordController.text = v;
                        setState(() {});
                      },
                    ),
                    if (_confirmPasswordController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Text(
                          _passwordController.text == _confirmPasswordController.text ? "Passwords match ✓" : "Passwords do not match",
                          style: TextStyle(
                            fontSize: 11,
                            color: _passwordController.text == _confirmPasswordController.text ? AppColors.softGreen : Colors.red,
                          ),
                        ),
                      ),

                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _isSendingOtp ? null : _handleContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.rakshaaCoral,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 0,
                      ),
                      child: _isSendingOtp 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text("Continue →", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OtpBottomSheet extends ConsumerStatefulWidget {
  final String mobileNumber;
  const _OtpBottomSheet({required this.mobileNumber});

  @override
  ConsumerState<_OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends ConsumerState<_OtpBottomSheet> {
  final _otpController = TextEditingController();
  bool _isVerifying = false;

  void _verify() {
    setState(() => _isVerifying = true);
    final expected = ref.read(registrationProvider).generatedOtp;
    
    if (_otpController.text == expected) {
      // Success! Proceed to priority contact page
      Navigator.pop(context);
      context.push('/priority_contact');
    } else {
      setState(() => _isVerifying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP code"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24, 
        right: 24, 
        top: 32, 
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Verify WhatsApp Number",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
          ),
          const SizedBox(height: 8),
          Text(
            "We've sent a 6-digit code to ${widget.mobileNumber} on WhatsApp.",
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: "",
              hintText: "------",
              filled: true,
              fillColor: AppColors.surfaceSubtle,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isVerifying ? null : _verify,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rakshaaCoral,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            child: _isVerifying 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text("Verify & Continue", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
