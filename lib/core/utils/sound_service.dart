import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'sound_service_stub.dart'
    if (dart.library.js_interop) 'sound_service_web.dart' as platform_sound;

class SoundService {
  static bool isMuted = true; // Default muted as requested

  static bool toggleMute() {
    isMuted = !isMuted;
    if (!isMuted) {
      if (kIsWeb) {
        platform_sound.playWebUnmuteFeedback();
      } else {
        HapticFeedback.mediumImpact();
        SystemSound.play(SystemSoundType.click);
      }
    }
    return isMuted;
  }

  static void playEmergencySiren() {
    // 1. Always play Heavy Haptic Vibration
    HapticFeedback.heavyImpact();

    // If muted, do not play audible siren
    if (isMuted) return;

    // 2. Play System Alert Sound
    SystemSound.play(SystemSoundType.alert);

    // 3. On Web: Use high-fidelity Web Audio API synth siren ringtone
    if (kIsWeb) {
      platform_sound.playWebSynthSiren();
    }
  }
}
