export interface SiteConfig {
  name: string;
  wordmark: string;
  tagline: string;
  description: string;
  url: string;
  ogImage: string;
  links: {
    github?: string;
    supportEmail: string;
    adminPortal: string;
    emergencyCall: string;
  };
  navigation: Array<{
    title: string;
    href: string;
  }>;
}

export const siteConfig: SiteConfig = {
  name: "Rakshaa",
  wordmark: "RAKSHAA",
  tagline: "Your Safety. Always Within Reach.",
  description:
    "Rakshaa helps you stay connected to the people you trust when you need support. Activate an emergency alert, share your live location during an emergency, and keep your trusted contacts informed.",
  url: "https://rakshaa.app",
  ogImage: "/app_logo.png",
  links: {
    supportEmail: "support@rakshaa.app",
    adminPortal: "/login",
    emergencyCall: "tel:112",
  },
  navigation: [
    { title: "Home", href: "/#hero" },
    { title: "Features", href: "/#features" },
    { title: "How It Works", href: "/#how-it-works" },
    { title: "Safety Tools", href: "/#safety-tools" },
    { title: "Quick SOS", href: "/#quick-sos" },
    { title: "FAQ", href: "/#faq" },
  ],
};
