"use client";

import React from "react";
import Link from "next/link";
import { motion } from "framer-motion";
import { Download, ArrowRight, Shield, Heart, Sparkles, Lock } from "lucide-react";
import { PhoneMockups } from "./PhoneMockups";

export function HeroSection() {
  return (
    <section id="hero" className="relative pt-28 pb-16 sm:pt-36 sm:pb-24 overflow-hidden">
      {/* Background Soft Gradients & Glows */}
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-full max-w-7xl h-[650px] bg-gradient-to-b from-[#FFE7EC]/50 via-[#FFF0F3]/30 to-transparent -z-10 pointer-events-none rounded-b-[60px]" />
      <div className="absolute top-24 -left-32 w-96 h-96 bg-[#FFE7EC]/60 rounded-full blur-3xl -z-10 pointer-events-none" />
      <div className="absolute top-48 -right-32 w-96 h-96 bg-[#FFCCD4]/40 rounded-full blur-3xl -z-10 pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-8 items-center">
          {/* Left Column: Headlines & Call to Actions */}
          <motion.div
            initial={{ opacity: 0, y: 24 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, ease: [0.16, 1, 0.3, 1] }}
            className="lg:col-span-6 flex flex-col items-center lg:items-start text-center lg:text-left"
          >
            {/* Pill Badge */}
            <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-white border border-[#F3E4E6] shadow-sm mb-6">
              <span className="flex h-2 w-2 rounded-full bg-[#F04455] animate-pulse" />
              <span className="text-xs font-bold uppercase tracking-wider text-[#18243A]">
                YOUR PERSONAL SAFETY COMPANION
              </span>
            </div>

            {/* Main Headline */}
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black text-[#18243A] tracking-tight leading-[1.12]">
              Your Safety. <br />
              <span className="bg-gradient-to-r from-[#F04455] via-[#FF6070] to-[#FA709A] bg-clip-text text-transparent">
                Always Within Reach.
              </span>
            </h1>

            {/* Supporting Description */}
            <p className="mt-6 text-base sm:text-lg text-[#707786] leading-relaxed max-w-xl">
              Rakshaa helps you stay connected to the people you trust when you need support.
              Activate an emergency alert, share your live location during an emergency, and keep your
              trusted contacts informed.
            </p>

            {/* Call to Actions */}
            <div className="mt-8 flex flex-col sm:flex-row items-center gap-3.5 w-full sm:w-auto">
              <a
                href="#download"
                className="w-full sm:w-auto inline-flex items-center justify-center gap-2.5 px-7 py-3.5 text-base font-bold text-white bg-[#F04455] hover:bg-[#D93647] rounded-2xl shadow-coral-glow hover:shadow-coral-subtle transition-all duration-200 active:scale-95 group"
              >
                <Download className="w-5 h-5 group-hover:-translate-y-0.5 transition-transform" />
                <span>Download Rakshaa</span>
              </a>

              <a
                href="#features"
                className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-6 py-3.5 text-base font-semibold text-[#18243A] bg-white hover:bg-[#FFE7EC]/40 border border-[#F3E4E6] rounded-2xl shadow-sm transition-all duration-200"
              >
                <span>Explore Features</span>
                <ArrowRight className="w-4 h-4 text-[#F04455]" />
              </a>
            </div>

            {/* Reassurance Disclaimer */}
            <div className="mt-5 flex items-center gap-2 text-xs text-[#707786]">
              <Shield className="w-4 h-4 text-[#F04455] shrink-0" />
              <span>Designed to help you reach trusted support when it matters.</span>
            </div>

            {/* Quick Metrics / Highlights */}
            <div className="mt-10 pt-8 border-t border-[#F3E4E6] grid grid-cols-3 gap-6 w-full max-w-md">
              <div>
                <div className="text-xl sm:text-2xl font-black text-[#18243A]">1-Tap</div>
                <div className="text-xs text-[#707786] mt-0.5 font-medium">SOS Trigger</div>
              </div>
              <div>
                <div className="text-xl sm:text-2xl font-black text-[#F04455]">WhatsApp</div>
                <div className="text-xs text-[#707786] mt-0.5 font-medium">Auto Location Alert</div>
              </div>
              <div>
                <div className="text-xl sm:text-2xl font-black text-[#18243A]">112</div>
                <div className="text-xs text-[#707786] mt-0.5 font-medium">Emergency Shortcut</div>
              </div>
            </div>
          </motion.div>

          {/* Right Column: Interactive Phone Mockups */}
          <motion.div
            initial={{ opacity: 0, scale: 0.96 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.8, delay: 0.15, ease: [0.16, 1, 0.3, 1] }}
            className="lg:col-span-6 flex justify-center items-center"
          >
            <PhoneMockups />
          </motion.div>
        </div>
      </div>
    </section>
  );
}
