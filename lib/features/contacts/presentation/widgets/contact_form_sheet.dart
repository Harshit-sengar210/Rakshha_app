import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import '../../models/trusted_contact.dart';
import '../../providers/contacts_provider.dart';

class ContactFormSheet extends ConsumerStatefulWidget {
  final TrustedContact? existingContact;

  const ContactFormSheet({
    super.key,
    this.existingContact,
  });

  @override
  ConsumerState<ContactFormSheet> createState() => _ContactFormSheetState();
}

class _ContactFormSheetState extends ConsumerState<ContactFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _relationshipController;
  late TextEditingController _phoneController;
  bool _isLoading = false;
  bool _isPriority = false;
  bool _isWhatsAppEnabled = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingContact?.name ?? '');
    _relationshipController = TextEditingController(text: widget.existingContact?.relationship ?? '');
    _phoneController = TextEditingController(text: widget.existingContact?.phone ?? '+91 ');
    _isPriority = widget.existingContact?.isPriority ?? false;
    _isWhatsAppEnabled = widget.existingContact?.isWhatsAppEnabled ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final name = _nameController.text.trim();
    final relationship = _relationshipController.text.trim();
    final phone = _phoneController.text.trim();

    if (widget.existingContact != null) {
      ref.read(contactsProvider.notifier).updateContact(
            widget.existingContact!.copyWith(
              name: name,
              relationship: relationship.isEmpty ? 'Contact' : relationship,
              phone: phone,
              isPriority: _isPriority,
              isWhatsAppEnabled: _isWhatsAppEnabled,
            ),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contact updated")),
      );
    } else {
      final newContact = TrustedContact(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        relationship: relationship.isEmpty ? 'Contact' : relationship,
        phone: phone,
        isPriority: _isPriority,
        isWhatsAppEnabled: _isWhatsAppEnabled,
      );
      ref.read(contactsProvider.notifier).addContact(newContact);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contact added")),
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingContact != null;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing ? "Edit Contact" : "Add Emergency Contact",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepNavy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isEditing ? "Update your trusted contact's details." : "Choose someone Rakshaa can reach during an emergency.",
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.deepNavy),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? "Name is required" : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _relationshipController,
                  decoration: InputDecoration(
                    labelText: "Relationship (Optional)",
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.deepNavy),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.deepNavy),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.trim().isEmpty ? "Phone number is required" : null,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text("Priority Contact"),
                  subtitle: const Text("First to be alerted in an emergency.", style: TextStyle(fontSize: 12)),
                  value: _isPriority,
                  activeThumbColor: AppColors.rakshaaCoral,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) => setState(() => _isPriority = val),
                ),
                SwitchListTile(
                  title: const Text("WhatsApp Alerts"),
                  subtitle: const Text("Send emergency messages via WhatsApp.", style: TextStyle(fontSize: 12)),
                  value: _isWhatsAppEnabled,
                  activeThumbColor: AppColors.softGreen,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) => setState(() => _isWhatsAppEnabled = val),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Cancel", style: TextStyle(color: AppColors.deepNavy)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.rakshaaCoral,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(isEditing ? "Save Changes" : "Add Contact", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                if (isEditing) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: _isLoading ? null : () {
                        Navigator.pop(context);
                        _showRemoveConfirmation(context, ref, widget.existingContact!);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.emergencyRed,
                      ),
                      child: const Text("Remove this contact"),
                    ),
                  ),
                ],
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showRemoveConfirmation(BuildContext context, WidgetRef ref, TrustedContact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove this contact?"),
        content: const Text("They will no longer receive Rakshaa emergency alerts."),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: AppColors.deepNavy)),
          ),
          TextButton(
            onPressed: () {
              ref.read(contactsProvider.notifier).removeContact(contact.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Contact removed")),
              );
            },
            child: const Text("Remove Contact", style: TextStyle(color: AppColors.emergencyRed)),
          ),
        ],
      ),
    );
  }
}

void showContactForm(BuildContext context, {TrustedContact? contact}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ContactFormSheet(existingContact: contact),
  );
}
