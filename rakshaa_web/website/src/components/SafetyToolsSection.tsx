"use client";

import React from "react";
import { motion } from "framer-motion";
import { Timer, Navigation, PhoneForwarded, CheckCircle, Sparkles, Clock } from "lucide-react";

export function SafetyToolsSection() {
  const tools = [
    {
      id: "safety-timer",
      title: "Safety Check-in Timer",
      status: "Available",
      isAvailable: true,
      description:
        "Set a countdown timer before stepping into an auto-rickshaw or walking alone. If you don't check in before zero, alert triggers.",
      icon: Timer,
      color: "bg-[#F04455]",
      badgeClass: "bg-emerald-50 text-emerald-700 border-emerald-200",
    },
    {
      id: "safe-journey",
      title: "Safe Journey Tracking",
      status: "Coming Soon",
      isAvailable: false,
      description:
        "Share a planned travel route with estimated arrival time. Your trusted contacts receive an alert if your route deviates significantly.",
      icon: Navigation,
      color: "bg-[#18243A]",
      badgeClass: "bg-amber-50 text-amber-700 border-amber-200",
    },
    {
      id: "fake-call",
      title: "Discreet Fake Call",
      status: "Coming Soon",
      isAvailable: false,
      description:
        "Trigger an incoming realistic audio phone call simulator to provide an immediate, socially acceptable pretext to step away.",
      icon: PhoneForwarded,
      color: "bg-[#18243A]",
      badgeClass: "bg-amber-50 text-amber-700 border-amber-200",
    },
    {
      id: "safety-check",
      title: "Periodic Safety Check",
      status: "Coming Soon",
      isAvailable: false,
      description:
        "Automated vibration pulses every 15 minutes during late hours that require a discreet tap to confirm you are safe.",
      icon: CheckCircle,
      color: "bg-[#18243A]",
      badgeClass: "bg-amber-50 text-amber-700 border-amber-200",
    },
  ];

  return (
    <section id="safety-tools" className="py-20 sm:py-28 bg-white relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Section Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between mb-16 gap-6">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#FFE7EC] border border-[#F3E4E6] text-xs font-bold text-[#F04455] uppercase tracking-wider mb-4">
              <Sparkles className="w-3.5 h-3.5" />
              <span>Smart Protection Suite</span>
            </div>
            <h2 className="text-3xl sm:text-4xl font-extrabold text-[#18243A] tracking-tight">
              Additional Safety Tools.
            </h2>
            <p className="mt-3 text-base text-[#707786] max-w-xl">
              Proactive tools designed to prevent harm before emergencies happen. We build
              thoughtfully and clearly distinguish between live and planned features.
            </p>
          </div>

          <div className="text-xs text-[#707786] bg-gray-50 border border-gray-200 px-4 py-2.5 rounded-xl">
            Live tools are tested in production. Roadmap items are labeled transparently.
          </div>
        </div>

        {/* 4 Cards Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {tools.map((tool, idx) => {
            const Icon = tool.icon;
            return (
              <motion.div
                key={tool.id}
                initial={{ opacity: 0, y: 16 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.4, delay: idx * 0.1 }}
                className="bg-[#FFF8F8] border border-[#F3E4E6] rounded-3xl p-6 flex flex-col justify-between hover:shadow-lg hover:border-[#F04455]/30 transition-all duration-300 group"
              >
                <div>
                  <div className="flex items-center justify-between mb-5">
                    <div className={`w-12 h-12 rounded-2xl ${tool.color} text-white flex items-center justify-center shadow-sm`}>
                      <Icon className="w-6 h-6" />
                    </div>
                    <span className={`text-[11px] font-bold px-2.5 py-1 rounded-full border ${tool.badgeClass}`}>
                      {tool.status}
                    </span>
                  </div>

                  <h3 className="text-lg font-bold text-[#18243A] mb-2 group-hover:text-[#F04455] transition-colors">
                    {tool.title}
                  </h3>

                  <p className="text-xs text-[#707786] leading-relaxed">
                    {tool.description}
                  </p>
                </div>

                <div className="mt-6 pt-4 border-t border-[#F3E4E6]">
                  {tool.isAvailable ? (
                    <span className="text-xs font-bold text-[#F04455] flex items-center gap-1.5">
                      <span className="w-2 h-2 rounded-full bg-[#F04455] animate-pulse" />
                      Integrated in Android App
                    </span>
                  ) : (
                    <span className="text-xs text-[#707786] flex items-center gap-1.5">
                      <Clock className="w-3.5 h-3.5 text-amber-500" />
                      In Development Pipeline
                    </span>
                  )}
                </div>
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
