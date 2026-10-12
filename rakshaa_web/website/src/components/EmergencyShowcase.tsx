"use client";

import React from "react";
import { motion } from "framer-motion";
import {
  AlertTriangle,
  Radio,
  Clock,
  Phone,
  CheckCircle2,
  Shield,
  Send,
  MapPin,
  Flame,
  ArrowRight,
} from "lucide-react";

export function EmergencyShowcase() {
  const timelineSteps = [
    {
      step: "01",
      title: "Emergency Mode Initiated",
      status: "Triggered",
      desc: "SOS is activated via one-tap press or Quick SOS on app launch. Haptic feedback confirms the signal.",
      statusColor: "text-[#F04455] bg-[#FFE7EC]",
    },
    {
      step: "02",
      title: "Location Permission & GPS Fix Acquired",
      status: "Verified",
      desc: "Device GPS queries high-precision coordinates and performs reverse geocoding to obtain street address.",
      statusColor: "text-emerald-700 bg-emerald-50",
    },
    {
      step: "03",
      title: "Emergency Session Created",
      status: "Synced",
      desc: "A secure incident record with unique session ID is created and synced to the Rakshaa cloud infrastructure.",
      statusColor: "text-blue-700 bg-blue-50",
    },
    {
      step: "04",
      title: "Contacts & Notification Channels Processed",
      status: "Dispatched",
      desc: "Automated WhatsApp messages containing live Google Maps location and details are sent to priority contacts.",
      statusColor: "text-purple-700 bg-purple-50",
    },
    {
      step: "05",
      title: "Available Alert Delivery Status Displayed",
      status: "Active Tracking",
      desc: "Real-time delivery progress appears on screen. Direct dial shortcuts for 112 helpline remain accessible.",
      statusColor: "text-[#18243A] bg-gray-100",
    },
  ];

  return (
    <section className="py-20 sm:py-28 bg-[#18243A] text-white relative overflow-hidden">
      {/* Background radial accent glow */}
      <div className="absolute top-1/2 left-1/3 -translate-y-1/2 w-[500px] h-[500px] bg-[#F04455]/20 rounded-full blur-3xl pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        {/* Header */}
        <div className="max-w-3xl mx-auto text-center mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/10 border border-white/20 text-xs font-bold text-[#FF7582] uppercase tracking-wider mb-4">
            <Radio className="w-3.5 h-3.5 animate-pulse text-[#F04455]" />
            <span>Real-time Response Lifecycle</span>
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black tracking-tight text-white">
            Stay Informed When Every Moment Matters.
          </h2>
          <p className="mt-4 text-base sm:text-lg text-slate-300">
            A transparent breakdown of how Rakshaa orchestrates alerts, captures location, and
            updates your safety circle during an active incident.
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center">
          {/* Left Column: Real-time Emergency Screen Simulation */}
          <div className="lg:col-span-5 flex justify-center">
            <div className="w-[300px] sm:w-[320px] bg-[#0A101D] border-4 border-[#2B3B5C] rounded-[44px] p-3 shadow-2xl">
              <div className="w-full bg-gradient-to-b from-[#2A0E14] to-[#12070A] rounded-[34px] p-5 text-white flex flex-col justify-between border border-red-900/40">
                {/* Header */}
                <div className="flex items-center justify-between mb-4">
                  <div className="flex items-center gap-1.5 bg-red-600/30 border border-red-500/50 px-2.5 py-1 rounded-full">
                    <span className="w-2 h-2 rounded-full bg-red-500 animate-ping" />
                    <span className="text-[10px] font-black uppercase text-red-200">ACTIVE SOS</span>
                  </div>
                  <div className="text-right">
                    <div className="text-[9px] text-gray-400">Duration</div>
                    <div className="text-xs font-mono font-bold text-white">01:42</div>
                  </div>
                </div>

                {/* Radar Icon */}
                <div className="flex flex-col items-center justify-center my-4">
                  <div className="relative w-24 h-24 rounded-full border border-red-500/30 flex items-center justify-center bg-red-500/10">
                    <div className="absolute inset-1 rounded-full border border-red-400/40 animate-ping opacity-30" />
                    <div className="w-14 h-14 rounded-full bg-[#F04455] flex items-center justify-center shadow-lg">
                      <AlertTriangle className="w-7 h-7 text-white" />
                    </div>
                  </div>
                  <div className="text-sm font-extrabold mt-3 text-white">Emergency Active</div>
                  <div className="text-[11px] text-red-300 text-center mt-0.5">
                    Live GPS Stream & WhatsApp Dispatched
                  </div>
                </div>

                {/* Recipient Cards */}
                <div className="space-y-2 mb-4">
                  <div className="bg-white/5 border border-white/10 rounded-xl p-2.5 flex items-center justify-between text-xs">
                    <div className="flex items-center gap-2">
                      <div className="w-6 h-6 rounded-full bg-red-500/20 text-red-400 flex items-center justify-center text-[10px] font-bold">
                        1
                      </div>
                      <div>
                        <div className="font-bold text-white text-[11px]">Priority: Mom</div>
                        <div className="text-[9px] text-slate-400">WhatsApp Alert Dispatched</div>
                      </div>
                    </div>
                    <span className="text-[10px] font-bold text-emerald-400">Sent ✓</span>
                  </div>

                  <div className="bg-white/5 border border-white/10 rounded-xl p-2.5 flex items-center justify-between text-xs">
                    <div className="flex items-center gap-2">
                      <div className="w-6 h-6 rounded-full bg-red-500/20 text-red-400 flex items-center justify-center text-[10px] font-bold">
                        2
                      </div>
                      <div>
                        <div className="font-bold text-white text-[11px]">Trusted: Sister</div>
                        <div className="text-[9px] text-slate-400">Live Maps Link Attached</div>
                      </div>
                    </div>
                    <span className="text-[10px] font-bold text-emerald-400">Sent ✓</span>
                  </div>
                </div>

                {/* Emergency Dialing */}
                <div className="space-y-2">
                  <div className="w-full bg-[#18243A] text-white py-2 rounded-xl text-center text-xs font-bold border border-white/20 flex items-center justify-center gap-1.5">
                    <Phone className="w-3.5 h-3.5 text-amber-400" />
                    <span>Dial Helpline 112</span>
                  </div>
                  <div className="w-full bg-red-950/70 border border-red-800 text-red-300 py-1.5 rounded-xl text-center text-[10px] font-semibold">
                    Hold 3 Seconds to End Emergency
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Right Column: 5-Stage Incident Timeline */}
          <div className="lg:col-span-7 space-y-4">
            {timelineSteps.map((item, idx) => (
              <motion.div
                key={idx}
                initial={{ opacity: 0, x: 20 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.4, delay: idx * 0.1 }}
                className="bg-white/5 border border-white/10 hover:border-[#F04455]/50 rounded-2xl p-4 sm:p-5 transition-all duration-200"
              >
                <div className="flex items-start justify-between gap-4">
                  <div className="flex items-start gap-3.5">
                    <div className="w-8 h-8 rounded-xl bg-white/10 text-[#FF7582] font-mono font-bold text-xs flex items-center justify-center shrink-0 border border-white/15">
                      {item.step}
                    </div>
                    <div>
                      <h4 className="text-base font-bold text-white">{item.title}</h4>
                      <p className="text-xs text-slate-300 mt-1 leading-relaxed">{item.desc}</p>
                    </div>
                  </div>
                  <span className={`text-[10px] font-bold px-2.5 py-1 rounded-full shrink-0 ${item.statusColor}`}>
                    {item.status}
                  </span>
                </div>
              </motion.div>
            ))}

            <div className="pt-4 flex flex-col sm:flex-row items-center gap-4">
              <a
                href="#features"
                className="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-[#F04455] hover:bg-[#D93647] text-white font-bold text-sm shadow-coral-glow transition-all"
              >
                <span>Explore Rakshaa Features</span>
                <ArrowRight className="w-4 h-4" />
              </a>
              <span className="text-xs text-slate-400">
                Network dependent: alerts rely on active internet connection and valid phone numbers.
              </span>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
