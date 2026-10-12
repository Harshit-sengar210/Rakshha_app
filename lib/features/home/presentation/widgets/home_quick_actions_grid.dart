import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeQuickActionsGrid extends StatelessWidget {
  final VoidCallback? onCallEmergency;
  final VoidCallback? onSendAlert;
  final VoidCallback? onRecordMedia;
  final VoidCallback? onFakeCall;

  const HomeQuickActionsGrid({
    super.key,
    this.onCallEmergency,
    this.onSendAlert,
    this.onRecordMedia,
    this.onFakeCall,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. Call Emergency
        Expanded(
          child: _buildActionCard(
            context: context,
            icon: Icons.phone_in_talk_rounded,
            iconBgColor: const Color(0xFFFF2E63).withOpacity(0.2),
            iconColor: const Color(0xFFFF2E63),
            label: "Call\nEmergency",
            onTap: onCallEmergency ?? () => _showEmergencyDialog(context),
          ),
        ),
        const SizedBox(width: 10),

        // 2. Send Alert
        Expanded(
          child: _buildActionCard(
            context: context,
            icon: Icons.campaign_rounded,
            iconBgColor: const Color(0xFF9C27B0).withOpacity(0.2),
            iconColor: const Color(0xFFBA68C8),
            label: "Send\nAlert",
            onTap: onSendAlert ?? () => _showSendAlertDialog(context),
          ),
        ),
        const SizedBox(width: 10),

        // 3. Record Audio/Video
        Expanded(
          child: _buildActionCard(
            context: context,
            icon: Icons.camera_alt_rounded,
            iconBgColor: const Color(0xFF0288D1).withOpacity(0.2),
            iconColor: const Color(0xFF29B6F6),
            label: "Record\nAudio/Video",
            onTap: onRecordMedia ?? () => _showRecordDialog(context),
          ),
        ),
        const SizedBox(width: 10),

        // 4. Fake Call
        Expanded(
          child: _buildActionCard(
            context: context,
            icon: Icons.warning_amber_rounded,
            iconBgColor: const Color(0xFFFF7043).withOpacity(0.2),
            iconColor: const Color(0xFFFF7043),
            label: "Fake Call",
            onTap: onFakeCall ?? () => _showFakeCallModal(context),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        height: 106,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF131622).withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1.2,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: iconColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 11,
                fontWeight: FontWeight.w500,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161926),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Emergency Services (112)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text("Do you want to immediately call the National Emergency Helpline (112)?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF2E63),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Calling Emergency Helpline (112)...")),
              );
            },
            child: const Text("Call 112", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showSendAlertDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF9C27B0),
        content: Text("Loud alert siren triggered on your device!"),
      ),
    );
  }

  void _showRecordDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF0288D1),
        content: Text("Incident audio & video evidence recorder ready."),
      ),
    );
  }

  void _showFakeCallModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF131622),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Schedule Fake Incoming Call",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Trigger an authentic incoming call to help you safely exit uncomfortable situations.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7043),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Fake call incoming in 5 seconds...")),
                      );
                    },
                    child: const Text("Call in 5s", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Fake call incoming in 30 seconds...")),
                      );
                    },
                    child: const Text("Call in 30s", style: TextStyle(color: Colors.white70)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
