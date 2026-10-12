"use client";

import React from "react";
import { motion } from "framer-motion";
import {
  AlertCircle,
  Zap,
  MapPin,
  Users,
  History,
  PhoneCall,
  Timer,
  CheckCircle2,
  ArrowRight,
  Sparkles,
} from "lucide-react";

export function FeaturesSection() {
  const features = [
    {
      id: "sos-alerts",
      title: "SOS Emergency Alerts",
      description:
        "Activate emergency mode with a single tap to initiate automated WhatsApp alerts to your configured contacts with real-time location links.",
      icon: AlertCircle,
      badge: "Core Feature",
      featured: true,
      accent: "from-[#F04455] to-[#FF7582]",
    },
    {
      id: "quick-sos",
      title: "Quick SOS Mode",
      description:
        "Enable Quick SOS so the app can check your saved preference immediately upon launch and begin the configured emergency flow without extra taps.",
      icon: Zap,
      badge: "Instant Reach",
      featured: true,
      accent: "from-[#18243A] to-[#2B3B5C]",
    },
    {
      id: "live-location",
      title: "Live Location Sharing",
      description:
        "Share high-accuracy GPS coordinates and reverse-geocoded landmarks with authorized contacts strictly during an active emergency.",
      icon: MapPin,
      badge: "Privacy Focused",
      featured: false,
      accent: "from-[#F04455] to-[#FA709A]",
    },
    {
      id: "trusted-contacts",
      title: "Trusted Contacts Network",
      description:
        "Add important people to your safety network and designate a Priority Contact for automatic phone calls and WhatsApp messaging.",
      icon: Users,
      badge: "Network",
      featured: false,
      accent: "from-[#18243A] to-[#40547A]",
    },
    {
      id: "emergency-history",
      title: "Emergency History & Timeline",
      description:
        "Review past emergency sessions, exact timestamps, duration, route timeline, and recorded alert delivery details.",
      icon: History,
      badge: "Logs",
      featured: false,
      accent: "from-[#18243A] to-[#334155]",
    },
    {
      id: "emergency-call",
      title: "Direct 112 Emergency Access",
      description:
        "Keep national emergency calling options one tap away, with direct one-click dialer integration for India's 112 National Emergency Helpline.",
      icon: PhoneCall,
      badge: "Helpline 112",
      featured: false,
      accent: "from-[#F04455] to-[#E11D48]",
    },
    {
      id: "safety-timer",
      title: "Safety Check-in Timer",
      description:
        "Set a countdown timer before walking alone at night. If not checked in before expiry, the app alerts your trusted circle.",
      icon: Timer,
      badge: "Coming Soon",
      isComingSoon: true,
      featured: false,
      accent: "from-amber-500 to-amber-600",
    },
    {
      id: "alert-status",
      title: "Real-time Alert Status Tracking",
      description:
        "View status information about alerts initiated during an emergency, tracking dispatch progress and recipient notifications.",
      icon: CheckCircle2,
      badge: "Real-Time",
      featured: false,
      accent: "from-emerald-500 to-teal-600",
    },
  ];

  return (
    <section id="features" className="py-20 sm:py-28 bg-white relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Section Header */}
        <div className="text-center max-w-2xl mx-auto mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#FFE7EC] border border-[#F3E4E6] text-xs font-bold text-[#F04455] uppercase tracking-wider mb-4">
            Designed for Protection
          </div>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-[#18243A] tracking-tight">
            Safety Features Designed Around You.
          </h2>
          <p className="mt-4 text-base sm:text-lg text-[#707786]">
            Thoughtful tools that help you connect with trusted support, stay informed, and manage
            your safety with confidence.
          </p>
        </div>

        {/* Feature Grid with visual hierarchy */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8">
          {features.map((feature, idx) => {
            const Icon = feature.icon;
            return (
              <motion.div
                key={feature.id}
                initial={{ opacity: 0, y: 16 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.4, delay: idx * 0.08 }}
                className={`relative rounded-3xl p-7 border transition-all duration-300 flex flex-col justify-between group ${
                  feature.featured
                    ? "bg-gradient-to-br from-[#FFF8F8] to-[#FFF0F3] border-[#F3E4E6] shadow-soft-card hover:shadow-xl hover:-translate-y-1"
                    : "bg-white border-[#F3E4E6] hover:border-[#F04455]/40 hover:shadow-lg hover:-translate-y-1"
                }`}
              >
                <div>
                  {/* Top Bar with Icon & Badge */}
                  <div className="flex items-center justify-between mb-5">
                    <div
                      className={`w-12 h-12 rounded-2xl bg-gradient-to-tr ${feature.accent} text-white flex items-center justify-center shadow-sm group-hover:scale-105 transition-transform duration-200`}
                    >
                      <Icon className="w-6 h-6" />
                    </div>
                    <span
                      className={`text-[11px] font-bold px-2.5 py-1 rounded-full border ${
                        feature.isComingSoon
                          ? "bg-amber-50 text-amber-700 border-amber-200"
                          : "bg-white text-[#18243A] border-[#F3E4E6]"
                      }`}
                    >
                      {feature.badge}
                    </span>
                  </div>

                  <h3 className="text-xl font-bold text-[#18243A] mb-2 group-hover:text-[#F04455] transition-colors">
                    {feature.title}
                  </h3>
                  <p className="text-sm text-[#707786] leading-relaxed">
                    {feature.description}
                  </p>
                </div>

                <div className="mt-6 pt-4 border-t border-[#F3E4E6]/60 flex items-center text-xs font-semibold text-[#F04455]">
                  <span>Learn how it works</span>
                  <ArrowRight className="w-3.5 h-3.5 ml-1.5 group-hover:translate-x-1 transition-transform" />
                </div>
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
