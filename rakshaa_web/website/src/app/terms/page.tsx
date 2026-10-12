import React from "react";
import Link from "next/link";
import { Navbar } from "@/components/Navbar";
import { Footer } from "@/components/Footer";
import { FileText, ArrowLeft, AlertCircle, ShieldAlert } from "lucide-react";

export const metadata = {
  title: "Terms of Service — Rakshaa Women's Safety",
  description: "Terms and conditions for using the Rakshaa application and services.",
};

export default function TermsPage() {
  return (
    <div className="min-h-screen flex flex-col bg-[#FFF8F8]">
      <Navbar />
      <main className="flex-1 pt-28 pb-20">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <Link
            href="/"
            className="inline-flex items-center gap-2 text-xs font-bold text-[#F04455] hover:underline mb-8"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Back to Home</span>
          </Link>

          <div className="bg-white rounded-3xl p-8 sm:p-12 border border-[#F3E4E6] shadow-sm">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#FFE7EC] border border-[#F3E4E6] text-xs font-bold text-[#F04455] uppercase tracking-wider mb-4">
              <FileText className="w-3.5 h-3.5" />
              <span>User Agreement</span>
            </div>

            <h1 className="text-3xl sm:text-4xl font-extrabold text-[#18243A] tracking-tight">
              Rakshaa Terms of Service
            </h1>
            <p className="text-xs text-[#707786] mt-2 mb-8">
              Effective Date: October 2026 • Version 1.0.4
            </p>

            <div className="space-y-8 text-sm text-[#707786] leading-relaxed">
              <section className="p-4 bg-[#FFE7EC]/60 border border-[#F3E4E6] rounded-2xl text-xs text-[#18243A]">
                <div className="flex items-start gap-2.5">
                  <ShieldAlert className="w-5 h-5 text-[#F04455] shrink-0 mt-0.5" />
                  <div>
                    <strong>CRITICAL NOTICE:</strong> Rakshaa is designed as a personal peer-to-peer
                    alerting utility. It coordinates emergency alerts to your chosen personal contacts.
                    It does NOT replace municipal police, fire, or ambulance dispatch. In any immediate
                    threat to life, call India&apos;s National Emergency Number <strong>112</strong>.
                  </div>
                </div>
              </section>

              <section>
                <h2 className="text-lg font-bold text-[#18243A] mb-3">1. Scope of Service</h2>
                <p>
                  Rakshaa offers an automated emergency dispatch tool that queries device sensors,
                  computes geographical coordinates, and sends WhatsApp messages to selected contacts.
                  Delivery of alerts relies upon third-party telecommunication networks, active mobile
                  data connectivity, and WhatsApp server uptime.
                </p>
              </section>

              <section>
                <h2 className="text-lg font-bold text-[#18243A] mb-3">2. User Responsibility</h2>
                <p>
                  Users must ensure that contact numbers provided in the safety network are valid and
                  accurately registered. Users agree not to misuse or trigger frivolous false SOS
                  signals that could burden emergency contacts.
                </p>
              </section>

              <section>
                <h2 className="text-lg font-bold text-[#18243A] mb-3">3. Limitation of Liability</h2>
                <p>
                  While Rakshaa strives for high availability, we cannot guarantee zero delivery delays
                  caused by telecommunication outages, lack of GPS signal inside dense structures, or
                  device battery exhaustion.
                </p>
              </section>
            </div>
          </div>
        </div>
      </main>
      <Footer />
    </div>
  );
}
