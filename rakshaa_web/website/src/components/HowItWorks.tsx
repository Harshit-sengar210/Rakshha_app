"use client";

import React from "react";
import { motion } from "framer-motion";
import { UserPlus, BellRing, Navigation2, ArrowRight } from "lucide-react";

export function HowItWorks() {
  const steps = [
    {
      number: "01",
      icon: UserPlus,
      title: "Set Up Your Safety Network",
      description: "Add the people you trust and choose your priority emergency contact for automatic reach.",
      detail: "Add phone numbers, WhatsApp-enabled tags, and designate one primary responder for auto-dialing.",
      accent: "from-[#F04455] to-[#FF7582]",
    },
    {
      number: "02",
      icon: BellRing,
      title: "Activate Emergency Mode",
      description: "Use the SOS feature to start an emergency session and initiate the configured alert process.",
      detail: "Triggered via the 1-tap SOS button or Quick SOS setting. High-precision GPS is instantly acquired.",
      accent: "from-[#18243A] to-[#2B3B5C]",
    },
    {
      number: "03",
      icon: Navigation2,
      title: "Keep Your Contacts Informed",
      description: "Share your location during the emergency and let your trusted contacts receive relevant updates through supported notification channels.",
      detail: "Dispatches WhatsApp notifications with live Google Maps link, address, and live coordinates.",
      accent: "from-[#F04455] to-[#FA709A]",
    },
  ];

  return (
    <section id="how-it-works" className="py-20 sm:py-28 bg-[#FFF8F8] relative overflow-hidden">
      {/* Decorative background blur */}
      <div className="absolute top-1/2 -right-40 w-96 h-96 bg-[#FFE7EC] rounded-full blur-3xl opacity-60 -z-10" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Section Header */}
        <div className="text-center max-w-2xl mx-auto mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#FFE7EC] border border-[#F3E4E6] text-xs font-bold text-[#F04455] uppercase tracking-wider mb-4">
            Simple 3-Step Process
          </div>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-[#18243A] tracking-tight">
            Help Is Closer Than You Think.
          </h2>
          <p className="mt-4 text-base sm:text-lg text-[#707786]">
            Set up your safety network once, so you can reach out more easily when you need support.
          </p>
        </div>

        {/* 3 Step Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 relative">
          {/* Connector Line (Desktop) */}
          <div className="hidden md:block absolute top-1/3 left-1/6 right-1/6 h-0.5 border-t-2 border-dashed border-[#F3E4E6] -z-0" />

          {steps.map((step, idx) => {
            const Icon = step.icon;
            return (
              <motion.div
                key={idx}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: idx * 0.15 }}
                className="relative z-10 bg-white rounded-3xl p-8 border border-[#F3E4E6] shadow-soft-card hover:shadow-xl hover:-translate-y-1 transition-all duration-300 flex flex-col justify-between"
              >
                <div>
                  {/* Top Header Badge & Number */}
                  <div className="flex items-center justify-between mb-6">
                    <div className={`w-14 h-14 rounded-2xl bg-gradient-to-tr ${step.accent} text-white flex items-center justify-center shadow-sm`}>
                      <Icon className="w-7 h-7" />
                    </div>
                    <span className="text-3xl font-black text-[#FFE7EC] select-none">
                      {step.number}
                    </span>
                  </div>

                  <span className="text-xs font-extrabold uppercase tracking-widest text-[#F04455]">
                    Step {step.number}
                  </span>
                  <h3 className="text-xl font-bold text-[#18243A] mt-1 mb-3">
                    {step.title}
                  </h3>
                  <p className="text-sm text-[#707786] leading-relaxed">
                    {step.description}
                  </p>
                </div>

                <div className="mt-6 pt-5 border-t border-[#F3E4E6]">
                  <p className="text-xs text-slate-500 font-medium">
                    {step.detail}
                  </p>
                </div>
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
