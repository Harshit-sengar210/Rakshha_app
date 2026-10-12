import React from "react";
import { Navbar } from "@/components/Navbar";
import { HeroSection } from "@/components/HeroSection";
import { TrustStrip } from "@/components/TrustStrip";
import { HowItWorks } from "@/components/HowItWorks";
import { FeaturesSection } from "@/components/FeaturesSection";
import { QuickSOSSection } from "@/components/QuickSOSSection";
import { SafetyToolsSection } from "@/components/SafetyToolsSection";
import { EmergencyShowcase } from "@/components/EmergencyShowcase";
import { BrandPurpose } from "@/components/BrandPurpose";
import { DownloadSection } from "@/components/DownloadSection";
import { FAQSection } from "@/components/FAQSection";
import { SupportSection } from "@/components/SupportSection";
import { Footer } from "@/components/Footer";

export default function LandingPage() {
  return (
    <div className="min-h-screen flex flex-col bg-[#FFF8F8] selection:bg-[#FFE7EC] selection:text-[#F04455]">
      {/* Sticky Top Navigation */}
      <Navbar />

      {/* Main Page Flow */}
      <main className="flex-1">
        {/* 1. Hero Section */}
        <HeroSection />

        {/* 2. Trust Strip */}
        <TrustStrip />

        {/* 3. How Rakshaa Works */}
        <HowItWorks />

        {/* 4. Core Features Grid */}
        <FeaturesSection />

        {/* 5. Dedicated Quick SOS Showcase */}
        <QuickSOSSection />

        {/* 6. Smart Safety Tools Suite */}
        <SafetyToolsSection />

        {/* 7. Emergency Response Experience & Timeline */}
        <EmergencyShowcase />

        {/* 8. Brand Purpose & Reassurance */}
        <BrandPurpose />

        {/* 9. Official Android APK Download */}
        <DownloadSection />

        {/* 10. Frequently Asked Questions */}
        <FAQSection />

        {/* 11. Support & Contact */}
        <SupportSection />
      </main>

      {/* Footer */}
      <Footer />
    </div>
  );
}
