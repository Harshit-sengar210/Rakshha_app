import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import '../providers/registration_provider.dart';
import 'widgets/rakshaa_brand_header.dart';
import 'widgets/registration_progress.dart';

class TrustedContactsPage extends ConsumerStatefulWidget {
  const TrustedContactsPage({super.key});

  @override
  ConsumerState<TrustedContactsPage> createState() => _TrustedContactsPageState();
}

class _TrustedContactsPageState extends ConsumerState<TrustedContactsPage> with TickerProviderStateMixin {
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _entranceController.forward();
    
    // Add one initial empty contact if list is empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(registrationProvider).trustedContacts.isEmpty) {
        ref.read(registrationProvider.notifier).addTrustedContact(TrustedContact(name: '', mobile: '+91 '));
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _handleAddContact() {
    if (ref.read(registrationProvider).trustedContacts.length < 4) {
      ref.read(registrationProvider.notifier).addTrustedContact(TrustedContact(name: '', mobile: '+91 '));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Maximum 4 additional contacts allowed.")));
    }
  }

  void _handleContinue() {
    context.push('/registration_review');
  }

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(registrationProvider).trustedContacts;

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
                  const RegistrationProgress(currentStep: 4),
                  const SizedBox(height: 24),

                  const Text("Add Trusted Contacts", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.deepNavy, letterSpacing: -0.5)),
                  const SizedBox(height: 8),
                  const Text("Choose people who can receive your safety alerts. Rakshaa can notify trusted contacts when you activate an emergency.", style: TextStyle(fontSize: 14, color: Color(0xFF71809A), height: 1.4)),
                  const SizedBox(height: 16),

                  // Info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.info_outline, color: AppColors.deepNavy, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text("How alerts work\nRakshaa may use WhatsApp, SMS, or calls to reach your trusted contacts during an emergency.", style: TextStyle(fontSize: 13, color: AppColors.deepNavy, height: 1.4)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: contacts.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return _ContactCard(
                        contact: contact,
                        onUpdate: (updated) => ref.read(registrationProvider.notifier).updateTrustedContact(index, updated),
                        onDelete: () => ref.read(registrationProvider.notifier).removeTrustedContact(index),
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: _handleAddContact,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.deepNavy,
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: Color(0xFFE9EAF0), width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text("+ Add Another Contact", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),

                  const SizedBox(height: 40),
                  const Text("By adding a trusted contact, you confirm that you have permission to use their contact information for Rakshaa safety notifications.", style: TextStyle(fontSize: 11, color: Color(0xFF8A98B0), height: 1.4), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.rakshaaCoral,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      elevation: 0,
                    ),
                    child: const Text("Continue →", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: _handleContinue,
                      child: const Text("Skip for now", style: TextStyle(color: Color(0xFF71809A))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final TrustedContact contact;
  final ValueChanged<TrustedContact> onUpdate;
  final VoidCallback onDelete;

  const _ContactCard({required this.contact, required this.onUpdate, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9EAF0)),
        boxShadow: [BoxShadow(color: AppColors.deepNavy.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.person, color: Color(0xFF8A98B0)),
              IconButton(icon: const Icon(Icons.close, color: Color(0xFF8A98B0), size: 20), onPressed: onDelete, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
            ],
          ),
          TextField(
            controller: TextEditingController(text: contact.name)..selection = TextSelection.collapsed(offset: contact.name.length),
            onChanged: (v) => onUpdate(contact.copyWith(name: v)),
            decoration: const InputDecoration(hintText: "Contact Name", border: InputBorder.none, hintStyle: TextStyle(color: Color(0xFF8A98B0))),
            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.deepNavy),
          ),
          TextField(
            controller: TextEditingController(text: contact.mobile)..selection = TextSelection.collapsed(offset: contact.mobile.length),
            keyboardType: TextInputType.phone,
            onChanged: (v) => onUpdate(contact.copyWith(mobile: v)),
            decoration: const InputDecoration(hintText: "+91 | Mobile Number", border: InputBorder.none, hintStyle: TextStyle(color: Color(0xFF8A98B0))),
          ),
          const Divider(color: Color(0xFFE9EAF0)),
          const SizedBox(height: 8),
          _buildToggleRow("WhatsApp Alerts", contact.useWhatsApp, (v) => onUpdate(contact.copyWith(useWhatsApp: v))),
          const SizedBox(height: 12),
          _buildToggleRow("SMS Alerts", contact.useSms, (v) => onUpdate(contact.copyWith(useSms: v))),
        ],
      ),
    );
  }

  Widget _buildToggleRow(String title, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: value ? FontWeight.w600 : FontWeight.w500, color: value ? AppColors.deepNavy : const Color(0xFF71809A))),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.rakshaaCoral,
          activeTrackColor: AppColors.rakshaaCoral.withOpacity(0.2),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFE9EAF0),
        ),
      ],
    );
  }
}
