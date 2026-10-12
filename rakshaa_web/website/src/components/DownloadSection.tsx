"use client";

import React from "react";
import Image from "next/image";
import { motion } from "framer-motion";
import {
  Download,
  ShieldCheck,
  Smartphone,
  CheckCircle2,
  FileCheck,
  AlertCircle,
  QrCode,
  ArrowDownToLine,
  ExternalLink,
} from "lucide-react";
import { downloadConfig } from "@/config/download";

export function DownloadSection() {
  return (
    <section id="download" className="py-20 sm:py-28 bg-gradient-to-b from-white via-[#FFF5F5] to-[#FFE7EC]/50 relative overflow-hidden">
      {/* Decorative Blur Circles */}
      <div className="absolute top-1/4 right-0 w-96 h-96 bg-[#FFE7EC] rounded-full blur-3xl opacity-70 pointer-events-none" />
      <div className="absolute bottom-0 left-0 w-96 h-96 bg-[#FFCCD4]/50 rounded-full blur-3xl opacity-60 pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        {/* Header */}
        <div className="max-w-3xl mx-auto text-center mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#FFE7EC] border border-[#F3E4E6] text-xs font-bold text-[#F04455] uppercase tracking-wider mb-4">
            <Smartphone className="w-3.5 h-3.5" />
            <span>Official Android Release</span>
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black text-[#18243A] tracking-tight">
            Take Rakshaa With You.
          </h2>
          <p className="mt-4 text-base sm:text-lg text-[#707786]">
            Keep your personal safety tools accessible on your Android device. Download the official
            verified APK directly.
          </p>
        </div>

        {/* Main Download Card */}
        <div className="bg-white rounded-3xl p-8 sm:p-12 border border-[#F3E4E6] shadow-xl max-w-5xl mx-auto">
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-10 items-center">
            {/* Left: Release Details & Download CTA */}
            <div className="lg:col-span-7 flex flex-col items-start">
              <div className="flex items-center gap-3 mb-4">
                <div className="w-12 h-12 rounded-2xl bg-gradient-to-tr from-[#F04455] to-[#FF7582] text-white flex items-center justify-center shadow-sm">
                  <Smartphone className="w-6 h-6" />
                </div>
                <div>
                  <h3 className="text-xl font-bold text-[#18243A]">
                    Rakshaa for Android
                  </h3>
                  <div className="flex items-center gap-2 text-xs text-[#707786]">
                    <span className="font-semibold text-emerald-600 flex items-center gap-1">
                      <ShieldCheck className="w-3.5 h-3.5" /> Official Build
                    </span>
                    <span>•</span>
                    <span>{downloadConfig.version}</span>
                  </div>
                </div>
              </div>

              {/* Release Metadata Pills */}
              <div className="grid grid-cols-2 sm:grid-cols-3 gap-3 w-full my-6 p-4 bg-[#FFF8F8] rounded-2xl border border-[#F3E4E6]">
                <div>
                  <div className="text-[10px] text-[#707786] uppercase font-bold tracking-wider">Package Size</div>
                  <div className="text-sm font-extrabold text-[#18243A] mt-0.5">{downloadConfig.fileSize}</div>
                </div>
                <div>
                  <div className="text-[10px] text-[#707786] uppercase font-bold tracking-wider">Compatibility</div>
                  <div className="text-sm font-extrabold text-[#18243A] mt-0.5">{downloadConfig.minAndroid}</div>
                </div>
                <div className="col-span-2 sm:col-span-1">
                  <div className="text-[10px] text-[#707786] uppercase font-bold tracking-wider">Status</div>
                  <div className="text-sm font-extrabold text-emerald-600 mt-0.5">Ready to Install</div>
                </div>
              </div>

              {/* Primary Download Button */}
              {downloadConfig.isAvailable ? (
                <div className="w-full flex flex-col sm:flex-row items-center gap-4">
                  <a
                    href={downloadConfig.apkDownloadUrl}
                    download={downloadConfig.apkFileName}
                    className="w-full sm:w-auto flex-1 inline-flex items-center justify-center gap-3 px-8 py-4 text-base font-bold text-white bg-[#F04455] hover:bg-[#D93647] rounded-2xl shadow-coral-glow hover:shadow-coral-subtle transition-all duration-200 active:scale-95 text-center group"
                  >
                    <ArrowDownToLine className="w-5 h-5 group-hover:translate-y-0.5 transition-transform" />
                    <span>Download Official APK ({downloadConfig.fileSize})</span>
                  </a>
                </div>
              ) : (
                <div className="w-full p-4 rounded-2xl bg-gray-100 text-[#707786] text-sm font-semibold text-center border border-gray-200">
                  Android download coming soon. Official release package will be uploaded shortly.
                </div>
              )}

              {/* Authenticity notice */}
              <div className="mt-4 flex items-center gap-2 text-xs text-[#707786]">
                <FileCheck className="w-4 h-4 text-emerald-600 shrink-0" />
                <span>Verified Clean Build • Direct APK Installation</span>
              </div>
            </div>

            {/* Right: Step-by-Step Installation Instructions */}
            <div className="lg:col-span-5 bg-[#FFF8F8] p-6 sm:p-7 rounded-2xl border border-[#F3E4E6]">
              <h4 className="text-sm font-bold uppercase tracking-wider text-[#18243A] mb-4 flex items-center gap-2">
                <span>Installation Guide</span>
              </h4>

              <div className="space-y-3.5">
                {downloadConfig.instructions.map((item, idx) => (
                  <div key={idx} className="flex items-start gap-3">
                    <span className="w-6 h-6 rounded-full bg-white text-[#F04455] border border-[#F3E4E6] flex items-center justify-center text-[10px] font-black shrink-0 mt-0.5 shadow-xs">
                      {item.step}
                    </span>
                    <div>
                      <div className="text-xs font-bold text-[#18243A]">{item.title}</div>
                      <div className="text-[11px] text-[#707786] leading-tight mt-0.5">
                        {item.description}
                      </div>
                    </div>
                  </div>
                ))}
              </div>

              {/* Safety Warning */}
              <div className="mt-5 p-3 bg-white rounded-xl border border-[#F3E4E6] text-[10px] text-[#707786] leading-relaxed">
                <strong className="text-[#18243A]">Official Source Notice:</strong> Download Rakshaa only
                from this official portal or verified repository to avoid altered packages.
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
