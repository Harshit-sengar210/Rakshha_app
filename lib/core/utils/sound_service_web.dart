import 'dart:js_interop' as js_interop;

@js_interop.JS('eval')
external js_interop.JSAny? _jsEval(String code);

void playWebSynthSiren() {
  try {
    _jsEval('''
      (function() {
        try {
          var AudioCtx = window.AudioContext || window.webkitAudioContext;
          if (!AudioCtx) return;
          var ctx = new AudioCtx();
          if (ctx.state === 'suspended') {
            ctx.resume();
          }
          var now = ctx.currentTime;
          
          // Oscillator 1: High-pitched alarm warble
          var osc = ctx.createOscillator();
          var gain = ctx.createGain();
          
          osc.type = 'sawtooth';
          
          // Emergency warble sweep: 850Hz -> 1350Hz -> 850Hz -> 1350Hz -> 850Hz
          osc.frequency.setValueAtTime(850, now);
          osc.frequency.linearRampToValueAtTime(1350, now + 0.12);
          osc.frequency.linearRampToValueAtTime(850, now + 0.24);
          osc.frequency.linearRampToValueAtTime(1350, now + 0.36);
          osc.frequency.linearRampToValueAtTime(850, now + 0.48);
          osc.frequency.linearRampToValueAtTime(1350, now + 0.60);
          osc.frequency.linearRampToValueAtTime(850, now + 0.72);

          gain.gain.setValueAtTime(0.4, now);
          gain.gain.setValueAtTime(0.4, now + 0.65);
          gain.gain.exponentialRampToValueAtTime(0.001, now + 0.85);

          osc.connect(gain);
          gain.connect(ctx.destination);

          osc.start(now);
          osc.stop(now + 0.85);

          // Oscillator 2: Bass warning pulse
          var subOsc = ctx.createOscillator();
          var subGain = ctx.createGain();
          subOsc.type = 'sine';
          subOsc.frequency.setValueAtTime(220, now);
          subOsc.frequency.linearRampToValueAtTime(440, now + 0.4);
          subGain.gain.setValueAtTime(0.3, now);
          subGain.gain.exponentialRampToValueAtTime(0.001, now + 0.85);
          subOsc.connect(subGain);
          subGain.connect(ctx.destination);
          subOsc.start(now);
          subOsc.stop(now + 0.85);
        } catch(e) {
          console.error('Audio playback error:', e);
        }
      })()
    ''');
  } catch (_) {}
}

void playWebUnmuteFeedback() {
  try {
    _jsEval('''
      (function() {
        try {
          var AudioCtx = window.AudioContext || window.webkitAudioContext;
          if (!AudioCtx) return;
          var ctx = new AudioCtx();
          if (ctx.state === 'suspended') ctx.resume();
          var now = ctx.currentTime;
          var osc = ctx.createOscillator();
          var gain = ctx.createGain();
          osc.type = 'sine';
          osc.frequency.setValueAtTime(587.33, now); // D5
          osc.frequency.setValueAtTime(880.00, now + 0.08); // A5
          gain.gain.setValueAtTime(0.15, now);
          gain.gain.exponentialRampToValueAtTime(0.001, now + 0.25);
          osc.connect(gain);
          gain.connect(ctx.destination);
          osc.start(now);
          osc.stop(now + 0.25);
        } catch(e) {}
      })()
    ''');
  } catch (_) {}
}
