import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import '../providers/registration_provider.dart';
import 'widgets/rakshaa_brand_header.dart';
import 'widgets/registration_progress.dart';

class RegistrationReviewPage extends ConsumerStatefulWidget {
  const RegistrationReviewPage({super.key});

  @override
  ConsumerState<RegistrationReviewPage> createState() => _RegistrationReviewPageState();
}

class _RegistrationReviewPageState extends ConsumerState<RegistrationReviewPage> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateAccount() async {
    setState(() => _isLoading = true);

    try {
      final state = ref.read(registrationProvider);
      User? user = FirebaseAuth.instance.currentUser;

      // If no user is signed in (e.g., didn't use Google), create with email/password
      if (user == null && state.email.isNotEmpty && state.password.isNotEmpty) {
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );
        user = userCredential.user;
        
        await user?.updateDisplayName(state.fullName);
      }

      if (user != null) {
        // Save to Firestore
        final userData = {
          'fullName': state.fullName,
          'age': state.age,
          'gender': state.gender,
          'address': state.address,
          'mobileNumber': state.mobileNumber,
          'email': state.email,
          'priorityContact': {
            'name': state.priorityContact?.name ?? '',
            'relationship': state.priorityContact?.relationship ?? '',
            'phone': state.priorityContact?.mobile ?? '',
          },
          'trustedContacts': state.trustedContacts.map((c) => {
            'name': c.name,
            'phone': c.mobile,
            'hasWhatsApp': c.useWhatsApp,
          }).toList(),
          'createdAt': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(userData);
      } else {
        throw Exception("Failed to authenticate user");
      }

      if (mounted) {
        context.push('/registration_success');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString().split(']').last}"),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  Widget _buildCard(String title, List<Widget> children, VoidCallback onEdit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9EAF0)),
        boxShadow: [BoxShadow(color: AppColors.deepNavy.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.deepNavy)),
              GestureDetector(
                onTap: onEdit,
                child: const Text("Edit", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.rakshaaCoral)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF8A98B0)))),
          Expanded(child: Text(value.isEmpty ? "Not provided" : value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.deepNavy))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationProvider);

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
                  const RegistrationProgress(currentStep: 5),
                  const SizedBox(height: 24),

                  const Text("Review Your Safety Setup", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.deepNavy, letterSpacing: -0.5)),
                  const SizedBox(height: 8),
                  const Text("Make sure everything looks correct before we create your Rakshaa account.", style: TextStyle(fontSize: 14, color: Color(0xFF71809A), height: 1.4)),
                  const SizedBox(height: 24),

                  _buildCard(
                    "Personal Information",
                    [
                      _buildRow("Name", state.fullName),
                      _buildRow("Age", state.age),
                      _buildRow("Gender", state.gender),
                      _buildRow("Mobile", state.mobileNumber),
                      if (state.email.isNotEmpty) _buildRow("Email", state.email),
                      _buildRow("Address", state.address),
                      _buildRow("Password", "••••••••"),
                    ],
                    () => context.go('/signup'),
                  ),

                  if (state.priorityContact != null)
                    _buildCard(
                      "Priority Contact",
                      [
                        _buildRow("Name", state.priorityContact!.name),
                        _buildRow("Relationship", state.priorityContact!.relationship),
                        _buildRow("Mobile", state.priorityContact!.mobile),
                        const SizedBox(height: 8),
                        Row(children: const [Icon(Icons.check_circle, color: AppColors.softGreen, size: 16), SizedBox(width: 8), Text("Ready", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.softGreen))]),
                      ],
                      () => context.go('/priority_contact'),
                    ),

                  if (state.trustedContacts.where((c) => c.name.isNotEmpty && c.mobile.isNotEmpty).isNotEmpty)
                    _buildCard(
                      "Trusted Contacts",
                      state.trustedContacts.where((c) => c.name.isNotEmpty && c.mobile.isNotEmpty).map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.deepNavy)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (c.useWhatsApp) const Text("WhatsApp ✓  ", style: TextStyle(fontSize: 12, color: AppColors.softGreen, fontWeight: FontWeight.w600)),
                                if (c.useSms) const Text("SMS ✓", style: TextStyle(fontSize: 12, color: AppColors.softGreen, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      )).toList(),
                      () => context.go('/trusted_contacts'),
                    ),

                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleCreateAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.rakshaaCoral,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                      elevation: _isLoading ? 0 : 4,
                      shadowColor: AppColors.rakshaaCoral.withOpacity(0.4),
                    ),
                    child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                            SizedBox(width: 12),
                            Text("Creating your safe space...", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          ],
                        )
                      : const Text("Create My Rakshaa Account →", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
