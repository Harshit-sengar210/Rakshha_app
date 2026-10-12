"use client";

import React, { useState, useEffect } from "react";
import Link from "next/link";
import Image from "next/image";
import { motion, AnimatePresence } from "framer-motion";
import {
  Shield,
  Download,
  Menu,
  X,
  Lock,
  ArrowRight,
  ExternalLink,
} from "lucide-react";
import { siteConfig } from "@/config/site";

export function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 20) {
        setScrolled(true);
      } else {
        setScrolled(false);
      }
    };
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  const navLinks = [
    { name: "Home", href: "/#hero" },
    { name: "Features", href: "/#features" },
    { name: "How It Works", href: "/#how-it-works" },
    { name: "Quick SOS", href: "/#quick-sos" },
    { name: "Safety Tools", href: "/#safety-tools" },
    { name: "FAQ", href: "/#faq" },
  ];

  return (
    <header
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        scrolled
          ? "bg-white/95 backdrop-blur-md shadow-sm border-b border-[#F3E4E6]/80 py-3.5"
          : "bg-transparent py-5"
      }`}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between">
          {/* Left: Brand Logo & Wordmark */}
          <Link href="/" className="flex items-center gap-3 group focus:outline-none">
            <div className="relative w-10 h-10 rounded-xl bg-gradient-to-tr from-[#F04455] to-[#FF7582] p-0.5 shadow-coral-subtle group-hover:scale-105 transition-transform duration-200">
              <div className="w-full h-full bg-white rounded-[10px] flex items-center justify-center overflow-hidden">
                <Image
                  src="/app_logo.png"
                  alt="Rakshaa Logo"
                  width={34}
                  height={34}
                  className="object-contain"
                  priority
                />
              </div>
            </div>
            <div className="flex flex-col">
              <span className="font-extrabold text-xl tracking-wider text-[#18243A] leading-none group-hover:text-[#F04455] transition-colors">
                {siteConfig.wordmark}
              </span>
              <span className="text-[10px] tracking-widest text-[#707786] font-semibold uppercase mt-0.5">
                Women&apos;s Safety
              </span>
            </div>
          </Link>

          {/* Center Navigation Links (Desktop) */}
          <nav className="hidden md:flex items-center gap-1 lg:gap-2 bg-white/70 backdrop-blur-md px-4 py-1.5 rounded-full border border-[#F3E4E6] shadow-sm">
            {navLinks.map((link) => (
              <a
                key={link.name}
                href={link.href}
                className="px-3.5 py-1.5 text-sm font-medium text-[#707786] hover:text-[#F04455] hover:bg-[#FFE7EC]/60 rounded-full transition-all duration-200"
              >
                {link.name}
              </a>
            ))}
          </nav>

          {/* Right Action Buttons */}
          <div className="hidden sm:flex items-center gap-3">
            {/* Admin Portal Button */}
            <Link
              href="/login"
              className="inline-flex items-center gap-1.5 px-3.5 py-2 text-xs font-semibold text-[#18243A] bg-white border border-[#E7E9EF] hover:border-[#F04455]/40 hover:bg-[#FFE7EC]/40 rounded-xl transition-all duration-200 shadow-sm"
              title="Access Admin Console (Authentication Required)"
            >
              <Lock className="w-3.5 h-3.5 text-[#F04455]" />
              <span>Admin Portal</span>
            </Link>

            {/* Download Button */}
            <a
              href="#download"
              className="inline-flex items-center gap-2 px-5 py-2.5 text-sm font-semibold text-white bg-[#F04455] hover:bg-[#D93647] rounded-xl shadow-coral-subtle hover:shadow-coral-glow transition-all duration-200 active:scale-95"
            >
              <Download className="w-4 h-4" />
              <span>Download App</span>
            </a>
          </div>

          {/* Mobile Menu Hamburger */}
          <div className="flex items-center gap-2 md:hidden">
            <Link
              href="/login"
              className="p-2 text-xs font-medium text-[#18243A] bg-white border border-[#E7E9EF] rounded-lg"
              title="Admin Portal Login"
            >
              <Lock className="w-4 h-4 text-[#F04455]" />
            </Link>
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="p-2 rounded-xl text-[#18243A] hover:bg-[#FFE7EC] transition-colors focus:outline-none"
              aria-label="Toggle menu"
            >
              {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Drawer Menu */}
      <AnimatePresence>
        {mobileMenuOpen && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: "auto" }}
            exit={{ opacity: 0, height: 0 }}
            transition={{ duration: 0.25 }}
            className="md:hidden bg-white/98 backdrop-blur-xl border-b border-[#F3E4E6] px-5 py-6 shadow-xl"
          >
            <div className="flex flex-col gap-3">
              {navLinks.map((link) => (
                <a
                  key={link.name}
                  href={link.href}
                  onClick={() => setMobileMenuOpen(false)}
                  className="px-4 py-2.5 text-base font-medium text-[#18243A] hover:text-[#F04455] hover:bg-[#FFE7EC]/50 rounded-xl transition-colors"
                >
                  {link.name}
                </a>
              ))}

              <div className="pt-4 border-t border-[#F3E4E6] flex flex-col gap-3">
                <Link
                  href="/login"
                  onClick={() => setMobileMenuOpen(false)}
                  className="flex items-center justify-between px-4 py-3 text-sm font-semibold text-[#18243A] bg-gray-50 hover:bg-[#FFE7EC]/60 rounded-xl border border-gray-200"
                >
                  <div className="flex items-center gap-2">
                    <Lock className="w-4 h-4 text-[#F04455]" />
                    <span>Admin Operations Portal</span>
                  </div>
                  <ExternalLink className="w-4 h-4 text-gray-400" />
                </Link>

                <a
                  href="#download"
                  onClick={() => setMobileMenuOpen(false)}
                  className="flex items-center justify-center gap-2 px-4 py-3 text-sm font-semibold text-white bg-[#F04455] rounded-xl shadow-coral-subtle"
                >
                  <Download className="w-4 h-4" />
                  <span>Download Rakshaa APK</span>
                </a>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </header>
  );
}
