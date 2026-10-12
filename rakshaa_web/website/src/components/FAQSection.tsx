"use client";

import React, { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { ChevronDown, HelpCircle, PhoneCall, ShieldAlert } from "lucide-react";

export function FAQSection() {
  const [openIndex, setOpenIndex] = useState<number | null>(0);

  const faqs = [
    {
      q: "What is Rakshaa?",
      a: "Rakshaa is a personal safety application designed to help women and users stay connected with their trusted circle during moments of distress. It enables fast SOS triggers, automated WhatsApp notifications with live Google Maps links, and direct shortcuts to India's national emergency services.",
    },
    {
      q: "How does the SOS feature work?",
      a: "When you tap the SOS button (or launch the app with Quick SOS enabled), Rakshaa initiates an active emergency session. It queries your device's high-precision GPS, fetches the reverse-geocoded street address, and dispatches a single comprehensive WhatsApp alert to your priority and trusted emergency contacts.",
    },
    {
      q: "Who receives my emergency alerts?",
      a: "Only the contacts you explicitly configure in your Rakshaa safety network. You can set one Priority Contact (for primary emergency phone calls & WhatsApp) plus additional Trusted Contacts. Rakshaa never broadcasts your data to public directories.",
    },
    {
      q: "Does Rakshaa share my live location all the time?",
      a: "No. Rakshaa respects your battery and privacy. Location tracking and sharing occur strictly during an active emergency session when you or your settings trigger SOS. Once you hold to stop or resolve the emergency, background tracking stops.",
    },
    {
      q: "What is Quick SOS?",
      a: "Quick SOS is an optional speed mode you can toggle in settings. When active, whenever you launch Rakshaa from your home screen, the app immediately checks your saved preference and initiates the emergency alert flow without requiring an additional tap.",
    },
    {
      q: "Can I add or change my trusted contacts?",
      a: "Yes. From the Contacts screen in the Rakshaa app, you can add, edit, or remove trusted contacts at any time, toggle WhatsApp dispatch permissions per contact, and choose who serves as your Priority responder.",
    },
    {
      q: "How can I download and install Rakshaa?",
      a: "You can download the official production APK directly from the download section of this website. Open the downloaded file on your Android device, allow installation from your browser if prompted, and complete the sign-in and permission setup.",
    },
    {
      q: "What should I do if I need immediate emergency assistance?",
      a: "In any life-threatening situation or immediate danger in India, call the National Emergency Helpline 112 immediately. Rakshaa includes one-tap 112 calling shortcuts on both the Home screen and during an active emergency. Rakshaa is designed to assist by notifying loved ones, but does not replace official police or medical emergency response.",
    },
    {
      q: "How can I contact the Rakshaa support team?",
      a: "You can reach out to our team at support@rakshaa.app or submit feedback through the support section below. We welcome inquiries, bug reports, and suggestions to make women's safety stronger.",
    },
  ];

  return (
    <section id="faq" className="py-20 sm:py-28 bg-white relative">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Section Header */}
        <div className="text-center mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#FFE7EC] border border-[#F3E4E6] text-xs font-bold text-[#F04455] uppercase tracking-wider mb-4">
            <HelpCircle className="w-3.5 h-3.5" />
            <span>Frequently Asked Questions</span>
          </div>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-[#18243A] tracking-tight">
            Clear Answers to Your Safety Questions.
          </h2>
          <p className="mt-4 text-base text-[#707786]">
            Everything you need to know about how Rakshaa operates, manages your data, and alerts your contacts.
          </p>
        </div>

        {/* Accordion */}
        <div className="space-y-4">
          {faqs.map((faq, index) => {
            const isOpen = openIndex === index;
            return (
              <div
                key={index}
                className="border border-[#F3E4E6] rounded-2xl overflow-hidden bg-[#FFF8F8] transition-colors"
              >
                <button
                  onClick={() => setOpenIndex(isOpen ? null : index)}
                  className="w-full py-4 sm:py-5 px-6 text-left flex items-center justify-between gap-4 focus:outline-none"
                  aria-expanded={isOpen}
                >
                  <span className="text-base font-bold text-[#18243A]">{faq.q}</span>
                  <div
                    className={`w-8 h-8 rounded-full flex items-center justify-center shrink-0 transition-transform duration-200 ${
                      isOpen ? "bg-[#F04455] text-white rotate-180" : "bg-white text-[#707786]"
                    }`}
                  >
                    <ChevronDown className="w-4 h-4" />
                  </div>
                </button>

                <AnimatePresence initial={false}>
                  {isOpen && (
                    <motion.div
                      initial={{ height: 0, opacity: 0 }}
                      animate={{ height: "auto", opacity: 1 }}
                      exit={{ height: 0, opacity: 0 }}
                      transition={{ duration: 0.25 }}
                    >
                      <div className="px-6 pb-5 pt-1 text-sm text-[#707786] leading-relaxed border-t border-[#F3E4E6]/50 bg-white">
                        {faq.a}
                      </div>
                    </motion.div>
                  )}
                </AnimatePresence>
              </div>
            );
          })}
        </div>

        {/* Emergency Notice */}
        <div className="mt-12 p-5 bg-[#FFE7EC]/60 border border-[#F3E4E6] rounded-2xl flex items-center gap-4 text-xs text-[#18243A]">
          <ShieldAlert className="w-6 h-6 text-[#F04455] shrink-0" />
          <div>
            <strong>National Emergency Hotline:</strong> For critical immediate help in India, dial{" "}
            <a href="tel:112" className="text-[#F04455] font-extrabold underline underline-offset-2">
              112
            </a>{" "}
            directly. Rakshaa coordinates with your personal contacts and provides quick dialing tools, but does not substitute government emergency dispatch.
          </div>
        </div>
      </div>
    </section>
  );
}
