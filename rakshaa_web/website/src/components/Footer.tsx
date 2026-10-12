"use client";

import React from "react";
import Link from "next/link";
import Image from "next/image";
import { Shield, Lock, Download, Heart, ArrowUp } from "lucide-react";
import { siteConfig } from "@/config/site";

export function Footer() {
  const [currentYear, setCurrentYear] = React.useState(2026);

  React.useEffect(() => {
    setCurrentYear(new Date().getFullYear());
  }, []);

  const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  };

  return (
    <footer className="bg-[#18243A] text-white pt-16 pb-12 relative overflow-hidden border-t-2 border-[#F04455]/30">
      {/* Decorative gradient glow */}
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-full max-w-4xl h-1 bg-gradient-to-r from-transparent via-[#F04455] to-transparent" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-12 gap-10 pb-12 border-b border-white/10">
          {/* Brand Info (Cols 1-4) */}
          <div className="lg:col-span-4 flex flex-col items-start">
            <Link href="/" className="flex items-center gap-3 group mb-4">
              <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-[#F04455] to-[#FF7582] p-0.5 shadow-sm">
                <div className="w-full h-full bg-white rounded-[10px] flex items-center justify-center overflow-hidden">
                  <Image
                    src="/app_logo.png"
                    alt="Rakshaa Logo"
                    width={32}
                    height={32}
                    className="object-contain"
                  />
                </div>
              </div>
              <div>
                <span className="font-extrabold text-xl tracking-wider text-white">
                  {siteConfig.wordmark}
                </span>
                <span className="block text-[10px] tracking-widest text-[#FF7582] font-semibold uppercase">
                  {siteConfig.tagline}
                </span>
              </div>
            </Link>

            <p className="text-xs text-slate-300 leading-relaxed max-w-sm mb-6">
              A dedicated personal safety companion built to ensure you are never truly alone.
              Instant SOS dispatch, continuous GPS tracking, and reliable communication with the
              people you count on most.
            </p>

            {/* Admin Portal Access Badge */}
            <Link
              href="/login"
              className="inline-flex items-center gap-2 px-3.5 py-2 rounded-xl bg-white/10 hover:bg-white/20 border border-white/20 text-xs font-semibold text-white transition-all duration-200"
            >
              <Lock className="w-3.5 h-3.5 text-[#FF7582]" />
              <span>Admin & Incident Command Portal</span>
            </Link>
          </div>

          {/* Product Links (Cols 5-6) */}
          <div className="lg:col-span-2">
            <h4 className="text-xs font-bold uppercase tracking-wider text-[#FF7582] mb-4">
              Product
            </h4>
            <ul className="space-y-2.5 text-xs text-slate-300">
              <li>
                <a href="/#hero" className="hover:text-white transition-colors">
                  Home Overview
                </a>
              </li>
              <li>
                <a href="/#features" className="hover:text-white transition-colors">
                  Safety Features
                </a>
              </li>
              <li>
                <a href="/#how-it-works" className="hover:text-white transition-colors">
                  How It Works
                </a>
              </li>
              <li>
                <a href="/#download" className="hover:text-white transition-colors">
                  Download APK
                </a>
              </li>
            </ul>
          </div>

          {/* Safety Links (Cols 7-8) */}
          <div className="lg:col-span-2">
            <h4 className="text-xs font-bold uppercase tracking-wider text-[#FF7582] mb-4">
              Safety Tools
            </h4>
            <ul className="space-y-2.5 text-xs text-slate-300">
              <li>
                <a href="/#quick-sos" className="hover:text-white transition-colors">
                  Quick SOS Mode
                </a>
              </li>
              <li>
                <a href="/#safety-tools" className="hover:text-white transition-colors">
                  Safety Timer
                </a>
              </li>
              <li>
                <a href="/#faq" className="hover:text-white transition-colors">
                  Safety FAQ
                </a>
              </li>
              <li>
                <a href="tel:112" className="text-amber-300 hover:text-amber-200 font-bold">
                  Emergency 112 Helpline
                </a>
              </li>
            </ul>
          </div>

          {/* Legal Links (Cols 9-10) */}
          <div className="lg:col-span-2">
            <h4 className="text-xs font-bold uppercase tracking-wider text-[#FF7582] mb-4">
              Legal & Trust
            </h4>
            <ul className="space-y-2.5 text-xs text-slate-300">
              <li>
                <Link href="/privacy" className="hover:text-white transition-colors">
                  Privacy Policy
                </Link>
              </li>
              <li>
                <Link href="/terms" className="hover:text-white transition-colors">
                  Terms of Service
                </Link>
              </li>
              <li>
                <span className="text-slate-400">Location Protocol</span>
              </li>
              <li>
                <span className="text-slate-400">Zero Data Selling</span>
              </li>
            </ul>
          </div>

          {/* Support (Cols 11-12) */}
          <div className="lg:col-span-2">
            <h4 className="text-xs font-bold uppercase tracking-wider text-[#FF7582] mb-4">
              Support
            </h4>
            <ul className="space-y-2.5 text-xs text-slate-300">
              <li>
                <a href={`mailto:${siteConfig.links.supportEmail}`} className="hover:text-white">
                  {siteConfig.links.supportEmail}
                </a>
              </li>
              <li>
                <Link href="/support" className="hover:text-white transition-colors">
                  Help Desk
                </Link>
              </li>
              <li>
                <a href="#faq" className="hover:text-white transition-colors">
                  Troubleshooting
                </a>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom Bar: Copyright & Back to Top */}
        <div className="pt-8 flex flex-col sm:flex-row items-center justify-between gap-4 text-xs text-slate-400">
          <div>
            © {currentYear} Rakshaa Technologies. All rights reserved. Your Safety. Always Within Reach.
          </div>

          <div className="flex items-center gap-6">
            <Link href="/login" className="text-slate-300 hover:text-[#FF7582] font-semibold">
              Operations Login
            </Link>
            <button
              onClick={scrollToTop}
              className="inline-flex items-center gap-1.5 text-slate-300 hover:text-white font-medium focus:outline-none"
            >
              <span>Back to top</span>
              <ArrowUp className="w-3.5 h-3.5" />
            </button>
          </div>
        </div>
      </div>
    </footer>
  );
}
