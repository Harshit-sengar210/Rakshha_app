"use client";

import React from "react";
import { ShieldAlert, Users, MapPin, History } from "lucide-react";

export function TrustStrip() {
  const benefits = [
    {
      icon: ShieldAlert,
      title: "Quick Emergency Access",
      subtitle: "Instant SOS trigger & 112 dialing",
    },
    {
      icon: Users,
      title: "Trusted Contact Network",
      subtitle: "Priority contact & loved ones alerts",
    },
    {
      icon: MapPin,
      title: "Location Sharing During Emergencies",
      subtitle: "Live GPS broadcast during active SOS",
    },
    {
      icon: History,
      title: "Emergency History",
      subtitle: "Complete session & timeline logs",
    },
  ];

  return (
    <section className="relative z-10 py-8 bg-white border-y border-[#F3E4E6]">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-6 lg:gap-8">
          {benefits.map((item, index) => {
            const Icon = item.icon;
            return (
              <div
                key={index}
                className="flex items-center gap-3.5 p-2 rounded-xl transition-all duration-200"
              >
                <div className="w-11 h-11 rounded-xl bg-[#FFE7EC] flex items-center justify-center shrink-0 border border-[#F3E4E6]">
                  <Icon className="w-5 h-5 text-[#F04455]" />
                </div>
                <div>
                  <h4 className="text-sm font-bold text-[#18243A] leading-tight">{item.title}</h4>
                  <p className="text-xs text-[#707786] mt-0.5 leading-tight">{item.subtitle}</p>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
