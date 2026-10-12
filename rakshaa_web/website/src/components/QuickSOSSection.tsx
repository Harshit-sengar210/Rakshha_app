"use client";

import React, { useState } from "react";
import { motion } from "framer-motion";
import { Zap, Check, AlertCircle, Shield, ArrowRight, ToggleRight, Sparkles } from "lucide-react";

export function QuickSOSSection() {
  const [enabled, setEnabled] = useState(true);

  return (
    <section id="quick-sos" className="py-20 sm:py-28 bg-[#FFF5F5] relative overflow-hidden border-y border-[#F3E4E6]">
      {/* Soft Glow */}
      <div className="absolute top-1/2 left-0 w-96 h-96 bg-[#FFE7EC] rounded-full blur-3xl opacity-80 pointer-events-none -z-0" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-16 items-center">
          {/* Left Column: Interactive Phone Mockup with Quick SOS Settings */}
          <motion.div
            initial={{ opacity: 0, x: -30 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6 }}
            className="lg:col-span-5 flex justify-center"
          >
            <div className="relative">
              {/* Subtle Breathing Coral Pulse */}
              <div className="absolute -inset-4 bg-gradient-to-r from-[#F04455]/20 to-[#FFCCD4]/30 rounded-[50px] blur-xl opacity-70 animate-pulse pointer-events-none" />

              {/* Phone Device Frame */}
              <div className="relative w-[280px] sm:w-[310px] h-[550px] bg-[#0F172A] rounded-[44px] p-3 shadow-2xl border-4 border-[#334155]">
                <div className="w-full h-full bg-white rounded-[34px] overflow-hidden flex flex-col justify-between border border-gray-100">
                  {/* Dynamic Island */}
                  <div className="pt-2 flex justify-center">
                    <div className="w-24 h-4 bg-[#0F172A] rounded-full flex items-center justify-center">
                      <div className="w-2 h-2 rounded-full bg-amber-400 mr-2" />
                      <div className="w-1.5 h-1.5 rounded-full bg-blue-400" />
                    </div>
                  </div>

                  {/* Header */}
                  <div className="px-5 pt-4 pb-2 border-b border-gray-100">
                    <div className="flex items-center gap-2">
                      <div className="w-7 h-7 rounded-lg bg-[#FFE7EC] text-[#F04455] flex items-center justify-center">
                        <Zap className="w-4 h-4" />
                      </div>
                      <span className="text-xs font-bold uppercase tracking-wider text-[#18243A]">
                        Safety Settings
                      </span>
                    </div>
                    <h4 className="text-base font-extrabold text-[#18243A] mt-1">
                      Quick SOS Mode
                    </h4>
                  </div>

                  {/* Mockup Settings Body */}
                  <div className="px-5 py-4 flex-1 space-y-4">
                    {/* Toggle Card */}
                    <div className="bg-[#FFF8F8] border border-[#F3E4E6] rounded-2xl p-4">
                      <div className="flex items-center justify-between">
                        <div>
                          <div className="text-xs font-bold text-[#18243A]">Enable Quick SOS</div>
                          <div className="text-[10px] text-[#707786]">Auto-start on app open</div>
                        </div>
                        <button
                          onClick={() => setEnabled(!enabled)}
                          className={`w-12 h-6 flex items-center rounded-full p-1 transition-colors duration-200 ${
                            enabled ? "bg-[#F04455] justify-end" : "bg-gray-300 justify-start"
                          }`}
                        >
                          <motion.div
                            layout
                            className="bg-white w-4 h-4 rounded-full shadow-md"
                          />
                        </button>
                      </div>
                    </div>

                    {/* Behavior Explanation in App */}
                    <div className="space-y-2.5">
                      <span className="text-[10px] font-bold text-[#707786] uppercase tracking-wider">
                        How it executes:
                      </span>
                      <div className="flex items-start gap-2 text-xs text-[#18243A]">
                        <div className="w-4 h-4 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center text-[10px] font-bold shrink-0 mt-0.5">
                          ✓
                        </div>
                        <span>Checks saved preference on launch</span>
                      </div>
                      <div className="flex items-start gap-2 text-xs text-[#18243A]">
                        <div className="w-4 h-4 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center text-[10px] font-bold shrink-0 mt-0.5">
                          ✓
                        </div>
                        <span>Triggers SOS without pressing center button</span>
                      </div>
                      <div className="flex items-start gap-2 text-xs text-[#18243A]">
                        <div className="w-4 h-4 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center text-[10px] font-bold shrink-0 mt-0.5">
                          ✓
                        </div>
                        <span>Dispatches WhatsApp alerts to contacts</span>
                      </div>
                    </div>

                    {/* Safety Confirmation Badge */}
                    <div className="p-3 bg-amber-50 rounded-xl border border-amber-200/80 text-[10px] text-amber-900 leading-tight">
                      <strong>Note:</strong> Requires Location permission set to Always or While in Use.
                    </div>
                  </div>

                  {/* Bottom App Navigation */}
                  <div className="p-4 bg-gray-50 border-t border-gray-100 text-center">
                    <span className="text-[10px] font-bold text-[#F04455]">
                      Preference Saved Locally in Encrypted Storage
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </motion.div>

          {/* Right Column: Headline, Explanation, 3 Steps & Notice */}
          <motion.div
            initial={{ opacity: 0, x: 30 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6 }}
            className="lg:col-span-7 flex flex-col items-start"
          >
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#FFE7EC] border border-[#F3E4E6] text-xs font-bold text-[#F04455] uppercase tracking-wider mb-4">
              <Zap className="w-3.5 h-3.5" />
              <span>Instant Safety Activation</span>
            </div>

            <h2 className="text-3xl sm:text-4xl font-extrabold text-[#18243A] tracking-tight">
              A Faster Way to Start Your Safety Flow.
            </h2>

            <p className="mt-4 text-base sm:text-lg text-[#707786] leading-relaxed">
              When seconds count, Quick SOS reduces friction by immediately initiating your
              configured emergency session as soon as you tap the Rakshaa app icon on your home
              screen.
            </p>

            {/* 3 Step List */}
            <div className="mt-8 space-y-4 w-full">
              <div className="flex items-start gap-4 p-4 rounded-2xl bg-white border border-[#F3E4E6] shadow-sm">
                <div className="w-8 h-8 rounded-xl bg-[#F04455] text-white flex items-center justify-center text-sm font-bold shrink-0">
                  1
                </div>
                <div>
                  <h4 className="text-sm font-bold text-[#18243A]">Enable Quick SOS inside Rakshaa</h4>
                  <p className="text-xs text-[#707786] mt-0.5">
                    Toggle on Quick SOS mode in your app settings according to your daily commute habits.
                  </p>
                </div>
              </div>

              <div className="flex items-start gap-4 p-4 rounded-2xl bg-white border border-[#F3E4E6] shadow-sm">
                <div className="w-8 h-8 rounded-xl bg-[#18243A] text-white flex items-center justify-center text-sm font-bold shrink-0">
                  2
                </div>
                <div>
                  <h4 className="text-sm font-bold text-[#18243A]">Review Permissions and Activate</h4>
                  <p className="text-xs text-[#707786] mt-0.5">
                    Confirm that location access is granted so GPS coordinates can be acquired immediately on launch.
                  </p>
                </div>
              </div>

              <div className="flex items-start gap-4 p-4 rounded-2xl bg-white border border-[#F3E4E6] shadow-sm">
                <div className="w-8 h-8 rounded-xl bg-[#F04455] text-white flex items-center justify-center text-sm font-bold shrink-0">
                  3
                </div>
                <div>
                  <h4 className="text-sm font-bold text-[#18243A]">Instant Emergency Execution on Launch</h4>
                  <p className="text-xs text-[#707786] mt-0.5">
                    The next time you open Rakshaa, the app checks the saved setting and starts the emergency flow without delay.
                  </p>
                </div>
              </div>
            </div>

            {/* Mandatory OS Notice Box */}
            <div className="mt-6 p-4 rounded-2xl bg-white border-l-4 border-l-[#F04455] border-y border-r border-[#F3E4E6] shadow-sm">
              <div className="flex items-start gap-3">
                <AlertCircle className="w-5 h-5 text-[#F04455] shrink-0 mt-0.5" />
                <p className="text-xs text-[#707786] leading-relaxed">
                  <strong className="text-[#18243A]">Important OS Notice:</strong> Quick SOS works after
                  Rakshaa launches and checks your settings and permissions. It does not bypass
                  operating-system permissions or automatically trigger from an unopened app.
                </p>
              </div>
            </div>

            {/* CTA */}
            <div className="mt-8">
              <a
                href="#download"
                className="inline-flex items-center gap-2 px-6 py-3 text-sm font-bold text-white bg-[#F04455] hover:bg-[#D93647] rounded-xl shadow-coral-subtle transition-all duration-200"
              >
                <span>Download to Try Quick SOS</span>
                <ArrowRight className="w-4 h-4" />
              </a>
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  );
}
