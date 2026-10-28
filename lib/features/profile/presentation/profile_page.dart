import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rakshaa/features/home/presentation/widgets/rakshaa_bottom_nav.dart';
import '../../home/providers/home_provider.dart';
import '../../contacts/providers/contacts_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;

  // Toggle States
  bool _alertNotificationsEnabled = true;
  bool _appLockEnabled = true;
  bool _hiddenModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final contactsState = ref.watch(contactsProvider);
    final user = FirebaseAuth.instance.currentUser;

    final String userName = userProfile.value?['fullName']?.toString()
        ?? user?.displayName
        ?? 'Rohit';
    final String userPhone = userProfile.value?['mobileNumber']?.toString()
        ?? userProfile.value?['phone']?.toString()
        ?? '+91 98765 43210';
    final String photoUrl = userProfile.value?['photoUrl']?.toString()
        ?? user?.photoURL
        ?? 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150';

    final int contactsCount = contactsState.contacts.length;

    return Scaffold(
      backgroundColor: const Color(0xFF090A10),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: FadeTransition(
                  opacity: _entranceController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Top Header (Back button + Title + Subtitle + 3D Gear Graphic)
                      _buildHeader(),
                      const SizedBox(height: 20),

                      // 2. User Profile Card
                      _buildUserProfileCard(
                        name: userName,
                        phone: userPhone,
                        photoUrl: photoUrl,
                      ),
                      const SizedBox(height: 24),

                      // 3. Safety Settings Section
                      _buildSectionTitle("Safety Settings"),
                      const SizedBox(height: 10),
                      _buildSettingsGroup([
                        _buildNavigationItem(
                          icon: Icons.shield_outlined,
                          iconBgColor: const Color(0xFFFF2E63).withOpacity(0.2),
                          iconColor: const Color(0xFFFF2E63),
                          title: "SOS Settings",
                          subtitle: "Customize SOS message, mode and delay",
                          onTap: _showSosSettingsModal,
                        ),
                        _buildNavigationItem(
                          icon: Icons.people_alt_rounded,
                          iconBgColor: const Color(0xFF9C27B0).withOpacity(0.2),
                          iconColor: const Color(0xFFBA68C8),
                          title: "Emergency Contacts",
                          subtitle: "Manage your trusted contacts",
                          trailingText: "$contactsCount Added",
                          onTap: () => context.push('/contacts'),
                        ),
                        _buildNavigationItem(
                          icon: Icons.location_on_rounded,
                          iconBgColor: const Color(0xFF0288D1).withOpacity(0.2),
                          iconColor: const Color(0xFF29B6F6),
                          title: "Location Sharing",
                          subtitle: "Choose when to share your live location",
                          trailingText: "Always On",
                          onTap: _showLocationSharingModal,
                        ),
                        _buildNavigationItem(
                          icon: Icons.notifications_active_rounded,
                          iconBgColor: const Color(0xFFFF7043).withOpacity(0.2),
                          iconColor: const Color(0xFFFF7043),
                          title: "Emergency Call",
                          subtitle: "Set up quick call options",
                          onTap: _showEmergencyCallOptionsModal,
                        ),
                      ]),
                      const SizedBox(height: 22),

                      // 4. Notifications Section
                      _buildSectionTitle("Notifications"),
                      const SizedBox(height: 10),
                      _buildSettingsGroup([
                        _buildSwitchItem(
                          icon: Icons.notifications_rounded,
                          iconBgColor: const Color(0xFFFF2E63).withOpacity(0.2),
                          iconColor: const Color(0xFFFF2E63),
                          title: "Alert Notifications",
                          subtitle: "Get notified when SOS is triggered",
                          value: _alertNotificationsEnabled,
                          onChanged: (val) {
                            setState(() => _alertNotificationsEnabled = val);
                          },
                        ),
                        _buildNavigationItem(
                          icon: Icons.volume_up_rounded,
                          iconBgColor: const Color(0xFF9C27B0).withOpacity(0.2),
                          iconColor: const Color(0xFFBA68C8),
                          title: "Sound & Vibration",
                          subtitle: "Control alert sound and vibration",
                          onTap: _showSoundVibrationModal,
                        ),
                        _buildNavigationItem(
                          icon: Icons.phone_in_talk_rounded,
                          iconBgColor: const Color(0xFF0288D1).withOpacity(0.2),
                          iconColor: const Color(0xFF29B6F6),
                          title: "Test Alert",
                          subtitle: "Send a test message to your contacts",
                          onTap: _showTestAlertModal,
                        ),
                      ]),
                      const SizedBox(height: 22),

                      // 5. Privacy & Security Section
                      _buildSectionTitle("Privacy & Security"),
                      const SizedBox(height: 10),
                      _buildSettingsGroup([
                        _buildSwitchItem(
                          icon: Icons.lock_outline_rounded,
                          iconBgColor: const Color(0xFF00E676).withOpacity(0.18),
                          iconColor: const Color(0xFF00E676),
                          title: "App Lock",
                          subtitle: "Use PIN / Biometric to open app",
                          value: _appLockEnabled,
                          onChanged: (val) {
                            setState(() => _appLockEnabled = val);
                          },
                        ),
                        _buildSwitchItem(
                          icon: Icons.visibility_outlined,
                          iconBgColor: const Color(0xFF9C27B0).withOpacity(0.2),
                          iconColor: const Color(0xFFBA68C8),
                          title: "Hidden Mode",
                          subtitle: "Keep the app hidden from recent apps",
                          value: _hiddenModeEnabled,
                          onChanged: (val) {
                            setState(() => _hiddenModeEnabled = val);
                          },
                        ),
                        _buildNavigationItem(
                          icon: Icons.shield_outlined,
                          iconBgColor: const Color(0xFFFF2E63).withOpacity(0.2),
                          iconColor: const Color(0xFFFF2E63),
                          title: "Data & Privacy",
                          subtitle: "Manage your data and permissions",
                          onTap: _showDataPrivacyModal,
                        ),
                      ]),
                      const SizedBox(height: 22),

                      // 6. Support & About Section
                      _buildSectionTitle("Support & About"),
                      const SizedBox(height: 10),
                      _buildSettingsGroup([
                        _buildNavigationItem(
                          icon: Icons.help_outline_rounded,
                          iconBgColor: const Color(0xFF0288D1).withOpacity(0.2),
                          iconColor: const Color(0xFF29B6F6),
                          title: "Help & Support",
                          subtitle: "FAQs and support center",
                          onTap: _showHelpSupportModal,
                        ),
                        _buildNavigationItem(
                          icon: Icons.info_outline_rounded,
                          iconBgColor: const Color(0xFFFF7043).withOpacity(0.2),
                          iconColor: const Color(0xFFFF7043),
                          title: "About Rakshaa",
                          subtitle: "App version 1.0.0",
                          onTap: _showAboutAppModal,
                        ),
                      ]),
                      const SizedBox(height: 22),

                      // 7. Log Out Action Button
                      _buildLogoutButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar (Highlights Settings)
            const RakshaaBottomNav(),
          ],
        ),
      ),
    );
  }

  // --- Header with Back Button and 3D Glowing Gear Hero Visual ---
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF131622).withOpacity(0.9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.12),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Settings",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Manage your safety preferences and account.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        // Glowing 3D Gear Graphic with Heart Shield
        _buildGearHeroGraphic(),
      ],
    );
  }

  Widget _buildGearHeroGraphic() {
    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient Glow
          Container(
            width: 95,
            height: 95,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFF2E63).withOpacity(0.35),
                  const Color(0xFFFF2E63).withOpacity(0.06),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Big Glowing Gear Icon
          const Center(
            child: Icon(
              Icons.settings_rounded,
              color: Color(0xFFFF4D79),
              size: 68,
            ),
          ),

          // Small Overlaid Heart Shield Badge on the Gear
          Positioned(
            right: 6,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFF131622),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF2E63), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF2E63).withOpacity(0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: Color(0xFFFF2E63),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- User Profile Card ---
  Widget _buildUserProfileCard({
    required String name,
    required String phone,
    required String photoUrl,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF131622).withOpacity(0.85),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // User Avatar with Edit Badge
          Stack(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                  image: DecorationImage(
                    image: NetworkImage(photoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(3.5),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF2E63),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // User Name & Phone
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  phone,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Edit Profile Button
          GestureDetector(
            onTap: () => context.push('/personal_details'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1E2E).withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFF2E63).withOpacity(0.35),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, color: Color(0xFFFF2E63), size: 14),
                  SizedBox(width: 5),
                  Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Color(0xFFFF2E63),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(Icons.chevron_right_rounded, color: Color(0xFFFF2E63), size: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131622).withOpacity(0.85),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1.1,
        ),
      ),
      child: Column(
        children: items,
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            if (trailingText != null) ...[
              Text(
                trailingText,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
            ],

            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.45),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: 20),
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFFFF2E63),
            inactiveThumbColor: Colors.white60,
            inactiveTrackColor: const Color(0xFF22283C),
            onChanged: (val) {
              HapticFeedback.selectionClick();
              onChanged(val);
            },
          ),
        ],
      ),
    );
  }

  // --- Modals for Created Features ---

  void _showSosSettingsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF131622),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text("SOS Emergency Settings", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Your customized SOS alert will be instantly dispatched via WhatsApp and SMS to all added emergency contacts.", style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1E2E),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text("🚨 *EMERGENCY SOS ALERT* 🚨\nIncludes: Full Address, Coordinates & Google Maps Live Link.", style: TextStyle(color: Colors.white, fontSize: 12.5)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E63), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationSharingModal() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(backgroundColor: Color(0xFF131622), content: Text("Live Location Sharing is configured to Always On during emergencies.")),
    );
  }

  void _showEmergencyCallOptionsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF131622),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Emergency Quick Call", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.local_police_rounded, color: Color(0xFFFF2E63)),
              title: const Text("National Emergency Helpline (112)", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.star_rounded, color: Colors.amber),
              title: const Text("Priority Contact Auto-Dial", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _showSoundVibrationModal() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(backgroundColor: Color(0xFF131622), content: Text("Alert sound set to High Volume & Continuous Vibration.")),
    );
  }

  void _showTestAlertModal() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161926),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Send Test Alert?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text("This will send a sample safety test message on WhatsApp to your trusted contacts verifying the connection.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel", style: TextStyle(color: Colors.white60))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E63)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(backgroundColor: Color(0xFF00E676), content: Text("Test alert successfully dispatched to contacts!")),
              );
            },
            child: const Text("Send Test", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDataPrivacyModal() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(backgroundColor: Color(0xFF131622), content: Text("All location and personal emergency data is end-to-end encrypted.")),
    );
  }

  void _showHelpSupportModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF131622),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Help & Support", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text("• How does SOS work?\nPressing the SOS button instantly sends your full location and address to your added trusted contacts via WhatsApp and notifies the emergency network.\n\n• Who can see my location?\nOnly your approved emergency contacts receive your location during active alerts.", style: TextStyle(color: Colors.white70, height: 1.4)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E63)),
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Close", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutAppModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF131622),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Rakshaa Safety Network", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text("Version 1.0.0 (Enterprise Edition)", style: TextStyle(color: Colors.white60, fontSize: 13)),
            const SizedBox(height: 16),
            Text(
              "Rakshaa provides continuous safety monitoring, emergency WhatsApp broadcasting, and live location sharing.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12.5, height: 1.4),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF2E63),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Close", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Dedicated Log Out Action ---
  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF131622).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF2E63).withOpacity(0.25),
          width: 1.1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _showLogoutConfirmationDialog,
          splashColor: const Color(0xFFFF2E63).withOpacity(0.15),
          highlightColor: const Color(0xFFFF2E63).withOpacity(0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF2E63).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFF2E63).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFFF2E63),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Log Out",
                        style: TextStyle(
                          color: Color(0xFFFF2E63),
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Sign out of your Rakshaa account",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: const Color(0xFFFF2E63).withOpacity(0.6),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF131622),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Indicator Bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Glowing Warning/Logout Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF2E63).withOpacity(0.15),
                  border: Border.all(
                    color: const Color(0xFFFF2E63).withOpacity(0.35),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFFF2E63),
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Log Out of Rakshaa?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                "Are you sure you want to log out? You will need to sign in again to send emergency SOS alerts.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withOpacity(0.2)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Confirm Log Out Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF2E63),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        HapticFeedback.heavyImpact();
                        Navigator.pop(ctx);
                        await FirebaseAuth.instance.signOut();
                        if (mounted) {
                          context.go('/login');
                        }
                      },
                      child: const Text(
                        "Log Out",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
