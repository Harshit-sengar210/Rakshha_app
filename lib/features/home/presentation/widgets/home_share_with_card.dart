import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeShareWithCard extends StatelessWidget {
  final List<Map<String, dynamic>> contacts;
  final VoidCallback? onAddTap;
  final VoidCallback? onHeaderTap;
  final Function(Map<String, dynamic> contact)? onContactTap;

  const HomeShareWithCard({
    super.key,
    required this.contacts,
    this.onAddTap,
    this.onHeaderTap,
    this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    // Default fallback contacts matching the mockup if none are registered yet
    final defaultMockContacts = [
      {
        'name': 'Mom',
        'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
        'isOnline': true,
      },
      {
        'name': 'Dad',
        'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        'isOnline': true,
      },
      {
        'name': 'Sister',
        'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        'isOnline': true,
      },
    ];

    final displayList = contacts.isNotEmpty ? contacts : defaultMockContacts;
    final countLabel = "${displayList.length} trusted contacts";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF131622).withOpacity(0.85),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          GestureDetector(
            onTap: onHeaderTap ?? () => context.push('/contacts'),
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Share with",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      countLabel,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white.withOpacity(0.55),
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Horizontal list of avatars
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                // "+ Add" Button with Dashed/Stroked circle
                GestureDetector(
                  onTap: onAddTap ?? () => context.push('/contacts'),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomPaint(
                          painter: _DashedCirclePainter(
                            color: Colors.white.withOpacity(0.35),
                            strokeWidth: 1.5,
                            dashes: 18,
                            gap: 3,
                          ),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.04),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white.withOpacity(0.85),
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Contact Avatars
                ...displayList.map((contact) {
                  final name = (contact['name'] ?? 'Contact').toString();
                  final image = contact['image'] ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150';
                  final isOnline = contact['isOnline'] != false;

                  return GestureDetector(
                    onTap: () => onContactTap?.call(contact),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (isOnline)
                                Positioned(
                                  right: 2,
                                  bottom: 2,
                                  child: Container(
                                    width: 11,
                                    height: 11,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00E676),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF131622),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for circular dashed border
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashes;
  final double gap;

  _DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashes,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final radius = size.width / 2;
    final center = Offset(radius, radius);
    final circumference = 2 * 3.141592653589793 * radius;
    final dashLength = (circumference / dashes) - gap;
    final anglePerDash = (dashLength / circumference) * 2 * 3.141592653589793;
    final angleGap = (gap / circumference) * 2 * 3.141592653589793;

    double currentAngle = 0.0;
    for (int i = 0; i < dashes; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        anglePerDash,
        false,
        paint,
      );
      currentAngle += anglePerDash + angleGap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) => false;
}
