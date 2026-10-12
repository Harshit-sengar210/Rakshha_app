"use client";

import React from "react";
import { Heart, ShieldCheck, Users, Lock, Sparkles } from "lucide-react";

export function BrandPurpose() {
  return (
    <section className="py-20 sm:py-28 bg-[#FFF8F8] relative overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="relative bg-gradient-to-br from-[#FFE7EC]/90 via-white to-[#FFF0F3] rounded-[40px] p-8 sm:p-14 lg:p-20 border border-[#F3E4E6] shadow-soft-card overflow-hidden">
          {/* Subtle decorative circles */}
          <div className="absolute top-0 right-0 -mr-20 -mt-20 w-80 h-80 bg-[#FFD1DC]/50 rounded-full blur-3xl pointer-events-none" />
          <div className="absolute bottom-0 left-0 -ml-20 -mb-20 w-80 h-80 bg-[#FFE7EC]/60 rounded-full blur-3xl pointer-events-none" />

          <div className="max-w-3xl mx-auto text-center relative z-10">
            <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-white border border-[#F3E4E6] text-xs font-bold text-[#F04455] uppercase tracking-wider mb-6 shadow-sm">
              <Heart className="w-3.5 h-3.5 fill-[#F04455] text-[#F04455]" />
              <span>Our Brand Philosophy</span>
            </div>

            <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black text-[#18243A] tracking-tight leading-tight">
              Built Around the People You Trust.
            </h2>

            <p className="mt-6 text-base sm:text-lg text-[#707786] leading-relaxed">
              True personal safety doesn&apos;t come from false promises or panic buttons. It starts
              with your own circle of support — parents, partners, siblings, and friends who genuinely
              care and will answer your call without hesitation.
            </p>

            <div className="mt-10 grid grid-cols-1 sm:grid-cols-3 gap-6 text-left">
              <div className="bg-white/80 backdrop-blur-sm p-6 rounded-2xl border border-[#F3E4E6] shadow-sm">
                <div className="w-10 h-10 rounded-xl bg-[#FFE7EC] flex items-center justify-center text-[#F04455] mb-3">
                  <Users className="w-5 h-5" />
                </div>
                <h4 className="text-sm font-bold text-[#18243A]">Human Connection</h4>
                <p className="text-xs text-[#707786] mt-1 leading-relaxed">
                  Keeping your primary trusted contact informed automatically when you need help.
                </p>
              </div>

              <div className="bg-white/80 backdrop-blur-sm p-6 rounded-2xl border border-[#F3E4E6] shadow-sm">
                <div className="w-10 h-10 rounded-xl bg-[#FFE7EC] flex items-center justify-center text-[#F04455] mb-3">
                  <ShieldCheck className="w-5 h-5" />
                </div>
                <h4 className="text-sm font-bold text-[#18243A]">Transparent Intent</h4>
                <p className="text-xs text-[#707786] mt-1 leading-relaxed">
                  No hidden tracking. Your coordinates are shared only during an initiated active emergency.
                </p>
              </div>

              <div className="bg-white/80 backdrop-blur-sm p-6 rounded-2xl border border-[#F3E4E6] shadow-sm">
                <div className="w-10 h-10 rounded-xl bg-[#FFE7EC] flex items-center justify-center text-[#F04455] mb-3">
                  <Lock className="w-5 h-5" />
                </div>
                <h4 className="text-sm font-bold text-[#18243A]">Zero Advertisements</h4>
                <p className="text-xs text-[#707786] mt-1 leading-relaxed">
                  No data selling, commercial popups, or tracking cookies. Built strictly for your peace of mind.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
