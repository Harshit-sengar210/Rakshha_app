import React from "react";
import Link from "next/link";
import { Navbar } from "@/components/Navbar";
import { Footer } from "@/components/Footer";
import { HowItWorks } from "@/components/HowItWorks";
import { EmergencyShowcase } from "@/components/EmergencyShowcase";
import { ArrowLeft } from "lucide-react";

export const metadata = {
  title: "How Rakshaa Works — Setup to Emergency Alert Flow",
  description: "Step-by-step walkthrough of how Rakshaa safeguards you and alerts your emergency contacts.",
};

export default function HowItWorksPage() {
  return (
    <div className="min-h-screen flex flex-col bg-[#FFF8F8]">
      <Navbar />
      <main className="flex-1 pt-24">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <Link
            href="/"
            className="inline-flex items-center gap-2 text-xs font-bold text-[#F04455] hover:underline"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Back to Home</span>
          </Link>
        </div>
        <HowItWorks />
        <EmergencyShowcase />
      </main>
      <Footer />
    </div>
  );
}
