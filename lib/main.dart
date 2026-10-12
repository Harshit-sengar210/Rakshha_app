import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_page.dart';
import 'features/emergency/presentation/emergency_active_page.dart';
import 'features/contacts/presentation/contacts_page.dart';
import 'features/history/presentation/history_page.dart';
import 'features/history/presentation/emergency_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/signup_page.dart';
import 'features/auth/presentation/otp_page.dart';
import 'features/auth/presentation/priority_contact_page.dart';
import 'features/auth/presentation/trusted_contacts_page.dart';
import 'features/auth/presentation/registration_review_page.dart';
import 'features/auth/presentation/registration_success_page.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/profile/presentation/profile_page.dart';
import 'features/profile/presentation/personal_details_page.dart';
import 'core/services/app_location_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyBH6HfRw91-a7-vC7HPhrgTlvBdKPDDkno',
          appId: '1:753549661698:web:9ed3d0feae07800014b91b', // Derived from android app id
          messagingSenderId: '753549661698',
          projectId: 'rakshha-16',
          storageBucket: 'rakshha-16.firebasestorage.app',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }

  // Pre-warm device location cache immediately (0ms hardware check)
  AppLocationService.initializeLocation();

  runApp(const ProviderScope(child: RakshaaApp()));
}

CustomTransitionPage _buildPageTransition(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        ),
      );
    },
  );
}

final _router = GoRouter(
  initialLocation: FirebaseAuth.instance.currentUser != null ? '/home' : '/login',
  routes: [
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const LoginPage(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) => _buildPageTransition(const SignupPage()),
    ),
    GoRoute(
      path: '/otp',
      pageBuilder: (context, state) => _buildPageTransition(const OtpPage()),
    ),
    GoRoute(
      path: '/priority_contact',
      pageBuilder: (context, state) => _buildPageTransition(const PriorityContactPage()),
    ),
    GoRoute(
      path: '/trusted_contacts',
      pageBuilder: (context, state) => _buildPageTransition(const TrustedContactsPage()),
    ),
    GoRoute(
      path: '/registration_review',
      pageBuilder: (context, state) => _buildPageTransition(const RegistrationReviewPage()),
    ),
    GoRoute(
      path: '/registration_success',
      pageBuilder: (context, state) => _buildPageTransition(const RegistrationSuccessPage()),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const HomePage(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const ProfilePage(),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
      ),
    ),
    GoRoute(
      path: '/personal_details',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const PersonalDetailsPage(),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
      ),
    ),
    GoRoute(
      path: '/registration_success',
      pageBuilder: (context, state) => _buildPageTransition(const RegistrationSuccessPage()),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const HomePage(),
        transitionDuration: const Duration(milliseconds: 150),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: '/history',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const HistoryPage(),
        transitionDuration: const Duration(milliseconds: 150),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: '/history/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return CustomTransitionPage(
          child: EmergencyDetailsPage(id: id),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/contacts',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const ContactsPage(),
        transitionDuration: const Duration(milliseconds: 150),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: '/emergency/active',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: const EmergencyActivePage(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // A circular radial expansion effect would ideally use a custom clipper
            // but a fade + scale is a solid built-in alternative for the prototype
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              ),
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/emergency/resolved',
      builder: (context, state) => const _PlaceholderPage(title: "Emergency Resolved"),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const ProfilePage(),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
      ),
    ),
  ],
);

class RakshaaApp extends StatelessWidget {
  const RakshaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rakshaa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Rakshaa",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "$title Coming soon",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text("Go Back"),
            ),
          ],
        ),
      ),
    );
  }
}
