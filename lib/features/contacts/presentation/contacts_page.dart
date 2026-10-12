import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rakshaa/features/home/presentation/widgets/rakshaa_bottom_nav.dart';
import '../providers/contacts_provider.dart';
import '../models/trusted_contact.dart';

class ContactsPage extends ConsumerStatefulWidget {
  const ContactsPage({super.key});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage> with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;

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
    final contactsState = ref.watch(contactsProvider);
    final realContacts = contactsState.contacts;

    // Fallback default contacts matching the reference mockup
    final defaultMockContacts = [
      TrustedContact(
        id: 'mock_mom',
        name: 'Mom',
        relationship: 'Mother',
        phone: '+91 98765 43210',
        isPriority: true,
        isWhatsAppEnabled: true,
      ),
      TrustedContact(
        id: 'mock_dad',
        name: 'Dad',
        relationship: 'Father',
        phone: '+91 91234 56789',
        isPriority: false,
        isWhatsAppEnabled: true,
      ),
      TrustedContact(
        id: 'mock_sister',
        name: 'Sister',
        relationship: 'Sibling',
        phone: '+91 87654 32109',
        isPriority: false,
        isWhatsAppEnabled: true,
      ),
    ];

    final displayContacts = realContacts.isNotEmpty ? realContacts : defaultMockContacts;

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
                      // 1. Back Button + Top Title & Glowing 3D Shield Hero Visual
                      _buildHeader(),
                      const SizedBox(height: 20),

                      // 2. Status Banner (3 Contacts Added - Active)
                      _buildStatusBanner(displayContacts.length),
                      const SizedBox(height: 16),

                      // 3. Contact Cards List
                      ...displayContacts.map((contact) => _buildContactCard(contact)),

                      const SizedBox(height: 10),

