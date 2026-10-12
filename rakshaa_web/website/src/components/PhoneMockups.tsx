"use client";

import React, { useState } from "react";
import Image from "next/image";
import { motion } from "framer-motion";
import {
  Shield,
  MapPin,
  Phone,
  Radio,
  Users,
  AlertTriangle,
  Clock,
  Compass,
  CheckCircle2,
  Heart,
  Navigation,
  ShieldCheck,
} from "lucide-react";

export function PhoneMockups() {
  const [activeTab, setActiveTab] = useState<"home" | "location" | "emergency">("home");

  return (
    <div className="relative w-full max-w-2xl mx-auto lg:max-w-none flex flex-col items-center select-none">
      {/* Interactive switcher chips for quick previewing */}
      <div className="flex items-center gap-2 p-1.5 bg-white/90 backdrop-blur-md rounded-2xl border border-[#F3E4E6] shadow-sm mb-6 z-20">
        <button
          onClick={() => setActiveTab("home")}
          className={`px-3.5 py-1.5 text-xs font-semibold rounded-xl transition-all duration-200 ${
            activeTab === "home"
              ? "bg-[#18243A] text-white shadow-sm"
              : "text-[#707786] hover:text-[#18243A] hover:bg-gray-100/60"
          }`}
        >
          01. Home & SOS
        </button>
        <button
          onClick={() => setActiveTab("emergency")}
          className={`px-3.5 py-1.5 text-xs font-semibold rounded-xl transition-all duration-200 ${
            activeTab === "emergency"
              ? "bg-[#F04455] text-white shadow-coral-subtle"
              : "text-[#707786] hover:text-[#F04455] hover:bg-[#FFE7EC]/60"
          }`}
        >
          02. Emergency Active
        </button>
        <button
          onClick={() => setActiveTab("location")}
          className={`px-3.5 py-1.5 text-xs font-semibold rounded-xl transition-all duration-200 ${
            activeTab === "location"
              ? "bg-[#18243A] text-white shadow-sm"
              : "text-[#707786] hover:text-[#18243A] hover:bg-gray-100/60"
          }`}
        >
          03. Live Location
        </button>
      </div>

      {/* Decorative Glow Elements */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[340px] sm:w-[460px] h-[340px] sm:h-[460px] bg-gradient-to-tr from-[#FFE7EC] to-[#FFCCD4] rounded-full blur-3xl opacity-70 pointer-events-none -z-10" />

      {/* Mockups Container */}
      <div className="relative w-full h-[540px] sm:h-[620px] flex items-center justify-center">
        {/* ============================================================== */}
        {/* PHONE 1: HOME & SOS SCREEN (Left Back Layer) */}
        {/* ============================================================== */}
        <motion.div
          animate={{
            scale: activeTab === "home" ? 1 : 0.88,
            x: activeTab === "home" ? 0 : -80,
            y: activeTab === "home" ? 0 : 20,
            zIndex: activeTab === "home" ? 30 : 10,
            rotate: activeTab === "home" ? 0 : -8,
            opacity: activeTab === "home" ? 1 : 0.75,
          }}
          transition={{ type: "spring", stiffness: 220, damping: 25 }}
          className="absolute w-[270px] sm:w-[290px] h-[520px] sm:h-[560px] bg-[#0F172A] rounded-[42px] p-2.5 shadow-2xl border-4 border-[#334155] cursor-pointer"
          onClick={() => setActiveTab("home")}
        >
          {/* Outer Bezel & Screen */}
          <div className="relative w-full h-full bg-[#FFFDFD] rounded-[34px] overflow-hidden flex flex-col justify-between border border-gray-100">
            {/* Dynamic Island / Notch */}
            <div className="absolute top-2 left-1/2 -translate-x-1/2 w-24 h-4 bg-[#0F172A] rounded-full z-20 flex items-center justify-center">
              <div className="w-2 h-2 rounded-full bg-[#1E293B] mr-2" />
              <div className="w-1.5 h-1.5 rounded-full bg-[#0284C7]" />
            </div>

            {/* Screen Header */}
            <div className="pt-8 px-4 pb-2 bg-gradient-to-b from-[#FFE7EC]/60 to-transparent">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="w-7 h-7 rounded-lg bg-[#F04455] flex items-center justify-center text-white p-1">
                    <Shield className="w-4 h-4" />
                  </div>
                  <div>
                    <div className="text-[10px] uppercase font-bold tracking-wider text-[#707786]">Rakshaa App</div>
                    <div className="text-xs font-extrabold text-[#18243A]">You&apos;re not alone.</div>
                  </div>
                </div>
                <div className="px-2 py-0.5 rounded-full bg-emerald-50 border border-emerald-200 text-[10px] font-bold text-emerald-600 flex items-center gap-1">
                  <div className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse" />
                  Protected
                </div>
              </div>
            </div>

            {/* Center Content: SOS Button */}
            <div className="flex-1 flex flex-col items-center justify-center px-4">
              <div className="relative flex items-center justify-center">
                {/* Outer Breathing Rings */}
                <div className="absolute w-44 h-44 rounded-full bg-[#F04455]/15 animate-ping opacity-60" />
                <div className="absolute w-36 h-36 rounded-full bg-[#FFE7EC] animate-pulse" />

                {/* Primary SOS Button */}
                <div className="relative w-28 h-28 rounded-full bg-gradient-to-tr from-[#D93647] via-[#F04455] to-[#FF6B7A] p-1 shadow-coral-glow flex items-center justify-center text-white text-center cursor-pointer transform hover:scale-105 transition-transform">
                  <div className="flex flex-col items-center justify-center">
                    <span className="text-2xl font-black tracking-widest">SOS</span>
                    <span className="text-[9px] uppercase tracking-wider font-semibold opacity-90">Tap to Alert</span>
                  </div>
                </div>
              </div>

              {/* Status Hint */}
              <p className="mt-4 text-[11px] text-[#707786] text-center max-w-[200px]">
                One tap initiates alerts to priority contacts and live location sharing.
              </p>

              {/* Priority Contact Preview Pill */}
              <div className="mt-3 w-full bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl p-2 flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="w-6 h-6 rounded-full bg-[#FFE7EC] text-[#F04455] flex items-center justify-center text-[10px] font-bold">
                    P
                  </div>
                  <div className="text-left">
                    <div className="text-[10px] font-bold text-[#18243A]">Priority Contact</div>
                    <div className="text-[9px] text-[#707786]">Instant WhatsApp & Call</div>
                  </div>
                </div>
                <div className="text-[9px] font-bold text-[#F04455] bg-white px-2 py-0.5 rounded-md border border-[#F3E4E6]">
                  Active
                </div>
              </div>
            </div>

            {/* Bottom Quick Call & Navigation */}
            <div className="p-3 bg-white border-t border-gray-100">
              <div className="flex items-center gap-2 mb-2">
                <div className="flex-1 bg-[#18243A] text-white rounded-xl py-1.5 px-3 flex items-center justify-center gap-1.5 text-xs font-semibold">
                  <Phone className="w-3.5 h-3.5 text-amber-400" />
                  <span>Call 112</span>
                </div>
                <div className="flex-1 bg-[#FFE7EC] text-[#F04455] rounded-xl py-1.5 px-3 flex items-center justify-center gap-1.5 text-xs font-semibold">
                  <Users className="w-3.5 h-3.5" />
                  <span>3 Contacts</span>
                </div>
              </div>
              <div className="flex justify-around text-[10px] text-gray-400 pt-1 border-t border-gray-50">
                <span className="text-[#F04455] font-bold">● Home</span>
                <span>History</span>
                <span>Contacts</span>
                <span>Profile</span>
              </div>
            </div>
          </div>
        </motion.div>

        {/* ============================================================== */}
        {/* PHONE 2: EMERGENCY ACTIVE SCREEN (Center/Focus Layer) */}
        {/* ============================================================== */}
        <motion.div
          animate={{
            scale: activeTab === "emergency" ? 1 : 0.88,
            x: activeTab === "emergency" ? 0 : activeTab === "home" ? 70 : -70,
            y: activeTab === "emergency" ? 0 : 20,
            zIndex: activeTab === "emergency" ? 30 : 20,
            rotate: activeTab === "emergency" ? 0 : activeTab === "home" ? 6 : -6,
            opacity: activeTab === "emergency" ? 1 : 0.8,
          }}
          transition={{ type: "spring", stiffness: 220, damping: 25 }}
          className="absolute w-[270px] sm:w-[290px] h-[520px] sm:h-[560px] bg-[#0F172A] rounded-[42px] p-2.5 shadow-2xl border-4 border-[#F04455]/80 cursor-pointer"
          onClick={() => setActiveTab("emergency")}
        >
          {/* Emergency Active Screen Content */}
          <div className="relative w-full h-full bg-gradient-to-b from-[#2B0E14] via-[#1A0A0E] to-[#12070A] text-white rounded-[34px] overflow-hidden flex flex-col justify-between">
            {/* Dynamic Island */}
            <div className="absolute top-2 left-1/2 -translate-x-1/2 w-24 h-4 bg-[#0F172A] rounded-full z-20 flex items-center justify-center">
              <div className="w-2 h-2 rounded-full bg-[#EF4444] animate-ping mr-2" />
              <div className="w-1.5 h-1.5 rounded-full bg-red-400" />
            </div>

            {/* Header */}
            <div className="pt-8 px-4 pb-2">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-1.5 bg-[#F04455]/20 border border-[#F04455]/40 px-2.5 py-1 rounded-full">
                  <Radio className="w-3 h-3 text-[#F04455] animate-pulse" />
                  <span className="text-[10px] font-extrabold uppercase text-[#FF7582] tracking-wider">
                    Emergency Active
                  </span>
                </div>
                <div className="text-right">
                  <div className="text-[9px] uppercase tracking-widest text-gray-400">Elapsed</div>
                  <div className="text-xs font-mono font-bold text-white">02:45</div>
                </div>
              </div>
            </div>

            {/* Emergency Radar Animation & Status */}
            <div className="flex-1 flex flex-col items-center justify-center px-4">
              <div className="relative w-28 h-28 rounded-full border border-[#F04455]/30 flex items-center justify-center bg-[#F04455]/10">
                <div className="absolute inset-2 rounded-full border border-[#F04455]/40 animate-ping opacity-30" />
                <div className="w-16 h-16 rounded-full bg-[#F04455] shadow-coral-glow flex items-center justify-center">
                  <AlertTriangle className="w-8 h-8 text-white animate-bounce" />
                </div>
              </div>

              <div className="mt-3 text-center">
                <div className="text-sm font-black text-white">SOS Signal Dispatched</div>
                <div className="text-[10px] text-gray-300 mt-0.5">Live GPS & WhatsApp Alert Active</div>
              </div>

              {/* Progress Checklist */}
              <div className="mt-3 w-full bg-black/40 border border-white/10 rounded-xl p-2.5 space-y-1.5">
                <div className="flex items-center justify-between text-[10px]">
                  <span className="text-gray-300 flex items-center gap-1">
                    <CheckCircle2 className="w-3 h-3 text-emerald-400" /> WhatsApp Alert
                  </span>
                  <span className="text-emerald-400 font-bold">Sent (3/3)</span>
                </div>
                <div className="flex items-center justify-between text-[10px]">
                  <span className="text-gray-300 flex items-center gap-1">
                    <CheckCircle2 className="w-3 h-3 text-emerald-400" /> GPS Coordinates
                  </span>
                  <span className="text-emerald-400 font-bold">Live Stream</span>
                </div>
                <div className="flex items-center justify-between text-[10px]">
                  <span className="text-gray-300 flex items-center gap-1">
                    <CheckCircle2 className="w-3 h-3 text-emerald-400" /> Police Station 112
                  </span>
                  <span className="text-amber-400 font-bold">Quick Dial</span>
                </div>
              </div>
            </div>

            {/* Emergency Actions Footer */}
            <div className="p-3 bg-black/60 border-t border-white/10 space-y-2">
              <div className="w-full bg-[#18243A] hover:bg-[#233555] text-white rounded-xl py-2 flex items-center justify-center gap-2 text-xs font-bold border border-white/15">
                <Phone className="w-3.5 h-3.5 text-amber-400" />
                <span>Call Priority Contact</span>
              </div>
              <div className="w-full bg-red-950/80 hover:bg-red-900 border border-red-800 text-red-200 rounded-xl py-2 text-center text-xs font-semibold">
                Hold 3s to Stop Emergency
              </div>
            </div>
          </div>
        </motion.div>

        {/* ============================================================== */}
        {/* PHONE 3: LIVE LOCATION SCREEN (Right Back Layer) */}
        {/* ============================================================== */}
        <motion.div
          animate={{
            scale: activeTab === "location" ? 1 : 0.88,
            x: activeTab === "location" ? 0 : 80,
            y: activeTab === "location" ? 0 : 20,
            zIndex: activeTab === "location" ? 30 : 15,
            rotate: activeTab === "location" ? 0 : 8,
            opacity: activeTab === "location" ? 1 : 0.75,
          }}
          transition={{ type: "spring", stiffness: 220, damping: 25 }}
          className="absolute w-[270px] sm:w-[290px] h-[520px] sm:h-[560px] bg-[#0F172A] rounded-[42px] p-2.5 shadow-2xl border-4 border-[#334155] cursor-pointer"
          onClick={() => setActiveTab("location")}
        >
          {/* Map & Live Sharing Screen */}
          <div className="relative w-full h-full bg-[#0F172A] rounded-[34px] overflow-hidden flex flex-col justify-between">
            {/* Dynamic Island */}
            <div className="absolute top-2 left-1/2 -translate-x-1/2 w-24 h-4 bg-[#0F172A] rounded-full z-20 flex items-center justify-center">
              <div className="w-2 h-2 rounded-full bg-[#10B981] mr-2" />
              <div className="w-1.5 h-1.5 rounded-full bg-blue-400" />
            </div>

            {/* Stylized OpenStreetMap simulation */}
            <div className="absolute inset-0 bg-[#1E293B] opacity-90 overflow-hidden">
              {/* Grid Roads */}
              <div className="absolute inset-0 bg-[radial-gradient(#334155_1px,transparent_1px)] [background-size:16px_16px] opacity-40" />
              <div className="absolute top-1/4 left-0 right-0 h-4 bg-slate-700/60 -rotate-12" />
              <div className="absolute top-0 bottom-0 left-1/3 w-5 bg-slate-700/60 rotate-6" />
              <div className="absolute bottom-1/3 left-0 right-0 h-6 bg-slate-700/50 rotate-3" />

              {/* Pulsing Location Pin */}
              <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 flex items-center justify-center">
                <div className="w-20 h-20 rounded-full bg-[#F04455]/20 animate-ping" />
                <div className="absolute w-12 h-12 rounded-full bg-[#F04455]/30 animate-pulse" />
                <div className="absolute w-7 h-7 rounded-full bg-[#F04455] border-2 border-white shadow-lg flex items-center justify-center">
                  <Navigation className="w-3.5 h-3.5 text-white" />
                </div>
              </div>
            </div>

            {/* Top Bar Floating Status */}
            <div className="relative z-10 pt-8 px-4">
              <div className="bg-slate-900/90 backdrop-blur-md border border-slate-700 p-2 rounded-2xl flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
                  <span className="text-[10px] font-bold text-white">Live Sharing Active</span>
                </div>
                <span className="text-[9px] font-mono text-emerald-400">GPS High Acc.</span>
              </div>
            </div>

            {/* Bottom Card */}
            <div className="relative z-10 p-3 bg-slate-900/95 backdrop-blur-md border-t border-slate-700 rounded-b-[34px] space-y-2">
              <div className="flex items-start gap-2">
                <MapPin className="w-4 h-4 text-[#F04455] shrink-0 mt-0.5" />
                <div className="text-left">
                  <div className="text-[11px] font-bold text-white">Connaught Place, New Delhi</div>
                  <div className="text-[9px] text-slate-400 font-mono">28.6139° N, 77.2090° E</div>
                </div>
              </div>

              <div className="bg-slate-800/80 p-2 rounded-xl flex items-center justify-between text-[10px]">
                <span className="text-slate-300">Authorized Contacts</span>
                <span className="text-emerald-400 font-bold">3 Viewing</span>
              </div>

              <div className="text-[9px] text-slate-400 text-center flex items-center justify-center gap-1">
                <ShieldCheck className="w-3 h-3 text-emerald-400" />
                <span>Privacy: Location active only in emergency</span>
              </div>
            </div>
          </div>
        </motion.div>
      </div>

      {/* Floating Reassurance Badges */}
      <div className="hidden sm:flex items-center justify-center gap-4 mt-6 text-xs text-[#707786]">
        <div className="flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-white border border-[#F3E4E6] shadow-sm">
          <ShieldCheck className="w-4 h-4 text-[#F04455]" />
          <span>Real-time GPS Tracking</span>
        </div>
        <div className="flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-white border border-[#F3E4E6] shadow-sm">
          <CheckCircle2 className="w-4 h-4 text-emerald-500" />
          <span>Instant WhatsApp Dispatch</span>
        </div>
        <div className="flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-white border border-[#F3E4E6] shadow-sm">
          <Phone className="w-4 h-4 text-[#18243A]" />
          <span>Direct 112 Access</span>
        </div>
      </div>
    </div>
  );
}
