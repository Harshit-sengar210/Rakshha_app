import type { Metadata } from "next";
import "./globals.css";
import { siteConfig } from "@/config/site";

export const metadata: Metadata = {
  metadataBase: new URL(siteConfig.url),
  title: `${siteConfig.name} — ${siteConfig.tagline}`,
  description: siteConfig.description,
  keywords: [
    "women safety app",
    "emergency sos",
    "live location sharing",
    "personal security",
    "quick sos",
    "trusted contacts",
    "rakshaa safety",
  ],
  authors: [{ name: "Rakshaa Team" }],
  icons: {
    icon: "/app_logo.png",
    apple: "/app_logo.png",
  },
  openGraph: {
    title: `${siteConfig.name} — ${siteConfig.tagline}`,
    description: siteConfig.description,
    url: siteConfig.url,
    siteName: siteConfig.name,
    images: [
      {
        url: "/app_logo.png",
        width: 512,
        height: 512,
        alt: "Rakshaa Women's Safety App",
      },
    ],
    locale: "en_IN",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="scroll-smooth">
      <head>
        <link rel="icon" href="/app_logo.png" sizes="any" />
      </head>
      <body className="min-h-screen bg-[#FFF8F8] text-[#18243A] antialiased selection:bg-[#FFE7EC] selection:text-[#F04455]">
        {children}
      </body>
    </html>
  );
}
