import React from "react";
import Link from "next/link";
import { Navbar } from "@/components/Navbar";
import { Footer } from "@/components/Footer";
import { Shield, ArrowLeft, Lock, Eye, MapPin, Database } from "lucide-react";

export const metadata = {
  title: "Privacy Policy — Rakshaa Women's Safety",
  description: "Learn how Rakshaa handles your privacy, emergency contacts, and live location data.",
};

export default function PrivacyPage() {
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
              <Shield className="w-3.5 h-3.5" />
              <span>Data & Privacy Commitment</span>
            </div>

            <h1 className="text-3xl sm:text-4xl font-extrabold text-[#18243A] tracking-tight">
              Rakshaa Privacy Policy
            </h1>
            <p className="text-xs text-[#707786] mt-2 mb-8">
              Effective Date: October 2026 • Version 1.0.4
            </p>

            <div className="space-y-8 text-sm text-[#707786] leading-relaxed">
              <section>
                <h2 className="text-lg font-bold text-[#18243A] mb-3 flex items-center gap-2">
                  <MapPin className="w-5 h-5 text-[#F04455]" />
                  <span>1. Location Information and GPS Tracking</span>
                </h2>
                <p>
                  Rakshaa accesses your device&apos;s GPS location strictly when you initiate an active
                  emergency session (either by tapping the SOS button or through your configured Quick
                  SOS mode). Your live coordinates are used solely to:
                </p>
                <ul className="list-disc pl-5 mt-2 space-y-1">
                  <li>Generate reverse-geocoded street addresses and landmark references.</li>
                  <li>Transmit live Google Maps hyperlinks to your configured emergency contacts.</li>
                  <li>Synchronize current incident coordinates to the incident command database.</li>
                </ul>
                <p className="mt-2 font-semibold text-[#18243A]">
                  Rakshaa does NOT track your background location when an emergency session is
                  inactive or resolved.
                </p>
              </section>

              <section>
                <h2 className="text-lg font-bold text-[#18243A] mb-3 flex items-center gap-2">
                  <Lock className="w-5 h-5 text-[#F04455]" />
                  <span>2. Contact Information and Emergency Alerts</span>
                </h2>
                <p>
                  You choose which individuals are stored in your trusted safety circle. Contact phone
                  numbers and names are stored in secure cloud records associated with your account
                  to allow automated WhatsApp alert dispatching when emergency mode is active.
                </p>
              </section>

              <section>
                <h2 className="text-lg font-bold text-[#18243A] mb-3 flex items-center gap-2">
                  <Eye className="w-5 h-5 text-[#F04455]" />
                  <span>3. Zero Commercial Monetization</span>
                </h2>
                <p>
                  Rakshaa does not sell, rent, or trade your personal safety records, phone numbers, or
                  location history with advertisers or third-party data brokers.
                </p>
              </section>

              <section>
                <h2 className="text-lg font-bold text-[#18243A] mb-3 flex items-center gap-2">
                  <Database className="w-5 h-5 text-[#F04455]" />
                  <span>4. Emergency History and Data Deletion</span>
                </h2>
                <p>
                  You may review or clear your past emergency logs inside the application settings.
                  If you wish to delete your entire account and associated safety network records, you
                  may submit a deletion request to support@rakshaa.app.
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
