"use client";

import React, { useState } from "react";
import Link from "next/link";
import { Mail, MessageSquare, Shield, HelpCircle, Check, ArrowRight } from "lucide-react";
import { siteConfig } from "@/config/site";

export function SupportSection() {
  const [submitted, setSubmitted] = useState(false);
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (email) {
      setSubmitted(true);
    }
  };

  return (
    <section id="support" className="py-20 bg-[#FFF8F8] relative">
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="bg-white rounded-3xl p-8 sm:p-12 border border-[#F3E4E6] shadow-xl">
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
            {/* Left Content */}
            <div className="lg:col-span-7">
              <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#FFE7EC] border border-[#F3E4E6] text-xs font-bold text-[#F04455] uppercase tracking-wider mb-4">
                <Mail className="w-3.5 h-3.5" />
                <span>Rakshaa Care</span>
              </div>
              <h2 className="text-3xl font-extrabold text-[#18243A] tracking-tight">
                We&apos;re Here to Help.
              </h2>
              <p className="mt-3 text-base text-[#707786] leading-relaxed">
                Whether you have questions about configuring your trusted contacts, trouble with GPS
                location permissions, or suggestions to make the app safer, our team is at your service.
              </p>

              {/* Direct Link Grid */}
              <div className="mt-6 flex flex-wrap gap-4 text-xs font-bold text-[#18243A]">
                <a
                  href={`mailto:${siteConfig.links.supportEmail}`}
                  className="inline-flex items-center gap-1.5 px-4 py-2 rounded-xl bg-[#FFF8F8] border border-[#F3E4E6] hover:border-[#F04455] hover:text-[#F04455] transition-colors"
                >
                  <Mail className="w-4 h-4 text-[#F04455]" />
                  <span>{siteConfig.links.supportEmail}</span>
                </a>
                <Link
                  href="/privacy"
                  className="inline-flex items-center gap-1.5 px-4 py-2 rounded-xl bg-[#FFF8F8] border border-[#F3E4E6] hover:border-[#F04455] hover:text-[#F04455] transition-colors"
                >
                  <Shield className="w-4 h-4 text-[#F04455]" />
                  <span>Privacy Policy</span>
                </Link>
                <Link
                  href="/terms"
                  className="inline-flex items-center gap-1.5 px-4 py-2 rounded-xl bg-[#FFF8F8] border border-[#F3E4E6] hover:border-[#F04455] hover:text-[#F04455] transition-colors"
                >
                  <span>Terms of Service</span>
                </Link>
              </div>
            </div>

            {/* Right Quick Support Form */}
            <div className="lg:col-span-5 bg-[#FFF8F8] p-6 rounded-2xl border border-[#F3E4E6]">
              {submitted ? (
                <div className="text-center py-6">
                  <div className="w-12 h-12 rounded-full bg-emerald-100 text-emerald-600 mx-auto flex items-center justify-center mb-3">
                    <Check className="w-6 h-6" />
                  </div>
                  <h4 className="text-base font-bold text-[#18243A]">Thank You!</h4>
                  <p className="text-xs text-[#707786] mt-1">
                    Your message has been received. Our support team will reply to {email} promptly.
                  </p>
                </div>
              ) : (
                <form onSubmit={handleSubmit} className="space-y-3.5">
                  <h4 className="text-sm font-bold text-[#18243A]">Send a Direct Message</h4>
                  <div>
                    <label className="text-[11px] font-semibold text-[#707786] block mb-1">
                      Your Email Address
                    </label>
                    <input
                      type="email"
                      required
                      placeholder="you@example.com"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      className="w-full px-3.5 py-2.5 rounded-xl border border-[#F3E4E6] bg-white text-xs text-[#18243A] focus:outline-none focus:border-[#F04455]"
                    />
                  </div>
                  <div>
                    <label className="text-[11px] font-semibold text-[#707786] block mb-1">
                      How can we help?
                    </label>
                    <textarea
                      rows={3}
                      required
                      placeholder="Describe your question or feedback..."
                      value={message}
                      onChange={(e) => setMessage(e.target.value)}
                      className="w-full px-3.5 py-2 rounded-xl border border-[#F3E4E6] bg-white text-xs text-[#18243A] focus:outline-none focus:border-[#F04455] resize-none"
                    />
                  </div>
                  <button
                    type="submit"
                    className="w-full py-2.5 bg-[#F04455] hover:bg-[#D93647] text-white text-xs font-bold rounded-xl shadow-coral-subtle transition-colors"
                  >
                    Submit Support Request
                  </button>
                </form>
              )}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
