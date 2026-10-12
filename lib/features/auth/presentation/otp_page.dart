import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import '../providers/registration_provider.dart';
import 'widgets/rakshaa_brand_header.dart';
import 'widgets/registration_progress.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key});

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _successController;

  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _timerSeconds = 45;
  Timer? _timer;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _successController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    
    _entranceController.forward();
    _startTimer();
  }

  void _startTimer() {
    setState(() => _timerSeconds = 45);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => _timerSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _successController.dispose();
    _timer?.cancel();
    for (var c in _controllers) { c.dispose(); }
    for (var f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  void _handleChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isNotEmpty && index == 5) {
      _focusNodes[index].unfocus();
      _verifyOtp();
    }
    setState(() {}); // trigger scale animation
  }

  void _verifyOtp() {
    final otp = _controllers.map((c) => c.text).join();
    final expectedOtp = ref.read(registrationProvider).generatedOtp;
    
    if (otp.length == 6) {
      if (otp == expectedOtp || expectedOtp.isEmpty) {
        setState(() => _isVerified = true);
        _successController.forward().then((_) {
          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted) context.push('/priority_contact');
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid OTP. Please check your WhatsApp.")));
        for (var c in _controllers) { c.clear(); }
        _focusNodes[0].requestFocus();
      }
    }
  }

  void _handleResend() async {
    _startTimer();
    await ref.read(registrationProvider.notifier).sendWhatsAppOtp();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP Resent to WhatsApp")));
  }

  @override
  Widget build(BuildContext context) {
    final mobileNumber = ref.read(registrationProvider).mobileNumber;
    final maskedNumber = mobileNumber.length > 4 
      ? '+91 ${mobileNumber.substring(0, 5)} XXXX'
      : '+91 XXXXX XXXXX';

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FadeTransition(
            opacity: _entranceController,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(
                CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RakshaaBrandHeader(entranceController: _entranceController),
                  const SizedBox(height: 24),
                  const RegistrationProgress(currentStep: 2),
                  const SizedBox(height: 24),
                  
                  const Text(
                    "Verify Your Number",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.deepNavy, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "We've sent a 6-digit verification code to\n$maskedNumber",
                    style: const TextStyle(fontSize: 14, color: Color(0xFF71809A), height: 1.4),
                  ),
                  const SizedBox(height: 32),

                  if (_isVerified)
                    Center(
                      child: ScaleTransition(
                        scale: CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.softGreen.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check_circle, color: AppColors.softGreen, size: 64),
                            ),
                            const SizedBox(height: 16),
                            const Text("Verified", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.softGreen)),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            final hasValue = _controllers[index].text.isNotEmpty;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 48,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: hasValue || _focusNodes[index].hasFocus ? AppColors.rakshaaCoral : const Color(0xFFE9EAF0),
                                  width: hasValue || _focusNodes[index].hasFocus ? 2 : 1,
                                ),
                                boxShadow: _focusNodes[index].hasFocus ? [
                                  BoxShadow(color: AppColors.rakshaaCoral.withOpacity(0.1), blurRadius: 8)
                                ] : [],
                              ),
                              child: Center(
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.deepNavy),
                                  decoration: const InputDecoration(border: InputBorder.none, counterText: ""),
                                  onChanged: (v) => _handleChanged(v, index),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: const Text("Wrong number? Change number", style: TextStyle(fontSize: 13, color: Color(0xFF71809A))),
                            ),
                            GestureDetector(
                              onTap: _timerSeconds == 0 ? _handleResend : null,
                              child: Text(
                                _timerSeconds == 0 ? "Resend OTP" : "Resend in 00:${_timerSeconds.toString().padLeft(2, '0')}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _timerSeconds == 0 ? AppColors.rakshaaCoral : const Color(0xFF8A98B0),
                                ),
                              ),
                            ),
                          ],
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
