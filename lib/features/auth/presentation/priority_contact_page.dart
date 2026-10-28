import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import '../providers/registration_provider.dart';
import 'widgets/rakshaa_brand_header.dart';
import 'widgets/registration_progress.dart';
import 'widgets/auth_input_field.dart';

class PriorityContactPage extends ConsumerStatefulWidget {
  const PriorityContactPage({super.key});

  @override
  ConsumerState<PriorityContactPage> createState() => _PriorityContactPageState();
}

class _PriorityContactPageState extends ConsumerState<PriorityContactPage> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  String _relationship = 'Parent';
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      if (_nameController.text.trim().isEmpty || _mobileController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Name and mobile are required")));
        return;
      }
      
      final formattedMobile = _formatPhoneNumber(_mobileController.text.trim());
      ref.read(registrationProvider.notifier).updatePriorityContact(PriorityContact(
        name: _nameController.text.trim(),
        mobile: formattedMobile,
        relationship: _relationship,
      ));

      setState(() => _isSuccess = true);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) context.push('/trusted_contacts');
      });
    }
  }

  final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();

  Future<void> _pickContactFromDevice() async {
    try {
      final Contact? contact = await _contactPicker.selectContact();
      if (contact != null) {
        if (contact.fullName != null && contact.fullName!.trim().isNotEmpty) {
          _nameController.text = contact.fullName!.trim();
        }
        final phone = contact.selectedPhoneNumber ?? (contact.phoneNumbers?.isNotEmpty == true ? contact.phoneNumbers!.first : null);
        if (phone != null && phone.isNotEmpty) {
          _mobileController.text = _formatPhoneNumber(phone);
        }
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error picking contact: $e")),
        );
      }
    }
  }

  String _formatPhoneNumber(String raw) {
    String digitsOnly = raw.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.isEmpty) return raw.trim();

    if (digitsOnly.length == 12 && digitsOnly.startsWith('91')) {
      return '+91 ${digitsOnly.substring(2)}';
    }
    if (digitsOnly.length == 11 && digitsOnly.startsWith('0')) {
      return '+91 ${digitsOnly.substring(1)}';
    }
    if (digitsOnly.length == 10) {
      return '+91 $digitsOnly';
    }
    if (raw.trim().startsWith('+')) {
      return raw.trim();
    }
    return '+91 $digitsOnly';
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
                    const RegistrationProgress(currentStep: 3),
                    const SizedBox(height: 24),

                    const Text("Choose Your Priority Contact", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.deepNavy, letterSpacing: -0.5)),
                    const SizedBox(height: 8),
                    const Text("Who should Rakshaa reach first if you need urgent help? Your priority contact will be the first trusted person we try to reach during an emergency.", style: TextStyle(fontSize: 14, color: Color(0xFF71809A), height: 1.4)),
                    const SizedBox(height: 32),

                    // Illustration
                    Center(
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(radius: 24, backgroundColor: Color(0xFFEAF2FF), child: Icon(Icons.person, color: AppColors.deepNavy)),
                            Expanded(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(height: 2, color: AppColors.rakshaaCoral.withOpacity(0.3)),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                    child: const Icon(Icons.shield, color: AppColors.rakshaaCoral, size: 20),
                                  ),
                                ],
                              ),
                            ),
                            const CircleAvatar(radius: 24, backgroundColor: Color(0xFFFFF0F1), child: Icon(Icons.favorite, color: AppColors.rakshaaCoral)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    Center(
                      child: OutlinedButton.icon(
                        onPressed: _pickContactFromDevice,
                        icon: const Icon(Icons.contacts_outlined, size: 18),
                        label: const Text("Choose from Contacts"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.deepNavy,
                          side: const BorderSide(color: Color(0xFFE9EAF0)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    AuthInputField(
                      controller: _nameController,
                      hintText: "e.g. Mom / Dad / Rohan",
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    AuthInputField(
                      controller: _mobileController,
                      hintText: "+91 | Phone Number",
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 54,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE9EAF0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _relationship,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF8A98B0)),
                          items: ['Parent', 'Mother', 'Father', 'Sister', 'Brother', 'Partner', 'Friend', 'Other'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.deepNavy)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _relationship = val);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _isSuccess ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSuccess ? AppColors.softGreen : AppColors.rakshaaCoral,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 0,
                      ),
                      child: _isSuccess 
                        ? const Icon(Icons.check, color: Colors.white)
                        : const Text("Save Priority Contact →", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
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