                      // 4. "Add Emergency Contact" Dashed Card
                      _buildAddContactCard(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar
            const RakshaaBottomNav(),
          ],
        ),
      ),
    );
  }

  // --- Top Header with Back Button & Glowing Shield Visual ---
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Back button + Title + Subtitle
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
              const SizedBox(height: 18),

              // Title: "Emergency Contacts"
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                  children: [
                    TextSpan(
                      text: "Emergency\n",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: "Contacts",
                      style: TextStyle(color: Color(0xFFFF2E63)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                "These contacts will receive your live location and SOS message when you need help.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // Right Hero Visual: Glowing 3D Shield with Heart
        _buildShieldHeroGraphic(),
      ],
    );
  }

  // --- Glowing 3D Shield with Heart Hero Visual ---
  Widget _buildShieldHeroGraphic() {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Cosmic Ambient Glow Ring
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFF2E63).withOpacity(0.35),
                  const Color(0xFFFF2E63).withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Floating Light Orbs/Particles
          Positioned(
            top: 20,
            right: 12,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFFF8FA3),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Color(0xFFFF2E63), blurRadius: 6),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            left: 10,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: Color(0xFFFF8FA3),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Color(0xFFFF2E63), blurRadius: 6),
                ],
              ),
            ),
          ),

          // Core Glowing 3D Shield
          Container(
            width: 80,
            height: 94,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF5277),
                  Color(0xFFFF2E63),
                  Color(0xFFD61348),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(26),
                topRight: Radius.circular(26),
                bottomLeft: Radius.circular(42),
                bottomRight: Radius.circular(42),
              ),
              border: Border.all(
                color: const Color(0xFFFF8FA3).withOpacity(0.6),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF2E63).withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Status Banner (3 Contacts Added - Active) ---
  Widget _buildStatusBanner(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF131622).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1.1,
        ),
      ),
      child: Row(
        children: [
          // Rounded Red Square with 2 People Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFF2E63).withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFFF2E63).withOpacity(0.35),
                width: 1,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.group_rounded,
                color: Color(0xFFFF2E63),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$count Contacts Added",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Your safety network is ready",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Active Green Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF00E676).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF00E676).withOpacity(0.4),
                width: 0.9,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00E676),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  "Active",
                  style: TextStyle(
                    color: Color(0xFF00E676),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Contact Card (Mom, Dad, Sister) ---
  Widget _buildContactCard(TrustedContact contact) {
    final photoMap = {
      'Mom': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      'Dad': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'Sister': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    };

    final avatarUrl = photoMap[contact.name] ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131622).withOpacity(0.85),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Avatar + Name + Relationship + Active Badge + Menu
          Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.18), width: 1.5),
                  image: DecorationImage(
                    image: NetworkImage(avatarUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name, Relationship Pill & Phone
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          contact.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (contact.relationship.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9C27B0).withOpacity(0.25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              contact.relationship,
                              style: const TextStyle(
                                color: Color(0xFFBA68C8),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.call_rounded,
                          color: Colors.white.withOpacity(0.55),
                          size: 13,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          contact.phone,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Active Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E676).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF00E676).withOpacity(0.4),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00E676),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Active",
                      style: TextStyle(
                        color: Color(0xFF00E676),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),

              // Options Menu
              GestureDetector(
                onTap: () => _showContactOptions(contact),
                child: Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white.withOpacity(0.55),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Bottom Actions Row (Message, Call, Share Now)
          Row(
            children: [
              // 1. Message (White icon)
              Expanded(
                child: _buildActionButton(
                  icon: Icons.chat_bubble_rounded,
                  iconColor: Colors.white,
                  label: "Message",
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF131622),
                        content: Text("Messaging ${contact.name} on WhatsApp..."),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),

              // 2. Call (Green icon)
              Expanded(
                child: _buildActionButton(
                  icon: Icons.phone_in_talk_rounded,
                  iconColor: const Color(0xFF00E676),
                  label: "Call",
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF131622),
                        content: Text("Calling ${contact.name} (${contact.phone})..."),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),

              // 3. Share Now (Purple icon)
              Expanded(
                child: _buildActionButton(
                  icon: Icons.near_me_rounded,
                  iconColor: const Color(0xFFBA68C8),
                  label: "Share Now",
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF131622),
                        content: Text("Sharing live location with ${contact.name}..."),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1E2E).withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- "Add Emergency Contact" Dashed Border Card ---
  Widget _buildAddContactCard() {
    return GestureDetector(
      onTap: _showAddContactModal,
      child: CustomPaint(
        painter: _DashedRectPainter(
          color: const Color(0xFFFF2E63).withOpacity(0.45),
          strokeWidth: 1.5,
          gap: 5,
          dash: 6,
          radius: 24,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF131622).withOpacity(0.6),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Glowing Circular Plus Button
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xFFFF5277),
                      Color(0xFFFF2E63),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF2E63).withOpacity(0.55),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Title
              const Text(
                "Add Emergency Contact",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),

              // Subtitle
              Text(
                "Add family or friends to stay safe",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddContactModal() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController(text: "+91 ");
    String relationship = "Family";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF131622),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
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
              const SizedBox(height: 16),
              const Text(
                "Add Emergency Contact",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Name Field
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  filled: true,
                  fillColor: const Color(0xFF1B1E2E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),

              // Phone Field
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  filled: true,
                  fillColor: const Color(0xFF1B1E2E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),

              // Relationship Selector
              DropdownButtonFormField<String>(
                value: relationship,
                dropdownColor: const Color(0xFF1B1E2E),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Relationship",
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  filled: true,
                  fillColor: const Color(0xFF1B1E2E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
                items: ["Mother", "Father", "Sibling", "Spouse", "Friend", "Family", "Guardian"]
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setModalState(() => relationship = v);
                },
              ),
              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF2E63),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    if (nameController.text.trim().isNotEmpty && phoneController.text.trim().isNotEmpty) {
                      final newContact = TrustedContact(
                        id: 'contact_${DateTime.now().millisecondsSinceEpoch}',
                        name: nameController.text.trim(),
                        relationship: relationship,
                        phone: phoneController.text.trim(),
                        isPriority: false,
                        isWhatsAppEnabled: true,
                      );
                      ref.read(contactsProvider.notifier).addContact(newContact);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${newContact.name} added to your emergency contacts.")),
                      );
                    }
                  },
                  child: const Text("Save Contact", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContactOptions(TrustedContact contact) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF131622),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.star_outline_rounded, color: Colors.amber),
                title: const Text("Set as Priority Contact", style: TextStyle(color: Colors.white)),
                onTap: () {
                  ref.read(contactsProvider.notifier).setPriorityContact(contact.id);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: Color(0xFFFF2E63)),
                title: const Text("Remove Contact", style: TextStyle(color: Color(0xFFFF2E63))),
                onTap: () {
                  ref.read(contactsProvider.notifier).removeContact(contact.id);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for dashed border rectangle
class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dash;
  final double radius;

  _DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.dash,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dash;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) => false;
}
